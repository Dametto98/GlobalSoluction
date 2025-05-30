CREATE OR REPLACE PROCEDURE sp_inserir_pedido_ajuda (
    p_cd_usuario IN NUMBER,
    p_ds_tipo IN VARCHAR2,
    p_ds_descricao IN VARCHAR2,
    p_ds_latitude IN NUMBER,
    p_ds_longitude IN NUMBER,
    p_ds_endereco IN VARCHAR2 DEFAULT NULL,
    p_ds_status IN VARCHAR2,
    p_cd_pedido OUT NUMBER
) AS
    v_usuario_existe NUMBER;
BEGIN
    -- Verificar se o usuário existe
    SELECT COUNT(*) INTO v_usuario_existe FROM T_EH_USUARIO WHERE CD_USUARIO = p_cd_usuario;
    
    IF v_usuario_existe = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado.');
        RETURN;
    END IF;
    
    -- Gerar novo ID
    SELECT NVL(MAX(CD_PEDIDO), 0) + 1 INTO p_cd_pedido FROM T_EH_PEDIDO_AJUDA;
    
    -- Inserir novo pedido
    INSERT INTO T_EH_PEDIDO_AJUDA (
        CD_PEDIDO,
        CD_USUARIO,
        DS_TIPO,
        DS_DESCRICAO,
        DS_LATITUDE,
        DS_LONGITUDE,
        DS_ENDERECO,
        DT_PEDIDO,
        DS_STATUS
    ) VALUES (
        p_cd_pedido,
        p_cd_usuario,
        p_ds_tipo,
        p_ds_descricao,
        p_ds_latitude,
        p_ds_longitude,
        p_ds_endereco,
        SYSDATE,
        p_ds_status
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido de ajuda inserido com sucesso. ID: ' || p_cd_pedido);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir pedido de ajuda: ' || SQLERRM);
        RAISE;
END sp_inserir_pedido_ajuda;
/

CREATE OR REPLACE PROCEDURE sp_atualizar_pedido_ajuda (
    p_cd_pedido IN NUMBER,
    p_ds_tipo IN VARCHAR2 DEFAULT NULL,
    p_ds_descricao IN VARCHAR2 DEFAULT NULL,
    p_ds_latitude IN NUMBER DEFAULT NULL,
    p_ds_longitude IN NUMBER DEFAULT NULL,
    p_ds_endereco IN VARCHAR2 DEFAULT NULL,
    p_ds_status IN VARCHAR2 DEFAULT NULL
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se o pedido existe
    SELECT COUNT(*) INTO v_count FROM T_EH_PEDIDO_AJUDA WHERE CD_PEDIDO = p_cd_pedido;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
        RETURN;
    END IF;
    
    -- Atualizar apenas os campos fornecidos
    UPDATE T_EH_PEDIDO_AJUDA SET
        DS_TIPO = NVL(p_ds_tipo, DS_TIPO),
        DS_DESCRICAO = NVL(p_ds_descricao, DS_DESCRICAO),
        DS_LATITUDE = NVL(p_ds_latitude, DS_LATITUDE),
        DS_LONGITUDE = NVL(p_ds_longitude, DS_LONGITUDE),
        DS_ENDERECO = NVL(p_ds_endereco, DS_ENDERECO),
        DS_STATUS = NVL(p_ds_status, DS_STATUS)
    WHERE CD_PEDIDO = p_cd_pedido;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido de ajuda atualizado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar pedido de ajuda: ' || SQLERRM);
        RAISE;
END sp_atualizar_pedido_ajuda;
/

CREATE OR REPLACE PROCEDURE sp_excluir_pedido_ajuda (
    p_cd_pedido IN NUMBER
) AS
    v_count NUMBER;
    v_atendimentos NUMBER;
BEGIN
    -- Verificar se o pedido existe
    SELECT COUNT(*) INTO v_count FROM T_EH_PEDIDO_AJUDA WHERE CD_PEDIDO = p_cd_pedido;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
        RETURN;
    END IF;
    
    -- Verificar se o pedido tem atendimentos associados
    SELECT COUNT(*) INTO v_atendimentos 
    FROM T_EH_ATENDIMENTO_VOLUNTARIO 
    WHERE CD_PEDIDO = p_cd_pedido;
    
    IF v_atendimentos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Não é possível excluir pedido com atendimentos associados.');
        RETURN;
    END IF;
    
    -- Excluir pedido
    DELETE FROM T_EH_PEDIDO_AJUDA WHERE CD_PEDIDO = p_cd_pedido;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Pedido de ajuda excluído com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir pedido de ajuda: ' || SQLERRM);
        RAISE;
END sp_excluir_pedido_ajuda;
/

DECLARE
    v_pedido_id NUMBER;
BEGIN
    -- Pedido 1
    sp_inserir_pedido_ajuda(
        2, -- CD_USUARIO (Maria Souza)
        'ALIMENTACAO', 
        'Preciso de ajuda com alimentos para minha família', 
        -23.5505199, 
        -46.6333094, 
        'Rua Exemplo, 123 - São Paulo/SP', 
        'PENDENTE', 
        v_pedido_id
    );
    
    -- Pedido 2
    sp_inserir_pedido_ajuda(
        2, -- CD_USUARIO (Maria Souza)
        'MEDICAMENTOS', 
        'Necessito de remédios para hipertensão', 
        -22.9068467, 
        -43.1728965, 
        'Av. Brasil, 1000 - Rio de Janeiro/RJ', 
        'PENDENTE', 
        v_pedido_id
    );
    
    -- Pedido 3
    sp_inserir_pedido_ajuda(
        2, -- CD_USUARIO (Maria Souza)
        'TRANSPORTE', 
        'Preciso de carona para consulta médica', 
        -19.919052, 
        -43.938668, 
        'Rua da Bahia, 200 - Belo Horizonte/MG', 
        'PENDENTE', 
        v_pedido_id
    );
    
    -- Pedido 4
    sp_inserir_pedido_ajuda(
        2, -- CD_USUARIO (Maria Souza)
        'ALIMENTACAO', 
        'Cesta básica para família de 4 pessoas', 
        -12.9715989, 
        -38.5018959, 
        'Largo do Pelourinho, 15 - Salvador/BA', 
        'PENDENTE', 
        v_pedido_id
    );
    
    -- Pedido 5
    sp_inserir_pedido_ajuda(
        2, -- CD_USUARIO (Maria Souza)
        'OUTROS', 
        'Ajuda com reparos em casa após enchente', 
        -30.0346471, 
        -51.2176584, 
        'Av. Borges de Medeiros, 500 - Porto Alegre/RS', 
        'PENDENTE', 
        v_pedido_id
    );
END;
/