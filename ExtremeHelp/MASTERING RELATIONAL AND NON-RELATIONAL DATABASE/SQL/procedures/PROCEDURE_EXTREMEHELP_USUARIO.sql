CREATE OR REPLACE PROCEDURE sp_inserir_usuario (
    p_nm_usuario IN VARCHAR2,
    p_ds_email IN VARCHAR2,
    p_ds_senha IN VARCHAR2,
    p_ds_telefone IN VARCHAR2 DEFAULT NULL,
    p_ds_tipo IN VARCHAR2,
    p_ds_status IN NUMBER,
    p_cd_usuario OUT NUMBER
) AS
BEGIN
    -- Gerar novo ID
    SELECT NVL(MAX(CD_USUARIO), 0) + 1 INTO p_cd_usuario FROM T_EH_USUARIO;
    
    -- Inserir novo usuário
    INSERT INTO T_EH_USUARIO (
        CD_USUARIO,
        NM_USUARIO,
        DS_EMAIL,
        DS_SENHA,
        DS_TELEFONE,
        DS_TIPO,
        DT_REGISTRO,
        DS_STATUS
    ) VALUES (
        p_cd_usuario,
        p_nm_usuario,
        p_ds_email,
        p_ds_senha,
        p_ds_telefone,
        p_ds_tipo,
        SYSDATE,
        p_ds_status
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuário inserido com sucesso. ID: ' || p_cd_usuario);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir usuário: ' || SQLERRM);
        RAISE;
END sp_inserir_usuario;
/

CREATE OR REPLACE PROCEDURE sp_atualizar_usuario (
    p_cd_usuario IN NUMBER,
    p_nm_usuario IN VARCHAR2 DEFAULT NULL,
    p_ds_email IN VARCHAR2 DEFAULT NULL,
    p_ds_senha IN VARCHAR2 DEFAULT NULL,
    p_ds_telefone IN VARCHAR2 DEFAULT NULL,
    p_ds_tipo IN VARCHAR2 DEFAULT NULL,
    p_ds_status IN NUMBER DEFAULT NULL
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se o usuário existe
    SELECT COUNT(*) INTO v_count FROM T_EH_USUARIO WHERE CD_USUARIO = p_cd_usuario;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado.');
        RETURN;
    END IF;
    
    -- Atualizar apenas os campos fornecidos
    UPDATE T_EH_USUARIO SET
        NM_USUARIO = NVL(p_nm_usuario, NM_USUARIO),
        DS_EMAIL = NVL(p_ds_email, DS_EMAIL),
        DS_SENHA = NVL(p_ds_senha, DS_SENHA),
        DS_TELEFONE = NVL(p_ds_telefone, DS_TELEFONE),
        DS_TIPO = NVL(p_ds_tipo, DS_TIPO),
        DS_STATUS = NVL(p_ds_status, DS_STATUS)
    WHERE CD_USUARIO = p_cd_usuario;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuário atualizado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar usuário: ' || SQLERRM);
        RAISE;
END sp_atualizar_usuario;
/

CREATE OR REPLACE PROCEDURE sp_excluir_usuario (
    p_cd_usuario IN NUMBER
) AS
    v_count NUMBER;
    v_pedidos NUMBER;
BEGIN
    -- Verificar se o usuário existe
    SELECT COUNT(*) INTO v_count FROM T_EH_USUARIO WHERE CD_USUARIO = p_cd_usuario;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado.');
        RETURN;
    END IF;
    
    -- Verificar se o usuário tem pedidos associados
    SELECT COUNT(*) INTO v_pedidos FROM T_EH_PEDIDO_AJUDA WHERE CD_USUARIO = p_cd_usuario;
    
    IF v_pedidos > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Não é possível excluir usuário com pedidos associados.');
        RETURN;
    END IF;
    
    -- Excluir usuário
    DELETE FROM T_EH_USUARIO WHERE CD_USUARIO = p_cd_usuario;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Usuário excluído com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir usuário: ' || SQLERRM);
        RAISE;
END sp_excluir_usuario;
/

DECLARE
    v_id NUMBER;
BEGIN
    -- Usuário 1
    sp_inserir_usuario(
        'João Silva', 
        'joao.silva@email.com', 
        'senha123', 
        '11987654321', 
        'VOLUNTARIO', 
        1, 
        v_id
    );
    
    -- Usuário 2
    sp_inserir_usuario(
        'Maria Souza', 
        'maria.souza@email.com', 
        'senha456', 
        '21987654321', 
        'SOLICITANTE', 
        1, 
        v_id
    );
    
    -- Usuário 3
    sp_inserir_usuario(
        'Carlos Oliveira', 
        'carlos.oliveira@email.com', 
        'senha789', 
        '31987654321', 
        'VOLUNTARIO', 
        1, 
        v_id
    );
    
    -- Usuário 4
    sp_inserir_usuario(
        'Ana Santos', 
        'ana.santos@email.com', 
        'senha101', 
        '41987654321', 
        'ADMINISTRADOR', 
        1, 
        v_id
    );
    
    -- Usuário 5
    sp_inserir_usuario(
        'Pedro Costa', 
        'pedro.costa@email.com', 
        'senha112', 
        '51987654321', 
        'VOLUNTARIO', 
        1, 
        v_id
    );
END;
/