package br.com.fiap.extremehelp.service;

import java.time.Instant;
import java.time.LocalDateTime;
import java.time.ZoneOffset;

import org.springframework.stereotype.Service;

import com.auth0.jwt.JWT;
import com.auth0.jwt.algorithms.Algorithm;

import br.com.fiap.extremehelp.model.TipoUsuario;
import br.com.fiap.extremehelp.model.Token;
import br.com.fiap.extremehelp.model.Usuario;

@Service
public class TokenService {
    private Instant expiresAt = LocalDateTime.now().plusMinutes(10).toInstant(ZoneOffset.ofHours(-3));
    private Algorithm algorithm = Algorithm.HMAC256("extremeHelp@123");
    
     public Token createToken(Usuario usuario){
        var jwt = JWT.create()
                    .withSubject(usuario.getId().toString())
                    .withClaim("email", usuario.getEmail())
                    .withClaim("role", usuario.getTipoUsuario().toString())
                    .withExpiresAt(expiresAt)
                    .sign(algorithm);

        return new Token(jwt, usuario.getEmail());
    }

    public Usuario getUsuarioFromToken(String jwt) {
        var jwtVerified = JWT.require(algorithm).build().verify(jwt);
        
        String roleFromTokenString = jwtVerified.getClaim("role").asString(); // Obtenha a role como String
        TipoUsuario tipoUsuarioEnum;

        try {
            tipoUsuarioEnum = TipoUsuario.valueOf(roleFromTokenString.toUpperCase());
        } catch (IllegalArgumentException e) {
            System.err.println("Role inválida no token: " + roleFromTokenString);
            throw new RuntimeException("Role inválida no token", e);
        }
        
        return Usuario.builder()
                    .id(Long.valueOf(jwtVerified.getSubject()))
                    .email(jwtVerified.getClaim("email").toString())
                    .tipoUsuario(tipoUsuarioEnum)
                    .build();

    }
}
