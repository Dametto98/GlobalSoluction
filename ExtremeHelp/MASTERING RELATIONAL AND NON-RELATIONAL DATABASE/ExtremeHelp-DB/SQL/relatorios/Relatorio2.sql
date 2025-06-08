--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Tempo Médio de Conclusão de Pedidos de Ajuda por Tipo

SELECT
    pa.DS_TIPO AS TIPO_PEDIDO,
    COUNT(pa.CD_PEDIDO) AS TOTAL_PEDIDOS_CONCLUIDOS,
    ROUND(AVG(av.DT_MOMENTO_CONCLUSAO - pa.DT_PEDIDO), 2) AS TEMPO_MEDIO_CONCLUSAO_DIAS
FROM
    T_EH_PEDIDO_AJUDA pa
JOIN
    T_EH_ATENDIMENTO_VOLUNTARIO av ON pa.CD_PEDIDO = av.CD_PEDIDO
WHERE
    av.DT_MOMENTO_CONCLUSAO IS NOT NULL -- Apenas pedidos que têm um atendimento concluído
GROUP BY
    pa.DS_TIPO
HAVING
    COUNT(pa.CD_PEDIDO) >= 1 -- Mostrar apenas tipos com pelo menos 1 pedido concluído
ORDER BY
    TEMPO_MEDIO_CONCLUSAO_DIAS ASC;