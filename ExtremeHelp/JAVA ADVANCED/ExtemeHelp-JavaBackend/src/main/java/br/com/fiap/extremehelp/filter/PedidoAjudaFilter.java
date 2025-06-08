package br.com.fiap.extremehelp.filter;

import java.time.LocalDate;

import br.com.fiap.extremehelp.model.StatusPedido;

public record PedidoAjudaFilter(
    String tipoAjuda,
    LocalDate dataInicio,
    LocalDate dataFim,
    StatusPedido statusPedido,
    Long usuarioId
) {}
