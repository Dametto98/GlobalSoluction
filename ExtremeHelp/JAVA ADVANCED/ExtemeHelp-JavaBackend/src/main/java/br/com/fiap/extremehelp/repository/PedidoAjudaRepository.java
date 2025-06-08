package br.com.fiap.extremehelp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import br.com.fiap.extremehelp.model.PedidoAjuda;

public interface PedidoAjudaRepository extends JpaRepository<PedidoAjuda, Long>, JpaSpecificationExecutor<PedidoAjuda>{
    
}
