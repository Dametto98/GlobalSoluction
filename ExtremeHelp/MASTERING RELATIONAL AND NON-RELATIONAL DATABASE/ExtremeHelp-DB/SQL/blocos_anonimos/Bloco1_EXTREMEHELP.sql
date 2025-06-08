--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Relatório de Voluntários Ativos com Detalhes da Última Atividade

SET SERVEROUTPUT ON;

DECLARE
    -- Cursor para selecionar voluntários ativos e suas contagens de atendimentos concluídos
    CURSOR c_voluntarios_produtivos (p_min_atendimentos_concluidos NUMBER) IS
        SELECT
            u.CD_USUARIO,
            u.NM_USUARIO,
            u.DS_EMAIL,
            COUNT(av.CD_ATENDIMENTO) AS total_atendimentos_concluidos,
            MAX(av.DT_MOMENTO_CONCLUSAO) AS ultimo_atendimento_concluido -- Data do último atendimento concluído
        FROM
            T_EH_USUARIO u
        JOIN
            T_EH_ATENDIMENTO_VOLUNTARIO av ON u.CD_USUARIO = av.CD_USUARIO
        WHERE
            u.DS_TIPO = 'VOLUNTARIO' -- Assumindo que 'VOLUNTARIO' identifica o tipo
            AND av.DT_MOMENTO_CONCLUSAO IS NOT NULL -- Apenas atendimentos concluídos
        GROUP BY
            u.CD_USUARIO, u.NM_USUARIO, u.DS_EMAIL
        HAVING
            COUNT(av.CD_ATENDIMENTO) >= p_min_atendimentos_concluidos
        ORDER BY
            total_atendimentos_concluidos DESC, u.NM_USUARIO ASC;

    -- Variáveis para armazenar os dados do cursor
    v_cd_usuario T_EH_USUARIO.CD_USUARIO%TYPE;
    v_nm_usuario T_EH_USUARIO.NM_USUARIO%TYPE;
    v_ds_email T_EH_USUARIO.DS_EMAIL%TYPE;
    v_total_atendimentos NUMBER;
    v_ultimo_atendimento_data T_EH_ATENDIMENTO_VOLUNTARIO.DT_MOMENTO_CONCLUSAO%TYPE;

    v_min_atendimentos NUMBER := 1; -- Definindo um mínimo de atendimentos concluídos (ex: >=1)
    v_voluntario_encontrado BOOLEAN := FALSE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Relatório de Voluntários Produtivos (Com >= ' || v_min_atendimentos || ' Atendimentos Concluídos) ---');

    OPEN c_voluntarios_produtivos(v_min_atendimentos);

    LOOP
        FETCH c_voluntarios_produtivos INTO
            v_cd_usuario,
            v_nm_usuario,
            v_ds_email,
            v_total_atendimentos,
            v_ultimo_atendimento_data;

        EXIT WHEN c_voluntarios_produtivos%NOTFOUND;
        v_voluntario_encontrado := TRUE;

        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Voluntário ID: ' || v_cd_usuario);
        DBMS_OUTPUT.PUT_LINE('Nome: ' || v_nm_usuario);
        DBMS_OUTPUT.PUT_LINE('Email: ' || v_ds_email);
        DBMS_OUTPUT.PUT_LINE('Total de Atendimentos Concluídos: ' || v_total_atendimentos);
        DBMS_OUTPUT.PUT_LINE('Data do Último Atendimento Concluído: ' || TO_CHAR(v_ultimo_atendimento_data, 'DD/MM/YYYY HH24:MI:SS'));

    END LOOP;

    CLOSE c_voluntarios_produtivos;

    IF NOT v_voluntario_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum voluntário encontrado com pelo menos ' || v_min_atendimentos || ' atendimento(s) concluído(s).');
    END IF;
    DBMS_OUTPUT.PUT_LINE('--- Fim do Relatório ---');

EXCEPTION
    WHEN OTHERS THEN
        IF c_voluntarios_produtivos%ISOPEN THEN
            CLOSE c_voluntarios_produtivos;
        END IF;
        DBMS_OUTPUT.PUT_LINE('Erro ao gerar relatório de voluntários: ' || SQLERRM);
        RAISE;
END;
/

