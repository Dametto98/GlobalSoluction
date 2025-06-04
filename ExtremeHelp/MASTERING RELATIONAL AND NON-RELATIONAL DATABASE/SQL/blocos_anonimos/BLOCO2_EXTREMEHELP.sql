--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Análise de Pedidos de Ajuda Antigos e Pendentes por Tipo

SET SERVEROUTPUT ON;

DECLARE
    v_dias_antigo NUMBER := 7; -- Pedidos pendentes há mais de 7 dias são considerados antigos
    v_min_pedidos_antigos_por_tipo NUMBER := 1; -- Tipos de ajuda com pelo menos X pedidos antigos
    v_tipo_encontrado BOOLEAN := FALSE;

BEGIN
    DBMS_OUTPUT.PUT_LINE('--- Análise de Pedidos de Ajuda Antigos e Pendentes (Mais de ' || v_dias_antigo || ' dias) ---');

    -- Loop através dos TIPOS de pedido que têm múltiplos pedidos antigos pendentes
    FOR tipo_rec IN (
        SELECT
            pa.DS_TIPO,
            COUNT(pa.CD_PEDIDO) AS total_pedidos_antigos_pendentes
        FROM
            T_EH_PEDIDO_AJUDA pa
        WHERE
            pa.DS_STATUS = 'PENDENTE' -- Assumindo 'PENDENTE' como status
            AND pa.DT_PEDIDO < (SYSDATE - v_dias_antigo) -- Pedidos mais antigos que 'v_dias_antigo'
        GROUP BY
            pa.DS_TIPO
        HAVING
            COUNT(pa.CD_PEDIDO) >= v_min_pedidos_antigos_por_tipo
        ORDER BY
            total_pedidos_antigos_pendentes DESC
    )
    LOOP
        v_tipo_encontrado := TRUE;
        DBMS_OUTPUT.PUT_LINE('--------------------------------------------------');
        DBMS_OUTPUT.PUT_LINE('Tipo de Ajuda: ' || tipo_rec.DS_TIPO);
        DBMS_OUTPUT.PUT_LINE('Total de Pedidos Antigos Pendentes: ' || tipo_rec.total_pedidos_antigos_pendentes);
        DBMS_OUTPUT.PUT_LINE('Usuários com Pedidos Antigos Pendentes para este Tipo:');

        -- Subquery para listar os usuários e seus pedidos antigos para o tipo atual
        FOR pedido_usuario_rec IN (
            SELECT
                u.NM_USUARIO,
                u.DS_EMAIL,
                pa_detail.CD_PEDIDO,
                TO_CHAR(pa_detail.DT_PEDIDO, 'DD/MM/YYYY') AS data_pedido_formatada,
                pa_detail.DS_DESCRICAO
            FROM
                T_EH_USUARIO u
            JOIN
                T_EH_PEDIDO_AJUDA pa_detail ON u.CD_USUARIO = pa_detail.CD_USUARIO
            WHERE
                pa_detail.DS_TIPO = tipo_rec.DS_TIPO
                AND pa_detail.DS_STATUS = 'PENDENTE'
                AND pa_detail.DT_PEDIDO < (SYSDATE - v_dias_antigo)
            ORDER BY
                pa_detail.DT_PEDIDO ASC 
        )
        LOOP
            DBMS_OUTPUT.PUT_LINE('  - Solicitante: ' || pedido_usuario_rec.NM_USUARIO || ' (Email: ' || pedido_usuario_rec.DS_EMAIL || ')');
            DBMS_OUTPUT.PUT_LINE('    Pedido ID: ' || pedido_usuario_rec.CD_PEDIDO || ' | Data: ' || pedido_usuario_rec.data_pedido_formatada);
            DBMS_OUTPUT.PUT_LINE('    Descrição: ' || SUBSTR(pedido_usuario_rec.DS_DESCRICAO, 1, 100) || '...'); -- Mostra parte da descrição
        END LOOP;

        IF SQL%NOTFOUND AND tipo_rec.total_pedidos_antigos_pendentes > 0 THEN
            DBMS_OUTPUT.PUT_LINE('    (Nenhum usuário específico encontrado para detalhar - verificar lógica se isso ocorrer)');
        END IF;


    END LOOP;

    IF NOT v_tipo_encontrado THEN
        DBMS_OUTPUT.PUT_LINE('Nenhum tipo de pedido de ajuda encontrado com múltiplos pedidos antigos e pendentes.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('--- Fim da Análise ---');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Erro ao analisar pedidos de ajuda: ' || SQLERRM);
        RAISE;
END;
/