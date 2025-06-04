--Nome: Caike Dametto RM: 558614
--Nome: Guilhetme Janunzzi RM: 558461

--Solicitantes com Múltiplos Pedidos Não Concluídos

SELECT
    u.NM_USUARIO AS NOME_SOLICITANTE,
    u.DS_EMAIL AS EMAIL_SOLICITANTE,
    COUNT(pa.CD_PEDIDO) AS TOTAL_PEDIDOS_NAO_CONCLUIDOS
FROM
    T_EH_USUARIO u
JOIN
    T_EH_PEDIDO_AJUDA pa ON u.CD_USUARIO = pa.CD_USUARIO
WHERE
    u.DS_TIPO = 'SOLICITANTE' -- Focando nos solicitantes
    AND pa.DS_STATUS IN ('PENDENTE', 'EM_ATENDIMENTO') -- Status que indicam não conclusão
GROUP BY
    u.CD_USUARIO, u.NM_USUARIO, u.DS_EMAIL
HAVING
    COUNT(pa.CD_PEDIDO) > 1 -- Usuários com mais de 1 pedido não concluído
ORDER BY
    TOTAL_PEDIDOS_NAO_CONCLUIDOS DESC, u.NM_USUARIO ASC;