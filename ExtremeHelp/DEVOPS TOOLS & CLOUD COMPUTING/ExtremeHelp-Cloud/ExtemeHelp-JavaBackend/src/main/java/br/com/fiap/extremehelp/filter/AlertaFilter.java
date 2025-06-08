package br.com.fiap.extremehelp.filter;

import java.time.LocalDate;

import br.com.fiap.extremehelp.model.SeriedadeAlerta;

public record AlertaFilter(
    LocalDate dataInicio,
    LocalDate dataFim,
    SeriedadeAlerta seriedadeAlerta,
    Boolean ativo
) {}
