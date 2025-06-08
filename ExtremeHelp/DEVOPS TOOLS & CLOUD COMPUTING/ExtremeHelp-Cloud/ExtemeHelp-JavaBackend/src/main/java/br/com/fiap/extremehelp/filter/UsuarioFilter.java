package br.com.fiap.extremehelp.filter;

import br.com.fiap.extremehelp.model.TipoUsuario;

public record UsuarioFilter(
    String nome,
    String email,
    TipoUsuario tipoUsuario
) {}