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

import br.com.fiap.extremehelp.filter.DicaPreparacaoFilter;
import br.com.fiap.extremehelp.model.DicaPreparacao;
import br.com.fiap.extremehelp.repository.DicaPreparacaoRepository;
import br.com.fiap.extremehelp.specification.DicaPreparacaoSpecification;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/dica-preparacao")
@CrossOrigin
@Tag(name = "Dica de Preparação", description = "API para gerenciamento de dicas de preparaçã no sistema da ExtremeHelp")
public class DicaPreparacaoController {
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private DicaPreparacaoRepository repository;

    //----- Documentação Swagger -----
    @Operation(
        summary = "Listar todos as dicas de preparação",
        description = "Retorna uma lista com todas as dicas cadastrados no sistema",
        responses = {
                @ApiResponse(responseCode = "200", description = "Lista dicas retornada com sucesso")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping
    @Cacheable("dicaPreparacao")
    public Page<DicaPreparacao> index(DicaPreparacaoFilter filter, @PageableDefault(size = 5, sort = "id", direction = Direction.DESC) Pageable pageable){

        var specification = DicaPreparacaoSpecification.withFilter(filter);
        return repository.findAll(specification, pageable);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Cadastrar Dica de Preparação",
        description = "Coleta os dados para adicionar uma dica no sistema",
        responses = {
                @ApiResponse(responseCode = "201", description = "Dica cadastrada com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
        }
    )
    //----- Documentação Swagger -----
    @PostMapping
    @CacheEvict(value = "dicaPreparacao", allEntries = true)
    public ResponseEntity<DicaPreparacao> create(@RequestBody @Valid DicaPreparacao dicaPreparacao){
        log.info("Cadastrando dica");

        repository.save(dicaPreparacao);
        return ResponseEntity.status(201).body(dicaPreparacao);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Buscar Dica de Preparação por ID",
        description = "Retorna os dados de uma dica com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Dica encontrada"),
                @ApiResponse(responseCode = "404", description = "Dica não enconrada")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping({"/{id}"})
    public DicaPreparacao get(@PathVariable Long id){
        log.info("Buscando Dica por ID: " + id);
        return getDicaPreparacao(id);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Atualizar Dica de Preparação",
        description = "Atualiza os dados de uma dica existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Dica atualizada com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
                @ApiResponse(responseCode = "404", description = "Dica não encontrada")
        }
    )
    //----- Documentação Swagger -----
    @PutMapping({"/{id}"})
    @CacheEvict(value = "dicaPreparacao", allEntries = true)
    public DicaPreparacao update(@PathVariable Long id, @RequestBody @Valid DicaPreparacao dicaPreparacao){
        log.info("Atualizando dica " + dicaPreparacao.toString());

        getDicaPreparacao(id);
        dicaPreparacao.setId(id);
        repository.save(dicaPreparacao);

        return dicaPreparacao;
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Deletar Dica de Preparação",
        description = "Remove uma dica existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "204", description = "Dica removida com sucesso"),
                @ApiResponse(responseCode = "404", description = "Dica não encontrada")
        }
    )
    //----- Documentação Swagger -----
    @DeleteMapping({"/{id}"})
    @CacheEvict(value = "dicaPreparacao", allEntries = true)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id){
        log.info("Apagando dica ID: " + id);
        repository.delete(getDicaPreparacao(id));
    }
    
    private DicaPreparacao getDicaPreparacao(Long id) {
        return repository
        .findById(id)
        .orElseThrow(
            () -> new ResponseStatusException(HttpStatus.NOT_FOUND)
        );
    }    
}
