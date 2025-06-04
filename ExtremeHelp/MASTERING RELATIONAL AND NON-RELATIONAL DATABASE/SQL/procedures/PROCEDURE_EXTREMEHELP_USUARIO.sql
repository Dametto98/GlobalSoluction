--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--INSERT
CREATE OR REPLACE PROCEDURE PRC_INSERT_USUARIO (
    p_nm_usuario    IN T_EH_USUARIO.NM_USUARIO%TYPE,
    p_ds_email      IN T_EH_USUARIO.DS_EMAIL%TYPE,
    p_ds_senha      IN T_EH_USUARIO.DS_SENHA%TYPE,
    p_ds_telefone   IN T_EH_USUARIO.DS_TELEFONE%TYPE DEFAULT NULL,
    p_ds_tipo       IN T_EH_USUARIO.DS_TIPO%TYPE,
    p_dt_registro   IN T_EH_USUARIO.DT_REGISTRO%TYPE,
    p_ds_status     IN T_EH_USUARIO.DS_STATUS%TYPE
)
IS
BEGIN
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
        SEQ_EH_USUARIO.NEXTVAL,
        p_nm_usuario,
        p_ds_email,
        p_ds_senha,
        p_ds_telefone,
        p_ds_tipo,
        p_dt_registro,
        p_ds_status
    );
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE; -- Re-raise the exception
END PRC_INSERT_USUARIO;
/

--UPDATE
CREATE OR REPLACE PROCEDURE PRC_UPDATE_USUARIO (
    p_cd_usuario    IN T_EH_USUARIO.CD_USUARIO%TYPE,
    p_nm_usuario    IN T_EH_USUARIO.NM_USUARIO%TYPE DEFAULT NULL,
    p_ds_email      IN T_EH_USUARIO.DS_EMAIL%TYPE DEFAULT NULL,
    p_ds_senha      IN T_EH_USUARIO.DS_SENHA%TYPE DEFAULT NULL,
    p_ds_telefone   IN T_EH_USUARIO.DS_TELEFONE%TYPE DEFAULT NULL,
    p_ds_tipo       IN T_EH_USUARIO.DS_TIPO%TYPE DEFAULT NULL,
    p_dt_registro   IN T_EH_USUARIO.DT_REGISTRO%TYPE DEFAULT NULL,
    p_ds_status     IN T_EH_USUARIO.DS_STATUS%TYPE DEFAULT NULL
)
IS
BEGIN
    UPDATE T_EH_USUARIO
    SET
        NM_USUARIO = NVL(p_nm_usuario, NM_USUARIO),
        DS_EMAIL = NVL(p_ds_email, DS_EMAIL),
        DS_SENHA = NVL(p_ds_senha, DS_SENHA),
        DS_TELEFONE = NVL(p_ds_telefone, DS_TELEFONE),
        DS_TIPO = NVL(p_ds_tipo, DS_TIPO),
        DT_REGISTRO = NVL(p_dt_registro, DT_REGISTRO),
        DS_STATUS = NVL(p_ds_status, DS_STATUS)
    WHERE
        CD_USUARIO = p_cd_usuario;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_UPDATE_USUARIO;
/

--DELETE
CREATE OR REPLACE PROCEDURE PRC_DELETE_USUARIO (
    p_cd_usuario IN T_EH_USUARIO.CD_USUARIO%TYPE
)
IS
BEGIN
    DELETE FROM T_EH_USUARIO
    WHERE CD_USUARIO = p_cd_usuario;
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END PRC_DELETE_USUARIO;
/

--Inserindo dados
BEGIN
    PRC_INSERT_USUARIO(
        p_nm_usuario    => 'Ana Silva',
        p_ds_email      => 'ana.silva@example.com',
        p_ds_senha      => 'AnaS9233', 
        p_ds_telefone   => '(11)98765-4321',
        p_ds_tipo       => 'SOLICITANTE',
        p_dt_registro   => TO_DATE('2025-06-01', 'YYYY-MM-DD'),
        p_ds_status     => 1
    );

    PRC_INSERT_USUARIO(
        p_nm_usuario    => 'Bruno Costa',
        p_ds_email      => 'bruno.costa@example.com',
        p_ds_senha      => 'CostaB296',
        p_ds_telefone   => '(21)91234-5678',
        p_ds_tipo       => 'VOLUNTARIO',
        p_dt_registro   => TO_DATE('2025-06-02', 'YYYY-MM-DD'),
        p_ds_status     => 1
    );

    PRC_INSERT_USUARIO(
        p_nm_usuario    => 'Carla Dias',
        p_ds_email      => 'carla.dias@example.com',
        p_ds_senha      => 'CD3789',
        p_ds_telefone   => NULL,
        p_ds_tipo       => 'ADMIN',
        p_dt_registro   => TO_DATE('2025-05-30', 'YYYY-MM-DD'),
        p_ds_status     => 1
    );

    PRC_INSERT_USUARIO(
        p_nm_usuario    => 'Daniel Farias',
        p_ds_email      => 'daniel.farias@example.com',
        p_ds_senha      => 'Dan3821',
        p_ds_telefone   => '(31)95555-0000',
        p_ds_tipo       => 'SOLICITANTE',
        p_dt_registro   => SYSDATE - 5, -- 5 dias atrás
        p_ds_status     => 0
    );

    PRC_INSERT_USUARIO(
        p_nm_usuario    => 'Elisa Mendes',
        p_ds_email      => 'elisa.mendes@example.com',
        p_ds_senha      => 'Eli202',
        p_ds_telefone   => '(41)97777-1111',
        p_ds_tipo       => 'VOLUNTARIO',
        p_dt_registro   => SYSDATE, -- Hoje
        p_ds_status     => 1
    );
END;
/