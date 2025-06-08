package br.com.fiap.extremehelp.specification;

import java.util.ArrayList;
import java.util.List;

import org.springframework.data.jpa.domain.Specification;

import br.com.fiap.extremehelp.filter.PedidoAjudaFilter;
import br.com.fiap.extremehelp.model.PedidoAjuda;
import jakarta.persistence.criteria.Predicate;

public class PedidoAjudaSpecification {
    public static Specification<PedidoAjuda> withFilter( PedidoAjudaFilter filter ){
        return (root, query, cb) -> {
            List<Predicate> predicates = new ArrayList<>();

            if(filter.tipoAjuda() != null){
                predicates.add(cb.like(cb.lower(root.get("tipoAjuda")), "%" + filter.tipoAjuda().toLowerCase() + "%"));
            }

            if (filter.dataInicio() != null && filter.dataFim() != null) {
                predicates.add(cb.between(root.get("dataPedido"), filter.dataInicio(), filter.dataFim()));
            }

            if (filter.dataInicio() != null && filter.dataFim() == null) {
                predicates.add(cb.equal(root.get("dataPedido"), filter.dataInicio()));
            }
            
            if (filter.dataFim() != null && filter.dataInicio() == null) {
                predicates.add(cb.equal(root.get("dataPedido"), filter.dataFim()));
            }

            if(filter.statusPedido() != null){
                predicates.add(cb.equal(root.get("statusPedido"), filter.statusPedido()));
            }

            if(filter.usuarioId() != null) {
                predicates.add(cb.equal(root.get("usuario").get("id"), filter.usuarioId()));
            }

            return cb.and(predicates.toArray(new Predicate[0]));
        };
    }
}
