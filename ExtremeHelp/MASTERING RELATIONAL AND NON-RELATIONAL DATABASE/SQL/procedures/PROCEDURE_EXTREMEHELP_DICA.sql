CREATE OR REPLACE PROCEDURE sp_inserir_dica_preparacao (
    p_ds_titulo IN VARCHAR2,
    p_ds_contudo IN CLOB,
    p_ds_categoria IN VARCHAR2,
    p_cd_dica OUT NUMBER
) AS
BEGIN
    -- Gerar novo ID
    SELECT NVL(MAX(CD_DICA), 0) + 1 INTO p_cd_dica FROM T_EH_DICA_PREPARACAO;
    
    -- Inserir nova dica
    INSERT INTO T_EH_DICA_PREPARACAO (
        CD_DICA,
        DS_TITULO,
        DS_CONTRUDO,
        DS_CATEGORIA,
        DT_ULTIMA_ATUALIZACAO
    ) VALUES (
        p_cd_dica,
        p_ds_titulo,
        p_ds_contudo,
        p_ds_categoria,
        SYSDATE
    );
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dica de prepara��o inserida com sucesso. ID: ' || p_cd_dica);
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao inserir dica de prepara��o: ' || SQLERRM);
        RAISE;
END sp_inserir_dica_preparacao;
/

CREATE OR REPLACE PROCEDURE sp_atualizar_dica_preparacao (
    p_cd_dica IN NUMBER,
    p_ds_titulo IN VARCHAR2 DEFAULT NULL,
    p_ds_contudo IN CLOB DEFAULT NULL,
    p_ds_categoria IN VARCHAR2 DEFAULT NULL
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se a dica existe
    SELECT COUNT(*) INTO v_count FROM T_EH_DICA_PREPARACAO WHERE CD_DICA = p_cd_dica;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Dica n�o encontrada.');
        RETURN;
    END IF;
    
    -- Atualizar apenas os campos fornecidos
    UPDATE T_EH_DICA_PREPARACAO SET
        DS_TITULO = NVL(p_ds_titulo, DS_TITULO),
        DS_CONTRUDO = NVL(p_ds_contudo, DS_CONTRUDO),
        DS_CATEGORIA = NVL(p_ds_categoria, DS_CATEGORIA),
        DT_ULTIMA_ATUALIZACAO = SYSDATE
    WHERE CD_DICA = p_cd_dica;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dica de prepara��o atualizada com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao atualizar dica de prepara��o: ' || SQLERRM);
        RAISE;
END sp_atualizar_dica_preparacao;
/

CREATE OR REPLACE PROCEDURE sp_excluir_dica_preparacao (
    p_cd_dica IN NUMBER
) AS
    v_count NUMBER;
BEGIN
    -- Verificar se a dica existe
    SELECT COUNT(*) INTO v_count FROM T_EH_DICA_PREPARACAO WHERE CD_DICA = p_cd_dica;
    
    IF v_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('Dica n�o encontrada.');
        RETURN;
    END IF;
    
    -- Excluir dica
    DELETE FROM T_EH_DICA_PREPARACAO WHERE CD_DICA = p_cd_dica;
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('Dica de prepara��o exclu�da com sucesso.');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Erro ao excluir dica de prepara��o: ' || SQLERRM);
        RAISE;
END sp_excluir_dica_preparacao;
/

DECLARE
    v_dica_id NUMBER;
BEGIN
    -- Dica 1
    sp_inserir_dica_preparacao(
        'Kit de emerg�ncia b�sico', 
        'Prepare um kit com: �gua (3 litros por pessoa), alimentos n�o perec�veis, lanternas, r�dio a pilhas, kit de primeiros socorros, documentos importantes e medicamentos essenciais.', 
        'GERAL', 
        v_dica_id
    );
    
    -- Dica 2
    sp_inserir_dica_preparacao(
        'O que fazer durante enchentes', 
        '1. Evite contato com a �gua da enchente\n2. Desligue a energia el�trica se a �gua entrar em casa\n3. N�o tente dirigir em �reas alagadas\n4. Siga para �reas elevadas', 
        'ENCHENTE', 
        v_dica_id
    );
    
    -- Dica 3
    sp_inserir_dica_preparacao(
        'Prepara��o para tempestades', 
        'Proteja janelas com t�buas ou persianas, guarde objetos que possam ser levados pelo vento, tenha um local seguro no interior da casa e monitore alertas oficiais.', 
        'TEMPESTADE', 
        v_dica_id
    );
    
    -- Dica 4
    sp_inserir_dica_preparacao(
        'Plano familiar de emerg�ncia', 
        'Combine com sua fam�lia:\n1. Um local seguro para se encontrar\n2. Contatos de emerg�ncia\n3. Rotas de fuga da casa\n4. Responsabilidades de cada um', 
        'GERAL', 
        v_dica_id
    );
    
    -- Dica 5
    sp_inserir_dica_preparacao(
        'Cuidados com alimentos ap�s falta de energia', 
        'Mantenha a geladeira fechada (dura at� 4h), use gelo seco se poss�vel, descarte alimentos perec�veis que ficaram acima de 5�C por mais de 2 horas.', 
        'ALIMENTACAO', 
        v_dica_id
    );
END;
/