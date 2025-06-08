package br.com.fiap.extremehelp.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.server.ResponseStatusException;

import br.com.fiap.extremehelp.filter.AlertaFilter;
import br.com.fiap.extremehelp.model.Alerta;
import br.com.fiap.extremehelp.repository.AlertaRepositry;
import br.com.fiap.extremehelp.specification.AlertaSpecification;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/alerta")
@CrossOrigin
@Tag(name = "Alerta", description = "API para gerenciamento de alertas no sistema da ExtremeHelp")
public class AlertaController {
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private AlertaRepositry repository;

    //----- Documentação Swagger -----
    @Operation(
        summary = "Listar todos os alertas",
        description = "Retorna uma lista com todos os alertas cadastrados no sistema",
        responses = {
                @ApiResponse(responseCode = "200", description = "Lista de alertas retornada com sucesso")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping
    @Cacheable("alerta")
    public Page<Alerta> index(AlertaFilter filter, @PageableDefault(size = 5, sort = "id", direction = Direction.DESC) Pageable pageable){

        var specification = AlertaSpecification.withFilter(filter);
        return repository.findAll(specification, pageable);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Cadastrar Usuário",
        description = "Coleta os dados para adicionar um usuário no sistema",
        responses = {
                @ApiResponse(responseCode = "201", description = "Usuário cadastrado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
        }
    )
    //----- Documentação Swagger -----
    @PostMapping
    @CacheEvict(value = "alerta", allEntries = true)
    public ResponseEntity<Alerta> create(@RequestBody @Valid Alerta alerta){
        log.info("Cadastrando alerta");

        repository.save(alerta);
        return ResponseEntity.status(201).body(alerta);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Buscar Alerta por ID",
        description = "Retorna os dados de um alerta com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Alerta encontrado"),
                @ApiResponse(responseCode = "404", description = "Alerta não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping({"/{id}"})
    public Alerta get(@PathVariable Long id){
        log.info("Buscando laerta por ID: " + id);
        return getAlerta(id);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Atualizar Alerta",
        description = "Atualiza os dados de um alerta existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Alerta atualizado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
                @ApiResponse(responseCode = "404", description = "Alerta não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @PutMapping({"/{id}"})
    @CacheEvict(value = "alerta", allEntries = true)
    public Alerta update(@PathVariable Long id, @RequestBody @Valid Alerta alerta){
        log.info("Atualizando alerta " + alerta.toString());

        getAlerta(id);
        alerta.setId(id);
        repository.save(alerta);

        return alerta;
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Deletar Alerta",
        description = "Remove um Alerta existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "204", description = "Alerta removido com sucesso"),
                @ApiResponse(responseCode = "404", description = "Alerta não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @DeleteMapping({"/{id}"})
    @CacheEvict(value = "alerta", allEntries = true)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id){
        log.info("Apagando alerta ID: " + id);
        repository.delete(getAlerta(id));
    }
    
    private Alerta getAlerta(Long id) {
        return repository
        .findById(id)
        .orElseThrow(
            () -> new ResponseStatusException(HttpStatus.NOT_FOUND)
        );
    }    
}
