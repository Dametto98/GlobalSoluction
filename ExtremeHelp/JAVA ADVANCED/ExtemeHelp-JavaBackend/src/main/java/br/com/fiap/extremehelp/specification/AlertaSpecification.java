package br.com.fiap.extremehelp.specification;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import br.com.fiap.extremehelp.filter.AlertaFilter;
import br.com.fiap.extremehelp.model.Alerta;
import jakarta.persistence.criteria.Predicate;

public class AlertaSpecification {
    public static Specification<Alerta> withFilter( AlertaFilter filter ){
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (filter.dataInicio() != null && filter.dataFim() != null) {
                predicates.add(cb.between(root.get("dataPublicacao"), filter.dataInicio(), filter.dataFim()));
            }

            if (filter.dataInicio() != null && filter.dataFim() == null) {
                predicates.add(cb.equal(root.get("dataPublicacao"), filter.dataInicio()));
            }
            
            if (filter.dataFim() != null && filter.dataInicio() == null) {
                predicates.add(cb.equal(root.get("dataPublicacao"), filter.dataFim()));
            }

            if(filter.seriedadeAlerta() != null){
                predicates.add(cb.equal(root.get("seriedadeAlerta"), filter.seriedadeAlerta()));
            }

            if(filter.ativo() != null){
                predicates.add(cb.equal(root.get("ativo"), filter.ativo()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
