--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--INSERT
CREATE OR REPLACE PROCEDURE PRC_INSERT_PEDIDO_AJUDA (
    p_cd_usuario        IN T_EH_PEDIDO_AJUDA.CD_USUARIO%TYPE,
    p_ds_tipo           IN T_EH_PEDIDO_AJUDA.DS_TIPO%TYPE,
    p_ds_descricao      IN T_EH_PEDIDO_AJUDA.DS_DESCRICAO%TYPE,
    p_ds_latitude       IN T_EH_PEDIDO_AJUDA.DS_LATITUDE%TYPE,
    p_ds_longitude      IN T_EH_PEDIDO_AJUDA.DS_LONGITUDE%TYPE,
    p_ds_endereco       IN T_EH_PEDIDO_AJUDA.DS_ENDERECO%TYPE DEFAULT NULL,
    p_dt_pedido         IN T_EH_PEDIDO_AJUDA.DT_PEDIDO%TYPE,
    p_ds_status         IN T_EH_PEDIDO_AJUDA.DS_STATUS%TYPE
)
IS
BEGIN
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
        SEQ_EH_PEDIDO_AJUDA.NEXTVAL,
        p_cd_usuario,
        p_ds_tipo,
        p_ds_descricao,
        p_ds_latitude,
        p_ds_longitude,
        p_ds_endereco,
        p_dt_pedido,
        p_ds_status
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_INSERT_PEDIDO_AJUDA;
/

--UPDATE
CREATE OR REPLACE PROCEDURE PRC_UPDATE_PEDIDO_AJUDA (
    p_cd_pedido         IN T_EH_PEDIDO_AJUDA.CD_PEDIDO%TYPE,
    p_cd_usuario        IN T_EH_PEDIDO_AJUDA.CD_USUARIO%TYPE DEFAULT NULL, -- FK, update with caution
    p_ds_tipo           IN T_EH_PEDIDO_AJUDA.DS_TIPO%TYPE DEFAULT NULL,
    p_ds_descricao      IN T_EH_PEDIDO_AJUDA.DS_DESCRICAO%TYPE DEFAULT NULL,
    p_ds_latitude       IN T_EH_PEDIDO_AJUDA.DS_LATITUDE%TYPE DEFAULT NULL,
    p_ds_longitude      IN T_EH_PEDIDO_AJUDA.DS_LONGITUDE%TYPE DEFAULT NULL,
    p_ds_endereco       IN T_EH_PEDIDO_AJUDA.DS_ENDERECO%TYPE DEFAULT NULL,
    p_dt_pedido         IN T_EH_PEDIDO_AJUDA.DT_PEDIDO%TYPE DEFAULT NULL,
    p_ds_status         IN T_EH_PEDIDO_AJUDA.DS_STATUS%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE T_EH_PEDIDO_AJUDA
    SET
        CD_USUARIO = NVL(p_cd_usuario, CD_USUARIO),
        DS_TIPO = NVL(p_ds_tipo, DS_TIPO),
        DS_DESCRICAO = NVL(p_ds_descricao, DS_DESCRICAO),
        DS_LATITUDE = NVL(p_ds_latitude, DS_LATITUDE),
        DS_LONGITUDE = NVL(p_ds_longitude, DS_LONGITUDE),
        DS_ENDERECO = NVL(p_ds_endereco, DS_ENDERECO),
        DT_PEDIDO = NVL(p_dt_pedido, DT_PEDIDO),
        DS_STATUS = NVL(p_ds_status, DS_STATUS)
    WHERE
        CD_PEDIDO = p_cd_pedido;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_UPDATE_PEDIDO_AJUDA;
/

--DELETE
CREATE OR REPLACE PROCEDURE PRC_DELETE_PEDIDO_AJUDA (
    p_cd_pedido IN T_EH_PEDIDO_AJUDA.CD_PEDIDO%TYPE
)
IS
BEGIN
    DELETE FROM T_EH_PEDIDO_AJUDA
    WHERE CD_PEDIDO = p_cd_pedido;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_DELETE_PEDIDO_AJUDA;
/

--Inserindo dados
BEGIN
    PRC_INSERT_PEDIDO_AJUDA(
        p_cd_usuario        => 1, 
        p_ds_tipo           => 'Alimentação',
        p_ds_descricao      => 'Solicitação de cesta básica para família de 4 pessoas. Urgente.',
        p_ds_latitude       => -23.561358,
        p_ds_longitude      => -46.656189,
        p_ds_endereco       => 'Rua da Consolação, 900, Consolação, São Paulo, SP',
        p_dt_pedido         => TO_DATE('2025-06-01 10:00:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_ds_status         => 'PENDENTE'
    );

    PRC_INSERT_PEDIDO_AJUDA(
        p_cd_usuario        => 1, 
        p_ds_tipo           => 'Medicamentos',
        p_ds_descricao      => 'Necessidade de Insulina NPH e tiras de glicemia para idoso diabético.',
        p_ds_latitude       => -23.558798,
        p_ds_longitude      => -46.660777,
        p_ds_endereco       => 'Av. Angélica, 500, Higienópolis, São Paulo, SP',
        p_dt_pedido         => TO_DATE('2025-06-02 14:30:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_ds_status         => 'EM_ATENDIMENTO'
    );

    PRC_INSERT_PEDIDO_AJUDA(
        p_cd_usuario        => 4, 
        p_ds_tipo           => 'Transporte',
        p_ds_descricao      => 'Precisa de transporte para consulta médica no Hospital das Clínicas dia 05/06.',
        p_ds_latitude       => -23.555392,
        p_ds_longitude      => -46.669099,
        p_ds_endereco       => 'Rua Dr. Ovídio Pires de Campos, 225, Cerqueira César, São Paulo, SP',
        p_dt_pedido         => TO_DATE('2025-06-03 08:15:00', 'YYYY-MM-DD HH24:MI:SS'),
        p_ds_status         => 'PENDENTE'
    );

    PRC_INSERT_PEDIDO_AJUDA(
        p_cd_usuario        => 1, 
        p_ds_tipo           => 'Abrigo Temporário',
        p_ds_descricao      => 'Desabrigado devido a enchente, necessita de abrigo para casal e um cachorro pequeno.',
        p_ds_latitude       => -23.547500,
        p_ds_longitude      => -46.636110,
        p_ds_endereco       => 'Praça da Sé, s/n, Centro, São Paulo, SP (referência)',
        p_dt_pedido         => SYSDATE - 1, -- Ontem (relativo à data de execução)
        p_ds_status         => 'CONCLUIDO'
    );

    PRC_INSERT_PEDIDO_AJUDA(
        p_cd_usuario        => 4, 
        p_ds_tipo           => 'Material Escolar',
        p_ds_descricao      => 'Arrecadação de cadernos e lápis para crianças de comunidade carente.',
        p_ds_latitude       => -23.570000,
        p_ds_longitude      => -46.670000,
        p_ds_endereco       => 'Rua Solidariedade, 789, Bairro Esperança, São Paulo, SP',
        p_dt_pedido         => SYSDATE, -- Hoje (relativo à data de execução)
        p_ds_status         => 'PENDENTE'
    );
END;
/