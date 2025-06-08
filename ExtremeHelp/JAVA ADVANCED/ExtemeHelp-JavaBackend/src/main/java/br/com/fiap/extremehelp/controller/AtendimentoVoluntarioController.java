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

import br.com.fiap.extremehelp.dto.AtendimentoVoluntarioRequestDto;
import br.com.fiap.extremehelp.filter.AtendimentoVoluntarioFilter;
import br.com.fiap.extremehelp.model.AtendimentoVoluntario;
import br.com.fiap.extremehelp.model.PedidoAjuda;
import br.com.fiap.extremehelp.model.Usuario;
import br.com.fiap.extremehelp.repository.AtendimentoVoluntarioRepository;
import br.com.fiap.extremehelp.repository.PedidoAjudaRepository;
import br.com.fiap.extremehelp.repository.UsuarioRepository;
import br.com.fiap.extremehelp.specification.AtendimentoVoluntarioSpecification;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/atendimento-voluntario")
@CrossOrigin
@Tag(name = "Atendimento Voluntario", description = "API para gerenciamento de atendimento voluntario de solicitações de ajuda no sistema da ExtremeHelp")
public class AtendimentoVoluntarioController {
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private AtendimentoVoluntarioRepository repository;

    @Autowired
    private PedidoAjudaRepository pedidoAjudaRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    //----- Documentação Swagger -----
    @Operation(
        summary = "Listar todos os atendimentos voluntarios de pedidos de ajuda",
        description = "Retorna uma lista com todos os atendimentos cadastrados no sistema",
        responses = {
                @ApiResponse(responseCode = "200", description = "Lista de atendimentos retornada com sucesso")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping
    @Cacheable("atendimentoVoluntario")
    public Page<AtendimentoVoluntario> index(AtendimentoVoluntarioFilter filter, @PageableDefault(size = 5, sort = "id", direction = Direction.DESC) Pageable pageable){

        var specification = AtendimentoVoluntarioSpecification.withFilter(filter);
        return repository.findAll(specification, pageable);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Cadastrar Atendimento Voluntario de pedido de ajuda",
        description = "Coleta os dados para adicionar um atendimento no sistema",
        responses = {
                @ApiResponse(responseCode = "201", description = "Atendimento cadastrado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
        }
    )
    //----- Documentação Swagger -----
    @PostMapping
    @CacheEvict(value = "atendimentoVoluntario", allEntries = true)
    public ResponseEntity<AtendimentoVoluntario> create(@RequestBody @Valid AtendimentoVoluntarioRequestDto dto){
        log.info("Cadastrando Atendimento voluntario");

        PedidoAjuda pedidoAjuda = pedidoAjudaRepository.findById(dto.getIdPedidoAjuda())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pedido de ajuda não encontrado"));

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado"));

        AtendimentoVoluntario atendimentoVoluntario = AtendimentoVoluntario.builder()
            .dataAceite(dto.getDataAceite())
            .dataConclusao(dto.getDataConclusao())
            .observacoes(dto.getObservacoes())
            .pedidoAjuda(pedidoAjuda)
            .usuario(usuario)
            .build();

        repository.save(atendimentoVoluntario);
        return ResponseEntity.status(201).body(atendimentoVoluntario);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Buscar Atendimento Voluntario de pedido de ajuda por ID",
        description = "Retorna os dados de um atendimento com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Atendimento encontrado"),
                @ApiResponse(responseCode = "404", description = "Atendimento encontrado")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping({"/{id}"})
    public AtendimentoVoluntario get(@PathVariable Long id){
        log.info("Buscando atendimento voluntario por ID: " + id);
        return getAtendimentoVoluntario(id);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Atualizar Atendimento Voluntario de pedido de ajuda",
        description = "Atualiza o atendimento voluntario de um pedido de ajuda existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Atendimento atualizado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
                @ApiResponse(responseCode = "404", description = "Atendimento não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @PutMapping({"/{id}"})
    @CacheEvict(value = "atendimentoVoluntario", allEntries = true)
    public AtendimentoVoluntario update(@PathVariable Long id, @RequestBody @Valid AtendimentoVoluntarioRequestDto dto){
        log.info("Atualizando atendimento voluntario " + dto.toString());

        PedidoAjuda pedidoAjuda = pedidoAjudaRepository.findById(dto.getIdPedidoAjuda())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Pedido de ajuda não encontrado"));

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado"));

        AtendimentoVoluntario atendimentoVoluntario = AtendimentoVoluntario.builder()
            .dataAceite(dto.getDataAceite())
            .dataConclusao(dto.getDataConclusao())
            .observacoes(dto.getObservacoes())
            .pedidoAjuda(pedidoAjuda)
            .usuario(usuario)
            .build();

        getAtendimentoVoluntario(id);
        atendimentoVoluntario.setId(id);
        repository.save(atendimentoVoluntario);

        return atendimentoVoluntario;
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Deletar Atendimento Voluntario de pedido de ajuda",
        description = "Remove um Atendimento Voluntario de pedido de ajuda existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "204", description = "Atendimento removido com sucesso"),
                @ApiResponse(responseCode = "404", description = "Atendimento não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @DeleteMapping({"/{id}"})
    @CacheEvict(value = "atendimentoVoluntario", allEntries = true)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id){
        log.info("Apagando Atendimento Voluntario ID: " + id);
        repository.delete(getAtendimentoVoluntario(id));
    }
    
    private AtendimentoVoluntario getAtendimentoVoluntario(Long id) {
        return repository
        .findById(id)
        .orElseThrow(
            () -> new ResponseStatusException(HttpStatus.NOT_FOUND)
        );
    } 
}
