--Função para Calcular Total de Pedidos de Ajuda Pendentes por Usuário

CREATE OR REPLACE FUNCTION FNC_COUNT_USER_PENDING_REQUESTS (
    p_cd_usuario IN T_EH_USUARIO.CD_USUARIO%TYPE
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM T_EH_PEDIDO_AJUDA
    WHERE CD_USUARIO = p_cd_usuario
      AND DS_STATUS = 'PENDENTE'; -- Assumindo 'PENDENTE' como um status válido

    RETURN v_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0; -- Se o usuário não tiver pedidos ou nenhum pendente
    WHEN OTHERS THEN
        RAISE;
END FNC_COUNT_USER_PENDING_REQUESTS;
/

--Testes

-- Para ver o número de pedidos pendentes do usuário com CD_USUARIO = 1
SELECT FNC_COUNT_USER_PENDING_REQUESTS(1) AS pedidos_pendentes_usuario_1 FROM DUAL;

-- Em um bloco PL/SQL:
DECLARE
    v_id_usuario T_EH_USUARIO.CD_USUARIO%TYPE := 2; -- Supondo que o usuário 2 existe
    num_pedidos NUMBER;
BEGIN
    num_pedidos := FNC_COUNT_USER_PENDING_REQUESTS(v_id_usuario);
    DBMS_OUTPUT.PUT_LINE('Usuário ' || v_id_usuario || ' tem ' || num_pedidos || ' pedido(s) de ajuda pendente(s).');
END;
/