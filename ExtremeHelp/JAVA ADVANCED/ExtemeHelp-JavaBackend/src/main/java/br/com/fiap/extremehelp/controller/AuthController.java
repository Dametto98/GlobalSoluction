package br.com.fiap.extremehelp.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import br.com.fiap.extremehelp.model.Credentials;
import br.com.fiap.extremehelp.model.Token;
import br.com.fiap.extremehelp.model.Usuario;
import br.com.fiap.extremehelp.service.AuthService;
import br.com.fiap.extremehelp.service.TokenService;

@RestController
public class AuthController {
    
    @Autowired
    private AuthService authService;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private TokenService tokenService;

    @PostMapping("/login")
    public Token login(@RequestBody Credentials credentials){
        Usuario usuario = (Usuario) authService.loadUserByUsername(credentials.email());
        if (!passwordEncoder.matches(credentials.password(), usuario.getPassword())){
            throw new BadCredentialsException("Senha incorreta");
        }
        return tokenService.createToken(usuario);
    }
    
}
