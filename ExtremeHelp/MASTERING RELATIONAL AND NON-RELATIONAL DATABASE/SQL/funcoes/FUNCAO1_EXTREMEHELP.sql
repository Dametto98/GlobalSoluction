--Função para Contar Alertas Ativos por Nível de Seriedade
SET SERVEROUTPUT ON;

CREATE OR REPLACE FUNCTION FNC_COUNT_ACTIVE_ALERTS_BY_SERIOUSNESS (
    p_ds_seriedade IN T_EH_ALERTA.DS_SERIEDADE%TYPE
) RETURN NUMBER
IS
    v_count NUMBER;
BEGIN
    SELECT COUNT(*)
    INTO v_count
    FROM T_EH_ALERTA
    WHERE DS_SERIEDADE = p_ds_seriedade
      AND DS_ATIVO = 1; -- Considera apenas alertas ativos (1 = ativo)

    RETURN v_count;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN 0;
    WHEN OTHERS THEN
        RAISE;
END FNC_COUNT_ACTIVE_ALERTS_BY_SERIOUSNESS;
/

--Teste

-- Para ver a contagem de alertas ativos que são 'GRAVE'
SELECT FNC_COUNT_ACTIVE_ALERTS_BY_SERIOUSNESS('GRAVE') AS total_alertas_graves_ativos FROM DUAL;

-- Em um bloco PL/SQL:
DECLARE
    num_alertas_moderados NUMBER;
BEGIN
    num_alertas_moderados := FNC_COUNT_ACTIVE_ALERTS_BY_SERIOUSNESS('MODERADO');
    DBMS_OUTPUT.PUT_LINE('Número de alertas moderados ativos: ' || num_alertas_moderados);
END;
/