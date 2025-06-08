--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--INSERT
CREATE OR REPLACE PROCEDURE PRC_INSERT_ATEND_VOL (
    p_cd_pedido             IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_PEDIDO%TYPE,
    p_cd_usuario            IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_USUARIO%TYPE,
    p_dt_momento_aceite     IN T_EH_ATENDIMENTO_VOLUNTARIO.DT_MOMENTO_ACEITE%TYPE,
    p_dt_momento_conclusao  IN T_EH_ATENDIMENTO_VOLUNTARIO.DT_MOMENTO_CONCLUSAO%TYPE DEFAULT NULL,
    p_ds_observacoes        IN T_EH_ATENDIMENTO_VOLUNTARIO.DS_OBSERVACOES%TYPE DEFAULT NULL
)
IS
BEGIN
    INSERT INTO T_EH_ATENDIMENTO_VOLUNTARIO (
        CD_ATENDIMENTO,
        CD_PEDIDO,
        CD_USUARIO,
        DT_MOMENTO_ACEITE,
        DT_MOMENTO_CONCLUSAO,
        DS_OBSERVACOES
    ) VALUES (
        SEQ_EH_ATENDIMENTO_VOLUNTARIO.NEXTVAL,
        p_cd_pedido,
        p_cd_usuario,
        p_dt_momento_aceite,
        p_dt_momento_conclusao,
        p_ds_observacoes
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_INSERT_ATEND_VOL;
/

--UPDATE
CREATE OR REPLACE PROCEDURE PRC_UPDATE_ATEND_VOL (
    p_cd_atendimento        IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_ATENDIMENTO%TYPE,
    p_cd_pedido             IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_PEDIDO%TYPE DEFAULT NULL, -- FK
    p_cd_usuario            IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_USUARIO%TYPE DEFAULT NULL, -- FK
    p_dt_momento_aceite     IN T_EH_ATENDIMENTO_VOLUNTARIO.DT_MOMENTO_ACEITE%TYPE DEFAULT NULL,
    p_dt_momento_conclusao  IN T_EH_ATENDIMENTO_VOLUNTARIO.DT_MOMENTO_CONCLUSAO%TYPE DEFAULT NULL,
    p_ds_observacoes        IN T_EH_ATENDIMENTO_VOLUNTARIO.DS_OBSERVACOES%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE T_EH_ATENDIMENTO_VOLUNTARIO
    SET
        CD_PEDIDO = NVL(p_cd_pedido, CD_PEDIDO),
        CD_USUARIO = NVL(p_cd_usuario, CD_USUARIO),
        DT_MOMENTO_ACEITE = NVL(p_dt_momento_aceite, DT_MOMENTO_ACEITE),
        DT_MOMENTO_CONCLUSAO = NVL(p_dt_momento_conclusao, DT_MOMENTO_CONCLUSAO),
        DS_OBSERVACOES = NVL(p_ds_observacoes, DS_OBSERVACOES)
    WHERE
        CD_ATENDIMENTO = p_cd_atendimento;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_UPDATE_ATEND_VOL;
/

--DELETE
CREATE OR REPLACE PROCEDURE PRC_DELETE_ATEND_VOL (
    p_cd_atendimento IN T_EH_ATENDIMENTO_VOLUNTARIO.CD_ATENDIMENTO%TYPE
)
IS
BEGIN
    DELETE FROM T_EH_ATENDIMENTO_VOLUNTARIO
    WHERE CD_ATENDIMENTO = p_cd_atendimento;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_DELETE_ATEND_VOL;
/

--Inserindo dados
BEGIN
    PRC_INSERT_ATEND_VOL(
        p_cd_pedido             => 1, 
        p_cd_usuario            => 2, 
        p_dt_momento_aceite     => TO_DATE('2025-06-02 11:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_dt_momento_conclusao  => TO_DATE('2025-06-02 15:30:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_ds_observacoes        => 'Cesta básica entregue conforme solicitado. Família agradecida.'
    );

    PRC_INSERT_ATEND_VOL(
        p_cd_pedido             => 2, 
        p_cd_usuario            => 5, 
        p_dt_momento_aceite     => TO_DATE('2025-06-03 09:15:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_dt_momento_conclusao  => NULL, -- Atendimento ainda em andamento
        p_ds_observacoes        => 'Medicamentos comprados, agendando entrega.'
    );

    PRC_INSERT_ATEND_VOL(
        p_cd_pedido             => 3, 
        p_cd_usuario            => 2, 
        p_dt_momento_aceite     => SYSDATE - INTERVAL '2' HOUR, -- Aceito 2 horas atrás
        p_dt_momento_conclusao  => NULL, -- Ainda não concluído
        p_ds_observacoes        => 'Confirmado transporte para a consulta.'
    );

    PRC_INSERT_ATEND_VOL(
        p_cd_pedido             => 4, 
        p_cd_usuario            => 5, 
        p_dt_momento_aceite     => SYSDATE - INTERVAL '1' DAY,     -- Aceito ontem
        p_dt_momento_conclusao  => SYSDATE - INTERVAL '12' HOUR, -- Concluído ontem mesmo
        p_ds_observacoes        => 'Abrigo temporário providenciado e família encaminhada com sucesso.'
    );

    PRC_INSERT_ATEND_VOL(
        p_cd_pedido             => 5, 
        p_cd_usuario            => 2, 
        p_dt_momento_aceite     => SYSDATE, -- Aceito agora
        p_dt_momento_conclusao  => NULL,
        p_ds_observacoes        => 'Iniciando coleta de material escolar.'
    );
END;
/