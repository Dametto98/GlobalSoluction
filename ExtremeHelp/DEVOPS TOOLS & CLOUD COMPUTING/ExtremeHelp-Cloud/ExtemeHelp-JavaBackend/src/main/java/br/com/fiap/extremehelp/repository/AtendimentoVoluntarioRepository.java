package br.com.fiap.extremehelp.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;

import br.com.fiap.extremehelp.model.AtendimentoVoluntario;

public interface AtendimentoVoluntarioRepository extends JpaRepository<AtendimentoVoluntario, Long>, JpaSpecificationExecutor<AtendimentoVoluntario>{
    
}
