package br.com.fiap.extremehelp.filter;

import java.time.LocalDate;

public record AtendimentoVoluntarioFilter(
    LocalDate dataAceiteInicio,
    LocalDate dataAceiteFim,
    LocalDate dataConclusaoInicio,
    LocalDate dataConclusaoFim,
    Long pedidoAjudaId,    
    Long usuarioId
) {}
