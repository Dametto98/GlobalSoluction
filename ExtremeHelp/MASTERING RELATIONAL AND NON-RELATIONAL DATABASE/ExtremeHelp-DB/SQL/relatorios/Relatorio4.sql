--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Frequência de Alertas Ativos por Nível de Seriedade

SELECT
    DS_SERIEDADE,
    COUNT(CD_ALERTA) AS QUANTIDADE_ALERTAS_ATIVOS
FROM
    T_EH_ALERTA
WHERE
    DS_ATIVO = 1 -- Considera apenas alertas ativos (1 = ativo)
GROUP BY
    DS_SERIEDADE
HAVING
    COUNT(CD_ALERTA) > 0 -- Mostrar apenas seriedades com pelo menos um alerta ativo
ORDER BY
    QUANTIDADE_ALERTAS_ATIVOS DESC, DS_SERIEDADE ASC;