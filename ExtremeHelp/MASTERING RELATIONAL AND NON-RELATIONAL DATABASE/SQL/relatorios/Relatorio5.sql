--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Número de Pedidos Concluídos por Voluntários Registrados Recentemente

SELECT
    vol.NM_USUARIO AS NOME_VOLUNTARIO,
    vol.DS_EMAIL AS EMAIL_VOLUNTARIO,
    TO_CHAR(vol.DT_REGISTRO, 'DD/MM/YYYY') AS DATA_REGISTRO_VOLUNTARIO,
    COUNT(av.CD_PEDIDO) AS TOTAL_PEDIDOS_CONCLUIDOS
FROM
    T_EH_USUARIO vol
JOIN
    T_EH_ATENDIMENTO_VOLUNTARIO av ON vol.CD_USUARIO = av.CD_USUARIO
WHERE
    vol.DS_TIPO = 'VOLUNTARIO'
    AND vol.DT_REGISTRO >= ADD_MONTHS(TRUNC(SYSDATE), -6) -- Registrados nos últimos 6 meses
    AND av.DT_MOMENTO_CONCLUSAO IS NOT NULL -- Atendimentos efetivamente concluídos
GROUP BY
    vol.CD_USUARIO, vol.NM_USUARIO, vol.DS_EMAIL, vol.DT_REGISTRO
HAVING
    COUNT(av.CD_PEDIDO) > 0 -- Voluntários que concluíram pelo menos 1 pedido
ORDER BY
    TOTAL_PEDIDOS_CONCLUIDOS DESC, vol.NM_USUARIO ASC;