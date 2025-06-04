--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--INSERT
REATE OR REPLACE PROCEDURE PRC_INSERT_DICA (
    p_ds_titulo             IN T_EH_DICA_PREPARACAO.DS_TITULO%TYPE,
    p_ds_conteudo           IN T_EH_DICA_PREPARACAO.DS_CONTEUDO%TYPE,
    p_ds_categoria          IN T_EH_DICA_PREPARACAO.DS_CATEGORIA%TYPE,
    p_dt_ultima_atualizacao IN T_EH_DICA_PREPARACAO.DT_ULTIMA_ATUALIZACAO%TYPE
)
IS
BEGIN
    INSERT INTO T_EH_DICA_PREPARACAO (
        CD_DICA,
        DS_TITULO,
        DS_CONTEUDO,
        DS_CATEGORIA,
        DT_ULTIMA_ATUALIZACAO
    ) VALUES (
        SEQ_EH_DICA_PREPARACAO.NEXTVAL,
        p_ds_titulo,
        p_ds_conteudo,
        p_ds_categoria,
        p_dt_ultima_atualizacao
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_INSERT_DICA;
/

--UPDATE
CREATE OR REPLACE PROCEDURE PRC_UPDATE_DICA (
    p_cd_dica               IN T_EH_DICA_PREPARACAO.CD_DICA%TYPE,
    p_ds_titulo             IN T_EH_DICA_PREPARACAO.DS_TITULO%TYPE DEFAULT NULL,
    p_ds_conteudo           IN T_EH_DICA_PREPARACAO.DS_CONTEUDO%TYPE DEFAULT NULL,
    p_ds_categoria          IN T_EH_DICA_PREPARACAO.DS_CATEGORIA%TYPE DEFAULT NULL,
    p_dt_ultima_atualizacao IN T_EH_DICA_PREPARACAO.DT_ULTIMA_ATUALIZACAO%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE T_EH_DICA_PREPARACAO
    SET
        DS_TITULO = NVL(p_ds_titulo, DS_TITULO),
        DS_CONTEUDO = NVL(p_ds_conteudo, DS_CONTEUDO),
        DS_CATEGORIA = NVL(p_ds_categoria, DS_CATEGORIA),
        DT_ULTIMA_ATUALIZACAO = NVL(p_dt_ultima_atualizacao, DT_ULTIMA_ATUALIZACAO)
    WHERE
        CD_DICA = p_cd_dica;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_UPDATE_DICA;
/

--DELETE
CREATE OR REPLACE PROCEDURE PRC_DELETE_DICA (
    p_cd_dica IN T_EH_DICA_PREPARACAO.CD_DICA%TYPE
)
IS
BEGIN
    DELETE FROM T_EH_DICA_PREPARACAO
    WHERE CD_DICA = p_cd_dica;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_DELETE_DICA;
/

--Inserindo dados
BEGIN
    PRC_INSERT_DICA(
        p_ds_titulo             => 'Como Montar seu Kit de Emergência Básico',
        p_ds_conteudo           => 'Um kit de emergência deve conter: água potável (1 galão por pessoa por dia, para 3 dias), alimentos não perecíveis (para 3 dias), rádio a pilha ou manivela, lanterna, pilhas extras, kit de primeiros socorros, apito para pedir ajuda, máscara contra poeira, lenços umedecidos, sacos de lixo, chave inglesa ou alicate para fechar registros, abridor de latas manual, mapas locais e celular carregado com carregador portátil.',
        p_ds_categoria          => 'Prevenção',
        p_dt_ultima_atualizacao => TO_DATE('2025-05-15 09:30:00', 'YYYY-MM-DD HH24:MI:SS')
    );

    PRC_INSERT_DICA(
        p_ds_titulo             => 'O que Fazer em Caso de Alagamento em Casa',
        p_ds_conteudo           => '1. Mantenha a calma. 2. Desligue a energia elétrica, o gás e a água. 3. Vá para um local seguro e elevado. 4. Evite contato com a água da enchente, pode estar contaminada. 5. Separe documentos importantes em local protegido. 6. Ouça as informações e alertas das autoridades.',
        p_ds_categoria          => 'Segurança',
        p_dt_ultima_atualizacao => TO_DATE('2025-05-28 11:00:00', 'YYYY-MM-DD HH24:MI:SS')
    );

    PRC_INSERT_DICA(
        p_ds_titulo             => 'Prevenção Contra Dengue, Zika e Chikungunya',
        p_ds_conteudo           => 'Elimine focos de água parada: verifique vasos de plantas, pneus velhos, calhas, garrafas e outros recipientes. Use repelente, especialmente em áreas de mata ou com muitos mosquitos. Instale telas em janelas e portas. Mantenha caixas d''água bem vedadas.',
        p_ds_categoria          => 'Saúde',
        p_dt_ultima_atualizacao => SYSDATE - INTERVAL '7' DAY -- Atualizado 7 dias atrás
    );

    PRC_INSERT_DICA(
        p_ds_titulo             => 'Como Agir em Caso de Incêndio Florestal Próximo',
        p_ds_conteudo           => '1. Ligue para os bombeiros (193) imediatamente. 2. Se o fogo estiver próximo, evacue a área em direção oposta ao vento. 3. Cubra nariz e boca com um pano úmido. 4. Feche portas e janelas da sua casa. 5. Remova materiais inflamáveis de perto da residência. 6. Siga as instruções das autoridades.',
        p_ds_categoria          => 'Segurança',
        p_dt_ultima_atualizacao => SYSDATE - INTERVAL '2' MONTH -- Atualizado 2 meses atrás
    );

    PRC_INSERT_DICA(
        p_ds_titulo             => 'Importância da Hidratação em Dias Quentes',
        p_ds_conteudo           => 'Beba água regularmente, mesmo sem sentir sede. Aumente a ingestão de líquidos durante atividades físicas ou em dias de calor intenso. Ofereça água frequentemente para crianças e idosos. Sucos naturais e água de coco também são boas opções. Evite bebidas açucaradas ou alcoólicas em excesso, pois podem desidratar.',
        p_ds_categoria          => 'Saúde',
        p_dt_ultima_atualizacao => SYSDATE -- Atualizado hoje
    );
END;
/