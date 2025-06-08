package br.com.fiap.extremehelp.specification;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import br.com.fiap.extremehelp.filter.UsuarioFilter;
import br.com.fiap.extremehelp.model.Usuario;
import jakarta.persistence.criteria.Predicate;

public class UsuarioSpecification {
    public static Specification<Usuario> withFilter( UsuarioFilter filter ){
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if(filter.nome() != null){
                predicates.add(cb.like(cb.lower(root.get("nome")), "%" + filter.nome().toLowerCase() + "%"));
            }

            if(filter.email() != null){
                predicates.add(cb.equal(root.get("email"), filter.email()));
            }

            if(filter.tipoUsuario() != null){
                predicates.add(cb.equal(root.get("tipoUsuario"), filter.tipoUsuario()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
