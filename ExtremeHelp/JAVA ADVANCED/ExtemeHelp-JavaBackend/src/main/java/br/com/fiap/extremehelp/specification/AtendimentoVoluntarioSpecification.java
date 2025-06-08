package br.com.fiap.extremehelp.specification;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import br.com.fiap.extremehelp.filter.AtendimentoVoluntarioFilter;
import br.com.fiap.extremehelp.model.AtendimentoVoluntario;
import jakarta.persistence.criteria.Predicate;

public class AtendimentoVoluntarioSpecification {
    public static Specification<AtendimentoVoluntario> withFilter( AtendimentoVoluntarioFilter filter ){
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if (filter.dataAceiteInicio() != null && filter.dataAceiteFim() != null) {
                predicates.add(cb.between(root.get("dataAceite"), filter.dataAceiteInicio(), filter.dataAceiteFim()));
            }

            if (filter.dataAceiteInicio() != null && filter.dataAceiteFim() == null) {
                predicates.add(cb.equal(root.get("dataAceite"), filter.dataAceiteInicio()));
            }
            
            if (filter.dataAceiteFim() != null && filter.dataAceiteInicio() == null) {
                predicates.add(cb.equal(root.get("dataAceite"), filter.dataAceiteFim()));
            }

            if (filter.dataConclusaoInicio() != null && filter.dataConclusaoFim() != null) {
                predicates.add(cb.between(root.get("dataConclusao"), filter.dataConclusaoInicio(), filter.dataConclusaoFim()));
            }

            if (filter.dataConclusaoInicio() != null && filter.dataConclusaoFim() == null) {
                predicates.add(cb.equal(root.get("dataConclusao"), filter.dataConclusaoInicio()));
            }
            
            if (filter.dataConclusaoFim() != null && filter.dataConclusaoInicio() == null) {
                predicates.add(cb.equal(root.get("dataConclusao"), filter.dataConclusaoFim()));
            }

            if(filter.pedidoAjudaId() != null) {
                predicates.add(cb.equal(root.get("pedidoAjuda").get("id"), filter.pedidoAjudaId()));
            }

            if(filter.usuarioId() != null) {
                predicates.add(cb.equal(root.get("usuario").get("id"), filter.usuarioId()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
