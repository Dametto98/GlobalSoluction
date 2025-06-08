package br.com.fiap.extremehelp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import br.com.fiap.extremehelp.model.Alerta;

public interface AlertaRepositry extends JpaRepository<Alerta, Long>, JpaSpecificationExecutor<Alerta>{
    
}
