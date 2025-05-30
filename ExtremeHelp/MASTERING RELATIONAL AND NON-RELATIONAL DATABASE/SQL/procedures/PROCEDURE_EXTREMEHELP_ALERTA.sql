CREATE OR REPLACE PROCEDURE sp_inserir_alerta (
    p_ds_titulo IN VARCHAR2,
    p_ds_mensagem IN VARCHAR2,
    p_ds_seriedade IN VARCHAR2,
    p_ds_fonte IN VARCHAR2 DEFAULT NULL,
    p_ds_ativo IN NUMBER,
    p_cd_alerta OUT NUMBER
) AS
BEGIN
    -- Gerar novo ID
    SELECT NVL(MAX(CD_ALERTA), 0) + 1 INTO p_cd_alerta FROM T_EH_ALERTA;
    
    -- Inserir novo alerta
    INSERT INTO T_EH_ALERTA (
        CD_ALERTA,
        DS_TITULO,
        DS_MENSAGEM,
        DT_PUBLICACAO,
        DS_SERIEDADE,
        DS_FONTE,
        DS_ATIVO
    ) VALUES (
        p_cd_alerta,
        p_ds_titulo,
        p_ds_mensagem,
        SYSDATE,
        p_ds_seriedade,
        p_ds_fonte,
        p_ds_ativo
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alerta inserido com sucesso. ID: ' || p_cd_alerta);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir alerta: ' || SQLERRM);
        RAISE;
END sp_inserir_alerta;
/

CREATE OR REPLACE PROCEDURE sp_atualizar_alerta (
    p_cd_alerta IN NUMBER,
    p_ds_titulo IN VARCHAR2 DEFAULT NULL,
    p_ds_mensagem IN VARCHAR2 DEFAULT NULL,
    p_ds_seriedade IN VARCHAR2 DEFAULT NULL,
    p_ds_fonte IN VARCHAR2 DEFAULT NULL,
    p_ds_ativo IN NUMBER DEFAULT NULL
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se o alerta existe
    SELECT COUNT(*) INTO v_count FROM T_EH_ALERTA WHERE CD_ALERTA = p_cd_alerta;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Alerta não encontrado.');
        RETURN;
    END IF;
    
    -- Atualizar apenas os campos fornecidos
    UPDATE T_EH_ALERTA SET
        DS_TITULO = NVL(p_ds_titulo, DS_TITULO),
        DS_MENSAGEM = NVL(p_ds_mensagem, DS_MENSAGEM),
        DS_SERIEDADE = NVL(p_ds_seriedade, DS_SERIEDADE),
        DS_FONTE = NVL(p_ds_fonte, DS_FONTE),
        DS_ATIVO = NVL(p_ds_ativo, DS_ATIVO)
    WHERE CD_ALERTA = p_cd_alerta;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alerta atualizado com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar alerta: ' || SQLERRM);
        RAISE;
END sp_atualizar_alerta;
/

CREATE OR REPLACE PROCEDURE sp_excluir_alerta (
    p_cd_alerta IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se o alerta existe
    SELECT COUNT(*) INTO v_count FROM T_EH_ALERTA WHERE CD_ALERTA = p_cd_alerta;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Alerta não encontrado.');
        RETURN;
    END IF;
    
    -- Excluir alerta
    DELETE FROM T_EH_ALERTA WHERE CD_ALERTA = p_cd_alerta;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Alerta excluído com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir alerta: ' || SQLERRM);
        RAISE;
END sp_excluir_alerta;
/

DECLARE
    v_alerta_id NUMBER;
BEGIN
    -- Alerta 1
    sp_inserir_alerta(
        'Tempestade se aproximando', 
        'Uma forte tempestade está prevista para amanhã na região. Fique atento e evite áreas de risco.', 
        'ALTA', 
        'Defesa Civil', 
        1, 
        v_alerta_id
    );
    
    -- Alerta 2
    sp_inserir_alerta(
        'Alerta de enchente', 
        'Nível do rio está subindo rapidamente. Moradores das áreas baixas devem se preparar.', 
        'CRITICA', 
        'CEMADEN', 
        1, 
        v_alerta_id
    );
    
    -- Alerta 3
    sp_inserir_alerta(
        'Onda de calor', 
        'Temperaturas acima de 40°C previstas para os próximos dias. Mantenha-se hidratado.', 
        'MEDIA', 
        'INMET', 
        1, 
        v_alerta_id
    );
    
    -- Alerta 4
    sp_inserir_alerta(
        'Deslizamento de terra', 
        'Áreas de encosta estão instáveis após chuvas intensas. Evite trafegar por estas regiões.', 
        'ALTA', 
        'Defesa Civil', 
        1, 
        v_alerta_id
    );
    
    -- Alerta 5
    sp_inserir_alerta(
        'Corte de energia programado', 
        'Manutenção na rede elétrica ocorrerá das 8h às 12h no bairro Centro.', 
        'BAIXA', 
        'Companhia de Energia', 
        1, 
        v_alerta_id
    );
END;
/