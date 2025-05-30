--Análise de Pedidos por Tipo e Região

SET SERVEROUTPUT ON;

DECLARE
    -- Variáveis para totais
    v_total_pedidos NUMBER;
    v_pedidos_pendentes NUMBER;
    v_pedidos_urgentes NUMBER;
    
    -- Variáveis para região com mais pedidos
    v_regiao_mais_pedidos VARCHAR2(100);
    v_total_regiao NUMBER;
    
    -- Variável para tipo mais comum
    v_tipo_mais_comum VARCHAR2(100);
    v_total_tipo NUMBER;
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== ANÁLISE DE PEDIDOS DE AJUDA POR TIPO E REGIÃO ===');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    
    -- Obter totais gerais
    SELECT COUNT(*) INTO v_total_pedidos FROM T_EH_PEDIDO_AJUDA;
    
    SELECT COUNT(*) INTO v_pedidos_pendentes 
    FROM T_EH_PEDIDO_AJUDA 
    WHERE DS_STATUS = 'PENDENTE';
    
    SELECT COUNT(*) INTO v_pedidos_urgentes
    FROM T_EH_PEDIDO_AJUDA
    WHERE DS_STATUS = 'PENDENTE'
    AND DT_PEDIDO > SYSDATE - 1;
    
    DBMS_OUTPUT.PUT_LINE('Total de Pedidos: ' || v_total_pedidos);
    DBMS_OUTPUT.PUT_LINE('Pedidos Pendentes: ' || v_pedidos_pendentes || 
                        ' (' || ROUND((v_pedidos_pendentes/v_total_pedidos)*100, 1) || '%)');
    DBMS_OUTPUT.PUT_LINE('Pedidos Urgentes (últimas 24h): ' || v_pedidos_urgentes);
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    
    -- Identificar região com mais pedidos
    SELECT 
        CASE 
            WHEN DS_LATITUDE BETWEEN -23.8 AND -23.2 AND DS_LONGITUDE BETWEEN -47.0 AND -46.2 THEN 'Grande São Paulo'
            WHEN DS_LATITUDE BETWEEN -22.9 AND -22.8 AND DS_LONGITUDE BETWEEN -43.3 AND -43.1 THEN 'Rio de Janeiro'
            WHEN DS_LATITUDE BETWEEN -19.9 AND -19.8 AND DS_LONGITUDE BETWEEN -44.0 AND -43.9 THEN 'Belo Horizonte'
            WHEN DS_LATITUDE BETWEEN -12.9 AND -12.8 AND DS_LONGITUDE BETWEEN -38.6 AND -38.4 THEN 'Salvador'
            WHEN DS_LATITUDE BETWEEN -30.1 AND -29.9 AND DS_LONGITUDE BETWEEN -51.3 AND -51.1 THEN 'Porto Alegre'
            ELSE 'Outras Regiões'
        END AS regiao,
        COUNT(*) AS total
    INTO 
        v_regiao_mais_pedidos, v_total_regiao
    FROM 
        T_EH_PEDIDO_AJUDA
    GROUP BY 
        CASE 
            WHEN DS_LATITUDE BETWEEN -23.8 AND -23.2 AND DS_LONGITUDE BETWEEN -47.0 AND -46.2 THEN 'Grande São Paulo'
            WHEN DS_LATITUDE BETWEEN -22.9 AND -22.8 AND DS_LONGITUDE BETWEEN -43.3 AND -43.1 THEN 'Rio de Janeiro'
            WHEN DS_LATITUDE BETWEEN -19.9 AND -19.8 AND DS_LONGITUDE BETWEEN -44.0 AND -43.9 THEN 'Belo Horizonte'
            WHEN DS_LATITUDE BETWEEN -12.9 AND -12.8 AND DS_LONGITUDE BETWEEN -38.6 AND -38.4 THEN 'Salvador'
            WHEN DS_LATITUDE BETWEEN -30.1 AND -29.9 AND DS_LONGITUDE BETWEEN -51.3 AND -51.1 THEN 'Porto Alegre'
            ELSE 'Outras Regiões'
        END
    ORDER BY 
        total DESC
    FETCH FIRST 1 ROW ONLY;
    
    DBMS_OUTPUT.PUT_LINE('Região com mais pedidos: ' || v_regiao_mais_pedidos || ' (' || v_total_regiao || ' pedidos)');
    
    -- Identificar tipo mais comum
    SELECT 
        DS_TIPO, 
        COUNT(*) AS total
    INTO 
        v_tipo_mais_comum, v_total_tipo
    FROM 
        T_EH_PEDIDO_AJUDA
    GROUP BY 
        DS_TIPO
    ORDER BY 
        total DESC
    FETCH FIRST 1 ROW ONLY;
    
    DBMS_OUTPUT.PUT_LINE('Tipo de pedido mais comum: ' || v_tipo_mais_comum || ' (' || v_total_tipo || ' pedidos)');
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    
    -- Análise detalhada por tipo e região
    DBMS_OUTPUT.PUT_LINE('=== DISTRIBUIÇÃO DE PEDIDOS POR TIPO E REGIÃO ===');
    
    FOR r_tipo IN (
        SELECT 
            DS_TIPO,
            COUNT(*) AS total
        FROM 
            T_EH_PEDIDO_AJUDA
        GROUP BY 
            DS_TIPO
        ORDER BY 
            total DESC
    ) LOOP
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Tipo: ' || r_tipo.DS_TIPO || ' (' || r_tipo.total || ' pedidos)');
        DBMS_OUTPUT.PUT_LINE('Regiões:');
        
        FOR r_regiao IN (
            SELECT 
                CASE 
                    WHEN DS_LATITUDE BETWEEN -23.8 AND -23.2 AND DS_LONGITUDE BETWEEN -47.0 AND -46.2 THEN 'Grande São Paulo'
                    WHEN DS_LATITUDE BETWEEN -22.9 AND -22.8 AND DS_LONGITUDE BETWEEN -43.3 AND -43.1 THEN 'Rio de Janeiro'
                    WHEN DS_LATITUDE BETWEEN -19.9 AND -19.8 AND DS_LONGITUDE BETWEEN -44.0 AND -43.9 THEN 'Belo Horizonte'
                    WHEN DS_LATITUDE BETWEEN -12.9 AND -12.8 AND DS_LONGITUDE BETWEEN -38.6 AND -38.4 THEN 'Salvador'
                    WHEN DS_LATITUDE BETWEEN -30.1 AND -29.9 AND DS_LONGITUDE BETWEEN -51.3 AND -51.1 THEN 'Porto Alegre'
                    ELSE 'Outras Regiões'
                END AS regiao,
                COUNT(*) AS total,
                ROUND(COUNT(*) * 100.0 / r_tipo.total, 1) AS percentual
            FROM 
                T_EH_PEDIDO_AJUDA
            WHERE 
                DS_TIPO = r_tipo.DS_TIPO
            GROUP BY 
                CASE 
                    WHEN DS_LATITUDE BETWEEN -23.8 AND -23.2 AND DS_LONGITUDE BETWEEN -47.0 AND -46.2 THEN 'Grande São Paulo'
                    WHEN DS_LATITUDE BETWEEN -22.9 AND -22.8 AND DS_LONGITUDE BETWEEN -43.3 AND -43.1 THEN 'Rio de Janeiro'
                    WHEN DS_LATITUDE BETWEEN -19.9 AND -19.8 AND DS_LONGITUDE BETWEEN -44.0 AND -43.9 THEN 'Belo Horizonte'
                    WHEN DS_LATITUDE BETWEEN -12.9 AND -12.8 AND DS_LONGITUDE BETWEEN -38.6 AND -38.4 THEN 'Salvador'
                    WHEN DS_LATITUDE BETWEEN -30.1 AND -29.9 AND DS_LONGITUDE BETWEEN -51.3 AND -51.1 THEN 'Porto Alegre'
                    ELSE 'Outras Regiões'
                END
            ORDER BY 
                total DESC
        ) LOOP
            DBMS_OUTPUT.PUT_LINE('- ' || r_regiao.regiao || ': ' || r_regiao.total || ' (' || r_regiao.percentual || '%)');
        END LOOP;
        
        -- Verificar se há pedidos pendentes para este tipo
        SELECT 
            COUNT(*)
        INTO 
            v_pedidos_pendentes
        FROM 
            T_EH_PEDIDO_AJUDA
        WHERE 
            DS_TIPO = r_tipo.DS_TIPO
            AND DS_STATUS = 'PENDENTE';
        
        IF v_pedidos_pendentes > 0 THEN
            DBMS_OUTPUT.PUT_LINE('ATENÇÃO: ' || v_pedidos_pendentes || ' pedidos pendentes deste tipo!');
            
            -- Sugerir voluntários com experiência neste tipo de pedido
            DBMS_OUTPUT.PUT_LINE('Voluntários com experiência em ' || r_tipo.DS_TIPO || ':');
            
            FOR r_vol IN (
                SELECT DISTINCT
                    u.CD_USUARIO,
                    u.NM_USUARIO,
                    u.DS_EMAIL,
                    COUNT(av.CD_ATENDIMENTO) AS atendimentos_tipo
                FROM 
                    T_EH_USUARIO u
                JOIN 
                    T_EH_ATENDIMENTO_VOLUNTARIO av ON u.CD_USUARIO = av.CD_USUARIO
                JOIN 
                    T_EH_PEDIDO_AJUDA pa ON av.CD_PEDIDO = pa.CD_PEDIDO
                WHERE 
                    u.DS_TIPO = 'VOLUNTARIO'
                    AND pa.DS_TIPO = r_tipo.DS_TIPO
                    AND NOT EXISTS (
                        SELECT 1
                        FROM T_EH_ATENDIMENTO_VOLUNTARIO av2
                        JOIN T_EH_PEDIDO_AJUDA pa2 ON av2.CD_PEDIDO = pa2.CD_PEDIDO
                        WHERE av2.CD_USUARIO = u.CD_USUARIO
                        AND av2.DT_MOMENTO_CONCLUSAO IS NULL
                    )
                GROUP BY 
                    u.CD_USUARIO, u.NM_USUARIO, u.DS_EMAIL
                ORDER BY 
                    atendimentos_tipo DESC
                FETCH FIRST 3 ROWS ONLY
            ) LOOP
                DBMS_OUTPUT.PUT_LINE('   - ' || r_vol.NM_USUARIO || ' (' || r_vol.atendimentos_tipo || ' atendimentos) - ' || r_vol.DS_EMAIL);
            END LOOP;
        END IF;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------------------------');
    DBMS_OUTPUT.PUT_LINE('=== ANÁLISE CONCLUÍDA ===');
END;
/