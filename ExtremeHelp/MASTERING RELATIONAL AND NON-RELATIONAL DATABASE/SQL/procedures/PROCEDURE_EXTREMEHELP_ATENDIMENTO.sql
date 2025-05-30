CREATE OR REPLACE PROCEDURE sp_inserir_atendimento (
    p_cd_pedido IN NUMBER,
    p_cd_usuario IN NUMBER,
    p_ds_observacoes IN VARCHAR2 DEFAULT NULL,
    p_cd_atendimento OUT NUMBER
) AS
    v_pedido_existe NUMBER;
    v_usuario_existe NUMBER;
    v_pedido_status VARCHAR2(20);
BEGIN
    -- Verificar se o pedido existe
    SELECT COUNT(*) INTO v_pedido_existe FROM T_EH_PEDIDO_AJUDA WHERE CD_PEDIDO = p_cd_pedido;
    
    IF v_pedido_existe = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não encontrado.');
        RETURN;
    END IF;
    
    -- Verificar se o usuário existe
    SELECT COUNT(*) INTO v_usuario_existe FROM T_EH_USUARIO WHERE CD_USUARIO = p_cd_usuario;
    
    IF v_usuario_existe = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Usuário não encontrado.');
        RETURN;
    END IF;
    
    -- Verificar status do pedido
    SELECT DS_STATUS INTO v_pedido_status FROM T_EH_PEDIDO_AJUDA WHERE CD_PEDIDO = p_cd_pedido;
    
    IF v_pedido_status != 'PENDENTE' THEN
        DBMS_OUTPUT.PUT_LINE('Pedido não está mais pendente.');
        RETURN;
    END IF;
    
    -- Gerar novo ID
    SELECT NVL(MAX(CD_ATENDIMENTO), 0) + 1 INTO p_cd_atendimento FROM T_EH_ATENDIMENTO_VOLUNTARIO;
    
    -- Inserir novo atendimento
    INSERT INTO T_EH_ATENDIMENTO_VOLUNTARIO (
        CD_ATENDIMENTO,
        CD_PEDIDO,
        CD_USUARIO,
        DT_MOMENTO_ACEITE,
        DT_MOMENTO_CONCLUSAO,
        DS_OBSERVACOES
    ) VALUES (
        p_cd_atendimento,
        p_cd_pedido,
        p_cd_usuario,
        SYSDATE,
        NULL,
        p_ds_observacoes
    );
    
    -- Atualizar status do pedido para "EM_ANDAMENTO"
    UPDATE T_EH_PEDIDO_AJUDA 
    SET DS_STATUS = 'EM_ANDAMENTO'
    WHERE CD_PEDIDO = p_cd_pedido;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Atendimento voluntário inserido com sucesso. ID: ' || p_cd_atendimento);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir atendimento voluntário: ' || SQLERRM);
        RAISE;
END sp_inserir_atendimento;
/

CREATE OR REPLACE PROCEDURE sp_atualizar_atendimento (
    p_cd_atendimento IN NUMBER,
    p_ds_observacoes IN VARCHAR2 DEFAULT NULL,
    p_concluir IN BOOLEAN DEFAULT FALSE
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se o atendimento existe
    SELECT COUNT(*) INTO v_count FROM T_EH_ATENDIMENTO_VOLUNTARIO WHERE CD_ATENDIMENTO = p_cd_atendimento;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Atendimento não encontrado.');
        RETURN;
    END IF;
    
    -- Atualizar atendimento
    -- Atualizar atendimento
    IF p_concluir THEN
        UPDATE T_EH_ATENDIMENTO_VOLUNTARIO SET
            DS_OBSERVACOES = NVL(p_ds_observacoes, DS_OBSERVACOES),
            DT_MOMENTO_CONCLUSAO = SYSDATE
        WHERE CD_ATENDIMENTO = p_cd_atendimento;
    ELSE
        UPDATE T_EH_ATENDIMENTO_VOLUNTARIO SET
            DS_OBSERVACOES = NVL(p_ds_observacoes, DS_OBSERVACOES)
        WHERE CD_ATENDIMENTO = p_cd_atendimento;
    END IF;

    -- Se estiver concluindo, atualizar status do pedido
    IF p_concluir THEN
        UPDATE T_EH_PEDIDO_AJUDA pa
        SET pa.DS_STATUS = 'CONCLUIDO'
        WHERE pa.CD_PEDIDO = (
            SELECT av.CD_PEDIDO 
            FROM T_EH_ATENDIMENTO_VOLUNTARIO av 
            WHERE av.CD_ATENDIMENTO = p_cd_atendimento
        );
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Atendimento voluntário atualizado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar atendimento voluntário: ' || SQLERRM);
        RAISE;
END sp_atualizar_atendimento;
/

CREATE OR REPLACE PROCEDURE sp_excluir_atendimento (
    p_cd_atendimento IN NUMBER
) AS
    v_count NUMBER;
    v_pedido_id NUMBER;
BEGIN
    -- Verificar se o atendimento existe
    SELECT COUNT(*) INTO v_count FROM T_EH_ATENDIMENTO_VOLUNTARIO WHERE CD_ATENDIMENTO = p_cd_atendimento;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Atendimento não encontrado.');
        RETURN;
    END IF;
    
    -- Obter ID do pedido associado
    SELECT CD_PEDIDO INTO v_pedido_id 
    FROM T_EH_ATENDIMENTO_VOLUNTARIO 
    WHERE CD_ATENDIMENTO = p_cd_atendimento;
    
    -- Excluir atendimento
    DELETE FROM T_EH_ATENDIMENTO_VOLUNTARIO WHERE CD_ATENDIMENTO = p_cd_atendimento;
    
    -- Verificar se ainda existem atendimentos para o pedido
    SELECT COUNT(*) INTO v_count 
    FROM T_EH_ATENDIMENTO_VOLUNTARIO 
    WHERE CD_PEDIDO = v_pedido_id;
    
    -- Se não houver mais atendimentos, voltar status do pedido para PENDENTE
    IF v_count = 0 THEN
        UPDATE T_EH_PEDIDO_AJUDA 
        SET DS_STATUS = 'PENDENTE'
        WHERE CD_PEDIDO = v_pedido_id;
    END IF;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Atendimento voluntário excluído com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir atendimento voluntário: ' || SQLERRM);
        RAISE;
END sp_excluir_atendimento;
/

DECLARE
    v_atendimento_id NUMBER;
BEGIN
    -- Atendimento 1
    sp_inserir_atendimento(
        1, -- CD_PEDIDO
        1, -- CD_USUARIO (João Silva)
        'Entregarei os alimentos no sábado', 
        v_atendimento_id
    );
    
    -- Atendimento 2
    sp_inserir_atendimento(
        2, -- CD_PEDIDO
        3, -- CD_USUARIO (Carlos Oliveira)
        'Comprei os medicamentos e entregarei amanhã', 
        v_atendimento_id
    );
    
    -- Atendimento 3
    sp_inserir_atendimento(
        3, -- CD_PEDIDO
        5, -- CD_USUARIO (Pedro Costa)
        'Posso dar carona na quarta-feira', 
        v_atendimento_id
    );
    
    -- Concluir alguns atendimentos
    sp_atualizar_atendimento(1, NULL, TRUE);
    sp_atualizar_atendimento(2, 'Medicamentos entregues com sucesso', TRUE);
END;
/