--Fun��o para Calcular Estat�sticas de Pedidos por Usu�rio

CREATE OR REPLACE FUNCTION fn_estatisticas_pedidos_usuario (
    p_cd_usuario IN NUMBER
) RETURN VARCHAR2
AS
    v_nome_usuario VARCHAR2(200);
    v_total_pedidos NUMBER;
    v_pedidos_pendentes NUMBER;
    v_pedidos_concluidos NUMBER;
    v_resultado VARCHAR2(1000);
BEGIN
    -- Obter nome do usu�rio
    SELECT NM_USUARIO INTO v_nome_usuario
    FROM T_EH_USUARIO
    WHERE CD_USUARIO = p_cd_usuario;
    
    -- Contar total de pedidos
    SELECT COUNT(*) INTO v_total_pedidos
    FROM T_EH_PEDIDO_AJUDA
    WHERE CD_USUARIO = p_cd_usuario;
    
    -- Contar pedidos pendentes
    SELECT COUNT(*) INTO v_pedidos_pendentes
    FROM T_EH_PEDIDO_AJUDA
    WHERE CD_USUARIO = p_cd_usuario
    AND DS_STATUS = 'PENDENTE';
    
    -- Contar pedidos conclu�dos
    SELECT COUNT(*) INTO v_pedidos_concluidos
    FROM T_EH_PEDIDO_AJUDA
    WHERE CD_USUARIO = p_cd_usuario
    AND DS_STATUS = 'CONCLUIDO';
    
    -- Formatando o resultado
    v_resultado := 'Estat�sticas para ' || v_nome_usuario || ':' || CHR(10) ||
                   'Total de Pedidos: ' || v_total_pedidos || CHR(10) ||
                   'Pedidos Pendentes: ' || v_pedidos_pendentes || CHR(10) ||
                   'Pedidos Conclu�dos: ' || v_pedidos_concluidos;
    
    RETURN v_resultado;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 'Usu�rio n�o encontrado.';
    WHEN OTHERS THEN
        RETURN 'Erro ao calcular estat�sticas: ' || SQLERRM;
END fn_estatisticas_pedidos_usuario;
/

--TESTE
SELECT fn_estatisticas_pedidos_usuario(2) FROM dual;