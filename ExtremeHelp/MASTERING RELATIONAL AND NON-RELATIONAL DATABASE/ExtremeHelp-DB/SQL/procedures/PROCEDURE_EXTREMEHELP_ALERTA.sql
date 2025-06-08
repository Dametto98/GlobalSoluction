--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--INSERT
CREATE OR REPLACE PROCEDURE PRC_INSERT_ALERTA (
    p_ds_titulo       IN T_EH_ALERTA.DS_TITULO%TYPE,
    p_ds_mensagem     IN T_EH_ALERTA.DS_MENSAGEM%TYPE,
    p_dt_publicacao   IN T_EH_ALERTA.DT_PUBLICACAO%TYPE,
    p_ds_seriedade    IN T_EH_ALERTA.DS_SERIEDADE%TYPE,
    p_ds_fonte        IN T_EH_ALERTA.DS_FONTE%TYPE DEFAULT NULL,
    p_ds_ativo        IN T_EH_ALERTA.DS_ATIVO%TYPE
)
IS
BEGIN
    INSERT INTO T_EH_ALERTA (
        CD_ALERTA,
        DS_TITULO,
        DS_MENSAGEM,
        DT_PUBLICACAO,
        DS_SERIEDADE,
        DS_FONTE,
        DS_ATIVO
    ) VALUES (
        SEQ_EH_ALERTA.NEXTVAL,
        p_ds_titulo,
        p_ds_mensagem,
        p_dt_publicacao,
        p_ds_seriedade,
        p_ds_fonte,
        p_ds_ativo
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_INSERT_ALERTA;
/

--UPDATE
CREATE OR REPLACE PROCEDURE PRC_UPDATE_ALERTA (
    p_cd_alerta       IN T_EH_ALERTA.CD_ALERTA%TYPE,
    p_ds_titulo       IN T_EH_ALERTA.DS_TITULO%TYPE DEFAULT NULL,
    p_ds_mensagem     IN T_EH_ALERTA.DS_MENSAGEM%TYPE DEFAULT NULL,
    p_dt_publicacao   IN T_EH_ALERTA.DT_PUBLICACAO%TYPE DEFAULT NULL,
    p_ds_seriedade    IN T_EH_ALERTA.DS_SERIEDADE%TYPE DEFAULT NULL,
    p_ds_fonte        IN T_EH_ALERTA.DS_FONTE%TYPE DEFAULT NULL,
    p_ds_ativo        IN T_EH_ALERTA.DS_ATIVO%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE T_EH_ALERTA
    SET
        DS_TITULO = NVL(p_ds_titulo, DS_TITULO),
        DS_MENSAGEM = NVL(p_ds_mensagem, DS_MENSAGEM),
        DT_PUBLICACAO = NVL(p_dt_publicacao, DT_PUBLICACAO),
        DS_SERIEDADE = NVL(p_ds_seriedade, DS_SERIEDADE),
        DS_FONTE = NVL(p_ds_fonte, DS_FONTE),
        DS_ATIVO = NVL(p_ds_ativo, DS_ATIVO)
    WHERE
        CD_ALERTA = p_cd_alerta;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_UPDATE_ALERTA;
/

--DELETE
CREATE OR REPLACE PROCEDURE PRC_DELETE_ALERTA (
    p_cd_alerta IN T_EH_ALERTA.CD_ALERTA%TYPE
)
IS
BEGIN
    DELETE FROM T_EH_ALERTA
    WHERE CD_ALERTA = p_cd_alerta;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_DELETE_ALERTA;
/

--Inserindo dados
BEGIN
    PRC_INSERT_ALERTA(
        p_ds_titulo       => 'Risco Elevado de Enchentes - Região Sul',
        p_ds_mensagem     => 'Devido às fortes chuvas contínuas, a Defesa Civil alerta para risco elevado de enchentes e deslizamentos na Região Sul da cidade. Evite áreas próximas a rios e encostas.',
        p_dt_publicacao   => TO_DATE('2025-06-03 08:00:00', 'YYYY-MM-DD HH24:MI:SS'), -- Hoje cedo
        p_ds_seriedade    => 'GRAVE',
        p_ds_fonte        => 'Defesa Civil Municipal',
        p_ds_ativo        => 1 -- Alerta ativo
    );

    PRC_INSERT_ALERTA(
        p_ds_titulo       => 'Onda de Calor Intenso Prevista',
        p_ds_mensagem     => 'Instituto Nacional de Meteorologia prevê uma onda de calor com temperaturas acima de 38°C para os próximos 5 dias. Mantenha-se hidratado e evite exposição solar excessiva entre 10h e 16h.',
        p_dt_publicacao   => SYSDATE - INTERVAL '1' DAY, -- Publicado ontem
        p_ds_seriedade    => 'MODERADO',
        p_ds_fonte        => 'INMET',
        p_ds_ativo        => 1 -- Alerta ativo
    );

    PRC_INSERT_ALERTA(
        p_ds_titulo       => 'Campanha de Vacinação Contra Gripe',
        p_ds_mensagem     => 'A Secretaria de Saúde informa que a campanha de vacinação contra a gripe foi prorrogada até o final do mês. Procure o posto de saúde mais próximo.',
        p_dt_publicacao   => SYSDATE - INTERVAL '3' DAY, -- Publicado 3 dias atrás
        p_ds_seriedade    => 'INFORMATIVO',
        p_ds_fonte        => 'Secretaria Municipal de Saúde',
        p_ds_ativo        => 1 -- Alerta ativo 
    );

    PRC_INSERT_ALERTA(
        p_ds_titulo       => 'Interdição de Via - Av. Principal',
        p_ds_mensagem     => 'A Av. Principal estará interditada no trecho entre a Rua A e Rua B para obras emergenciais no dia 05/06, das 09h às 17h. Procure rotas alternativas.',
        p_dt_publicacao   => TO_DATE('2025-06-02 17:00:00', 'YYYY-MM-DD HH24:MI:SS'), -- Publicado ontem à tarde
        p_ds_seriedade    => 'MODERADO',
        p_ds_fonte        => 'Departamento de Trânsito',
        p_ds_ativo        => 0 -- Alerta inativo
    );

    PRC_INSERT_ALERTA(
        p_ds_titulo       => 'Alerta de Nevoeiro Intenso na Serra',
        p_ds_mensagem     => 'Polícia Rodoviária alerta para nevoeiro intenso e baixa visibilidade nas estradas da serra durante a madrugada e início da manhã. Redobre a atenção e reduza a velocidade.',
        p_dt_publicacao   => SYSDATE, -- Publicado agora
        p_ds_seriedade    => 'GRAVE',
        p_ds_fonte        => 'Polícia Rodoviária Estadual',
        p_ds_ativo        => 1 -- Alerta ativo
    );
END;
/