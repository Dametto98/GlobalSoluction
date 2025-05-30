--An�lise de Desempenho de Volunt�rios

SET SERVEROUTPUT ON;

DECLARE
    -- Cursor para obter volunt�rios e suas estat�sticas
    CURSOR c_voluntarios IS
        SELECT 
            u.CD_USUARIO,
            u.NM_USUARIO,
            COUNT(av.CD_ATENDIMENTO) AS total_atendimentos,
            SUM(CASE WHEN av.DT_MOMENTO_CONCLUSAO IS NOT NULL THEN 1 ELSE 0 END) AS atendimentos_concluidos,
            ROUND(AVG(CASE WHEN av.DT_MOMENTO_CONCLUSAO IS NOT NULL 
                      THEN (av.DT_MOMENTO_CONCLUSAO - av.DT_MOMENTO_ACEITE) * 24 
                      ELSE NULL END), 2) AS tempo_medio_horas
        FROM 
            T_EH_USUARIO u
        JOIN 
            T_EH_ATENDIMENTO_VOLUNTARIO av ON u.CD_USUARIO = av.CD_USUARIO
        WHERE 
            u.DS_TIPO = 'VOLUNTARIO'
        GROUP BY 
            u.CD_USUARIO, u.NM_USUARIO
        HAVING 
            COUNT(av.CD_ATENDIMENTO) > 0
        ORDER BY 
            tempo_medio_horas ASC NULLS LAST;
    
    -- Vari�veis para classifica��o
    v_classificacao VARCHAR2(50);
    v_total_voluntarios NUMBER := 0;
    v_voluntarios_ativos NUMBER := 0;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== RELAT�RIO DE DESEMPENHO DE VOLUNT�RIOS ===');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    
    -- Contar total de volunt�rios cadastrados
    SELECT COUNT(*) INTO v_total_voluntarios
    FROM T_EH_USUARIO
    WHERE DS_TIPO = 'VOLUNTARIO';
    
    -- Contar volunt�rios com atendimentos
    SELECT COUNT(*) INTO v_voluntarios_ativos
    FROM (
        SELECT CD_USUARIO
        FROM T_EH_ATENDIMENTO_VOLUNTARIO
        GROUP BY CD_USUARIO
        HAVING COUNT(*) > 0
    );
    
    DBMS_OUTPUT.PUT_LINE('Total de volunt�rios cadastrados: ' || v_total_voluntarios);
    DBMS_OUTPUT.PUT_LINE('Volunt�rios com atendimentos registrados: ' || v_voluntarios_ativos);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    
    -- Processar cada volunt�rio
    FOR r_vol IN c_voluntarios LOOP
        -- Determinar classifica��o baseada no tempo m�dio
        IF r_vol.tempo_medio_horas IS NULL THEN
            v_classificacao := 'SEM CONCLUS�ES';
        ELSIF r_vol.tempo_medio_horas < 12 THEN
            v_classificacao := 'MUITO EFICIENTE';
        ELSIF r_vol.tempo_medio_horas < 24 THEN
            v_classificacao := 'EFICIENTE';
        ELSIF r_vol.tempo_medio_horas < 48 THEN
            v_classificacao := 'REGULAR';
        ELSE
            v_classificacao := 'PODE MELHORAR';
        END IF;
        
        -- Exibir informa��es do volunt�rio
        DBMS_OUTPUT.PUT_LINE('Volunt�rio: ' || r_vol.NM_USUARIO);
        DBMS_OUTPUT.PUT_LINE('ID: ' || r_vol.CD_USUARIO);
        DBMS_OUTPUT.PUT_LINE('Total de Atendimentos: ' || r_vol.total_atendimentos);
        DBMS_OUTPUT.PUT_LINE('Atendimentos Conclu�dos: ' || r_vol.atendimentos_concluidos || 
                            ' (' || ROUND((r_vol.atendimentos_concluidos/r_vol.total_atendimentos)*100, 1) || '%)');
        DBMS_OUTPUT.PUT_LINE('Tempo M�dio de Conclus�o: ' || 
                            NVL(TO_CHAR(r_vol.tempo_medio_horas), 'N/A') || ' horas');
        DBMS_OUTPUT.PUT_LINE('Classifica��o: ' || v_classificacao);
        DBMS_OUTPUT.PUT_LINE('------------------------------------------------');
    END LOOP;
    
    -- Resumo final
    DBMS_OUTPUT.PUT_LINE('=== RESUMO FINAL ===');
    
    -- Contar volunt�rios por classifica��o
    FOR r_class IN (
        SELECT 
            CASE 
                WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                ELSE 'PODE MELHORAR'
            END AS classificacao,
            COUNT(*) AS quantidade
        FROM (
            SELECT 
                u.CD_USUARIO,
                ROUND(AVG((av.DT_MOMENTO_CONCLUSAO - av.DT_MOMENTO_ACEITE) * 24), 2) AS tempo_medio_horas
            FROM 
                T_EH_USUARIO u
            JOIN 
                T_EH_ATENDIMENTO_VOLUNTARIO av ON u.CD_USUARIO = av.CD_USUARIO
            WHERE 
                u.DS_TIPO = 'VOLUNTARIO'
            GROUP BY 
                u.CD_USUARIO
        )
        GROUP BY 
            CASE 
                WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                ELSE 'PODE MELHORAR'
            END
        ORDER BY 
            CASE 
                WHEN 
                    CASE 
                        WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                        WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                        WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                        WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                        ELSE 'PODE MELHORAR'
                    END = 'MUITO EFICIENTE' THEN 1
                WHEN 
                    CASE 
                        WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                        WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                        WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                        WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                        ELSE 'PODE MELHORAR'
                    END = 'EFICIENTE' THEN 2
                WHEN 
                    CASE 
                        WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                        WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                        WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                        WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                        ELSE 'PODE MELHORAR'
                    END = 'REGULAR' THEN 3
                WHEN 
                    CASE 
                        WHEN tempo_medio_horas IS NULL THEN 'SEM CONCLUS�ES'
                        WHEN tempo_medio_horas < 12 THEN 'MUITO EFICIENTE'
                        WHEN tempo_medio_horas < 24 THEN 'EFICIENTE'
                        WHEN tempo_medio_horas < 48 THEN 'REGULAR'
                        ELSE 'PODE MELHORAR'
                    END = 'PODE MELHORAR' THEN 4
                ELSE 5
            END
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(r_class.classificacao || ': ' || r_class.quantidade || ' volunt�rios');
    END LOOP;
END;
/