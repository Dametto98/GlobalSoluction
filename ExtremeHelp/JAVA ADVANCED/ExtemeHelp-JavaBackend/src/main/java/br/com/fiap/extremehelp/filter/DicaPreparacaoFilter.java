package br.com.fiap.extremehelp.filter;

import java.time.LocalDate;

public record DicaPreparacaoFilter(
    String categoria,
    LocalDate dataInicio,
    LocalDate dataFim
) {}
