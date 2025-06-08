package br.com.fiap.extremehelp.specification;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import br.com.fiap.extremehelp.filter.DicaPreparacaoFilter;
import br.com.fiap.extremehelp.model.DicaPreparacao;
import jakarta.persistence.criteria.Predicate;

public class DicaPreparacaoSpecification {
    public static Specification<DicaPreparacao> withFilter( DicaPreparacaoFilter filter ){
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if(filter.categoria() != null){
                predicates.add(cb.like(cb.lower(root.get("categoria")), "%" + filter.categoria().toLowerCase() + "%"));
            }

            if (filter.dataInicio() != null && filter.dataFim() != null) {
                predicates.add(cb.between(root.get("dataAtualizacao"), filter.dataInicio(), filter.dataFim()));
            }

            if (filter.dataInicio() != null && filter.dataFim() == null) {
                predicates.add(cb.equal(root.get("dataAtualizacao"), filter.dataInicio()));
            }
            
            if (filter.dataFim() != null && filter.dataInicio() == null) {
                predicates.add(cb.equal(root.get("dataAtualizacao"), filter.dataFim()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
