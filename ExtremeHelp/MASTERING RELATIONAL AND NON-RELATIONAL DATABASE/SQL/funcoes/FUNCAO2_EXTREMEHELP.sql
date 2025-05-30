--Função para Verificar Eficiência de Voluntários

CREATE OR REPLACE FUNCTION fn_eficiencia_voluntario (
    p_cd_voluntario IN NUMBER
) RETURN VARCHAR2
AS
    v_nome_voluntario VARCHAR2(200);
    v_total_atendimentos NUMBER;
    v_atendimentos_concluidos NUMBER;
    v_tempo_medio_conclusao NUMBER;
    v_eficiencia VARCHAR2(100);
    v_resultado VARCHAR2(1000);
BEGIN
    -- Verificar se o usuário é voluntário
    SELECT COUNT(*) INTO v_total_atendimentos
    FROM T_EH_USUARIO u
    WHERE u.CD_USUARIO = p_cd_voluntario
    AND u.DS_TIPO = 'VOLUNTARIO';
    
    IF v_total_atendimentos = 0 THEN
        RETURN 'Usuário não é um voluntário ou não encontrado.';
    END IF;
    
    -- Obter nome do voluntário
    SELECT NM_USUARIO INTO v_nome_voluntario
    FROM T_EH_USUARIO
    WHERE CD_USUARIO = p_cd_voluntario;
    
    -- Contar total de atendimentos
    SELECT COUNT(*) INTO v_total_atendimentos
    FROM T_EH_ATENDIMENTO_VOLUNTARIO
    WHERE CD_USUARIO = p_cd_voluntario;
    
    -- Contar atendimentos concluídos
    SELECT COUNT(*) INTO v_atendimentos_concluidos
    FROM T_EH_ATENDIMENTO_VOLUNTARIO
    WHERE CD_USUARIO = p_cd_voluntario
    AND DT_MOMENTO_CONCLUSAO IS NOT NULL;
    
    -- Calcular tempo médio de conclusão (em horas)
    SELECT ROUND(AVG((DT_MOMENTO_CONCLUSAO - DT_MOMENTO_ACEITE) * 24), 2)
    INTO v_tempo_medio_conclusao
    FROM T_EH_ATENDIMENTO_VOLUNTARIO
    WHERE CD_USUARIO = p_cd_voluntario
    AND DT_MOMENTO_CONCLUSAO IS NOT NULL;
    
    -- Determinar classificação de eficiência
    IF v_total_atendimentos = 0 THEN
        v_eficiencia := 'Sem atendimentos registrados';
    ELSIF v_atendimentos_concluidos = 0 THEN
        v_eficiencia := 'Nenhum atendimento concluído';
    ELSE
        CASE
            WHEN v_tempo_medio_conclusao < 12 THEN v_eficiencia := 'Muito eficiente';
            WHEN v_tempo_medio_conclusao < 24 THEN v_eficiencia := 'Eficiente';
            WHEN v_tempo_medio_conclusao < 48 THEN v_eficiencia := 'Moderado';
            ELSE v_eficiencia := 'Pode melhorar';
        END CASE;
    END IF;
    
    -- Formatando o resultado
    v_resultado := 'Relatório de Eficiência para ' || v_nome_voluntario || ':' || CHR(10) ||
                   'Total de Atendimentos: ' || v_total_atendimentos || CHR(10) ||
                   'Atendimentos Concluídos: ' || v_atendimentos_concluidos || CHR(10) ||
                   'Taxa de Conclusão: ' || 
                   CASE WHEN v_total_atendimentos > 0 
                        THEN ROUND((v_atendimentos_concluidos/v_total_atendimentos)*100) || '%'
                        ELSE '0%' END || CHR(10) ||
                   'Tempo Médio de Conclusão: ' || 
                   CASE WHEN v_tempo_medio_conclusao IS NOT NULL 
                        THEN v_tempo_medio_conclusao || ' horas' 
                        ELSE 'N/A' END || CHR(10) ||
                   'Classificação: ' || v_eficiencia;
    
    RETURN v_resultado;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'Erro ao calcular eficiência: ' || SQLERRM;
END fn_eficiencia_voluntario;
/

--TESTE
SELECT fn_eficiencia_voluntario(1) FROM dual;