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

import br.com.fiap.extremehelp.dto.PedidoAjudaRequestDto;
import br.com.fiap.extremehelp.filter.PedidoAjudaFilter;
import br.com.fiap.extremehelp.model.PedidoAjuda;
import br.com.fiap.extremehelp.model.Usuario;
import br.com.fiap.extremehelp.repository.PedidoAjudaRepository;
import br.com.fiap.extremehelp.repository.UsuarioRepository;
import br.com.fiap.extremehelp.specification.PedidoAjudaSpecification;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;

@RestController
@RequestMapping("/pedido-ajuda")
@CrossOrigin
@Tag(name = "Pedido de Ajuda", description = "API para gerenciamento de pedidos de ajuda no sistema da ExtremeHelp")
public class PedidoAjudaController {
    
    private Logger log = LoggerFactory.getLogger(getClass());

    @Autowired
    private PedidoAjudaRepository repository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    //----- Documentação Swagger -----
    @Operation(
        summary = "Listar todos os pedidos de ajuda",
        description = "Retorna uma lista com todos os pedidos de ajuda cadastrados no sistema",
        responses = {
                @ApiResponse(responseCode = "200", description = "Lista de pedidos de ajuda retornada com sucesso")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping
    @Cacheable("pedidoAjuda")
    public Page<PedidoAjuda> index(PedidoAjudaFilter filter, @PageableDefault(size = 5, sort = "id", direction = Direction.DESC) Pageable pageable){

        var specification = PedidoAjudaSpecification.withFilter(filter);
        return repository.findAll(specification, pageable);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Cadastrar Pedido de Ajuda",
        description = "Coleta os dados para adicionar um pedido de ajuda no sistema",
        responses = {
                @ApiResponse(responseCode = "201", description = "Pedido de ajuda cadastrado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos")
        }
    )
    //----- Documentação Swagger -----
    @PostMapping
    @CacheEvict(value = "pedidoAjuda", allEntries = true)
    public ResponseEntity<PedidoAjuda> create(@RequestBody @Valid PedidoAjudaRequestDto dto){
        log.info("Cadastrando Pedido de Ajuda");

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado"));

        PedidoAjuda pedidoAjuda = PedidoAjuda.builder()
            .tipoAjuda(dto.getTipoAjuda())
            .descricao(dto.getDescricão())
            .latitude(dto.getLatitude())
            .longitude(dto.getLongitude())
            .endereco(dto.getEndereco())
            .dataPedido(dto.getDataPedido())
            .statusPedido(dto.getStatusPedido())
            .usuario(usuario)
            .build();

        repository.save(pedidoAjuda);
        return ResponseEntity.status(201).body(pedidoAjuda);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Buscar pedido de ajuda por ID",
        description = "Retorna os dados de um pedido de ajuda com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Pedido de ajuda encontrado"),
                @ApiResponse(responseCode = "404", description = "Pedido de ajuda não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @GetMapping({"/{id}"})
    public PedidoAjuda get(@PathVariable Long id){
        log.info("Buscando pedido de ajuda por ID: " + id);
        return getPedidoAjuda(id);
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Atualizar Pedido de Ajuda",
        description = "Atualiza os dados de um pedido de ajuda existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "200", description = "Pedido de ajuda atualizado com sucesso"),
                @ApiResponse(responseCode = "400", description = "Dados inválidos fornecidos"),
                @ApiResponse(responseCode = "404", description = "Pedido de ajuda não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @PutMapping({"/{id}"})
    @CacheEvict(value = "pedidoAjuda", allEntries = true)
    public PedidoAjuda update(@PathVariable Long id, @RequestBody @Valid PedidoAjudaRequestDto dto){
        log.info("Atualizando pedido de ajuda " + dto.toString());

        Usuario usuario = usuarioRepository.findById(dto.getIdUsuario())
            .orElseThrow(() -> new ResponseStatusException(HttpStatus.BAD_REQUEST, "Usuário não encontrado"));

        PedidoAjuda pedidoAjuda = PedidoAjuda.builder()
            .tipoAjuda(dto.getTipoAjuda())
            .descricao(dto.getDescricão())
            .latitude(dto.getLatitude())
            .longitude(dto.getLongitude())
            .endereco(dto.getEndereco())
            .dataPedido(dto.getDataPedido())
            .statusPedido(dto.getStatusPedido())
            .usuario(usuario)
            .build();

        getPedidoAjuda(id);
        pedidoAjuda.setId(id);
        repository.save(pedidoAjuda);

        return pedidoAjuda;
    }

    //----- Documentação Swagger -----
    @Operation(
        summary = "Deletar Pedido de Ajuda",
        description = "Remove um pedido de ajuda existente com base no ID fornecido",
        responses = {
                @ApiResponse(responseCode = "204", description = "Pedido de ajuda removido com sucesso"),
                @ApiResponse(responseCode = "404", description = "Pedido de ajuda não encontrado")
        }
    )
    //----- Documentação Swagger -----
    @DeleteMapping({"/{id}"})
    @CacheEvict(value = "pedidoAjuda", allEntries = true)
    @ResponseStatus(HttpStatus.NO_CONTENT)
    public void delete(@PathVariable Long id){
        log.info("Apagando Pedido de ajuda ID: " + id);
        repository.delete(getPedidoAjuda(id));
    }
    
    private PedidoAjuda getPedidoAjuda(Long id) {
        return repository
        .findById(id)
        .orElseThrow(
            () -> new ResponseStatusException(HttpStatus.NOT_FOUND)
        );
    } 
}
