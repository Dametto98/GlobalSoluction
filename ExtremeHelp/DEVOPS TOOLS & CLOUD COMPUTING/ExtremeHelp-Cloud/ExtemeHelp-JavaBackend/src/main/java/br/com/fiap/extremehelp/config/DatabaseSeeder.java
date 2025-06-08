package br.com.fiap.extremehelp.config;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Profile;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import br.com.fiap.extremehelp.model.Alerta;
import br.com.fiap.extremehelp.model.AtendimentoVoluntario;
import br.com.fiap.extremehelp.model.DicaPreparacao;
import br.com.fiap.extremehelp.model.PedidoAjuda;
import br.com.fiap.extremehelp.model.SeriedadeAlerta;
import br.com.fiap.extremehelp.model.StatusPedido;
import br.com.fiap.extremehelp.model.TipoUsuario;
import br.com.fiap.extremehelp.model.Usuario;
import br.com.fiap.extremehelp.repository.AlertaRepositry;
import br.com.fiap.extremehelp.repository.AtendimentoVoluntarioRepository;
import br.com.fiap.extremehelp.repository.DicaPreparacaoRepository;
import br.com.fiap.extremehelp.repository.PedidoAjudaRepository;
import br.com.fiap.extremehelp.repository.UsuarioRepository;
import jakarta.annotation.PostConstruct;

@Configuration
@Profile("dev")
public class DatabaseSeeder {
    
    @Autowired
    UsuarioRepository usuarioRepository;

    @Autowired
    PedidoAjudaRepository pedidoAjudaRepository;

    @Autowired
    AtendimentoVoluntarioRepository atendimentoVoluntarioRepository;

    @Autowired
    AlertaRepositry alertaRepositry;

    @Autowired
    DicaPreparacaoRepository dicaPreparacaoRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostConstruct
    @Transactional
    public void init(){
        // Salva usuários e obtém as instâncias gerenciadas
        List<Usuario> usuariosSalvos = usuarioRepository.saveAll(List.of(
                Usuario.builder()
                        .nome("Cauã Aragão")
                        .email("aragao@mottomap.com")
                        .senha(passwordEncoder.encode("caua12345"))
                        .telefone("(11) 96217-2718")
                        .tipoUsuario(TipoUsuario.SOLICITANTE)
                        .dataRegistro(LocalDate.parse("2025-05-21", DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                        .status(false)
                        .build(),
                Usuario.builder()
                        .nome("Gustavo Oliveira")
                        .email("gustavo@mottomap.com")
                        .senha(passwordEncoder.encode("gustavo12345"))
                        .telefone("(11) 96217-6547")
                        .tipoUsuario(TipoUsuario.VOLUNTARIO)
                        .dataRegistro(LocalDate.parse("2025-05-27", DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                        .status(true)
                        .build(),
                Usuario.builder()
                        .nome("Pedro Barbosa")
                        .email("p.barbosa@mottomap.com")
                        .senha(passwordEncoder.encode("barbosa12345"))
                        .telefone("(11) 97843-1293")
                        .tipoUsuario(TipoUsuario.ADMIN)
                        .dataRegistro(LocalDate.parse("2025-05-30", DateTimeFormatter.ofPattern("yyyy-MM-dd")))
                        .status(true)
                        .build()
        ));

        // Salva pedidos de ajuda usando os usuários gerenciados e obtém os pedidos gerenciados
        List<PedidoAjuda> pedidosAjudaSalvos = pedidoAjudaRepository.saveAll(List.of(
                PedidoAjuda.builder()
                        .tipoAjuda("Alimentação")
                        .descricao("Solicita cesta básica para família com 2 crianças") // Corrigido: descricao
                        .latitude(-23.561234)
                        .longitude(-46.655678)
                        .endereco("Rua das Laranjeiras, 150, São Paulo, SP")
                        .dataPedido(LocalDateTime.parse("2025-05-28 16:51", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
                        .statusPedido(StatusPedido.PENDENTE)
                        .usuario(usuariosSalvos.get(0)) // <-- USA A INSTÂNCIA GERENCIADA
                        .build(),
                PedidoAjuda.builder()
                        .tipoAjuda("Remédios")
                        .descricao("Ajuda para obter medicamentos controlados para idosa de 74 anos") // Corrigido: descricao
                        .latitude(-23.567891)
                        .longitude(-46.678901)
                        .endereco("Avenida Paulista, 1000, São Paulo, SP")
                        .dataPedido(LocalDateTime.parse("2025-05-29 10:21", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
                        .statusPedido(StatusPedido.EM_ATENDIMENTO)
                        .usuario(usuariosSalvos.get(1)) // <-- USA A INSTÂNCIA GERENCIADA
                        .build(),
                PedidoAjuda.builder()
                        .tipoAjuda("Acompanhamento Médico")
                        .descricao("Precisa de acompanhamento médico para paciente com mobilidade reduzida") // Corrigido: descricao
                        .latitude(-23.587328)
                        .longitude(-46.600000)
                        .endereco("Rua Bela Vista, 45, São Paulo, SP")
                        .dataPedido(LocalDateTime.parse("2025-05-30 17:43", DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm")))
                        .statusPedido(StatusPedido.CONCLUIDO)
                        .usuario(usuariosSalvos.get(2)) // <-- USA A INSTÂNCIA GERENCIADA
                        .build()
        ));

        
        atendimentoVoluntarioRepository.saveAll(List.of(
                AtendimentoVoluntario.builder()
                        .dataAceite(LocalDateTime.parse("2025-05-28T14:30")) // Formato ISO, ok para LocalDateTime.parse()
                        .dataConclusao(null)
                        .observacoes(null)
                        .pedidoAjuda(pedidosAjudaSalvos.get(0)) // <-- USA A INSTÂNCIA GERENCIADA
                        .usuario(usuariosSalvos.get(1))         // <-- USA A INSTÂNCIA GERENCIADA
                        .build(),
                AtendimentoVoluntario.builder()
                        .dataAceite(LocalDateTime.parse("2025-05-29T09:00"))
                        .dataConclusao(LocalDateTime.parse("2025-05-30T11:45"))
                        .observacoes("Entrega realizada com sucesso. Beneficiário agradeceu.")
                        .pedidoAjuda(pedidosAjudaSalvos.get(1)) // <-- USA A INSTÂNCIA GERENCIADA
                        .usuario(usuariosSalvos.get(1))         // <-- USA A INSTÂNCIA GERENCIADA
                        .build(),
                AtendimentoVoluntario.builder()
                        .dataAceite(LocalDateTime.parse("2025-05-31T08:15"))
                        .dataConclusao(null)
                        .observacoes("Voluntário saiu para entrega, previsão de chegada às 10h.")
                        .pedidoAjuda(pedidosAjudaSalvos.get(2)) // <-- USA A INSTÂNCIA GERENCIADA
                        .usuario(usuariosSalvos.get(1))         // <-- USA A INSTÂNCIA GERENCIADA
                        .build()
        ));

        // Alertas (não têm associações problemáticas neste contexto, mas é bom manter a consistência se tivessem)
        alertaRepositry.saveAll(List.of(
                Alerta.builder()
                        .titulo("Alerta de enchente")
                        .mensagem("Chuvas intensas previstas para a zona norte. Risco de alagamentos.")
                        .dataPublicacao(LocalDateTime.parse("2025-05-30T08:00"))
                        .seriedadeAlerta(SeriedadeAlerta.GRAVE)
                        .fonte("Defesa Civil de São Paulo")
                        .ativo(true)
                        .build(),
                Alerta.builder()
                        .titulo("Alerta de calor extremo")
                        .mensagem("Temperaturas acima de 40ºC previstas para esta semana. Redobre a hidratação.")
                        .dataPublicacao(LocalDateTime.parse("2025-05-28T14:30"))
                        .seriedadeAlerta(SeriedadeAlerta.GRAVE)
                        .fonte("INMET")
                        .ativo(true)
                        .build(),
                Alerta.builder()
                        .titulo("Alerta de baixa umidade")
                        .mensagem("Umidade do ar abaixo de 20%. Evite exercícios físicos ao ar livre no período da tarde.")
                        .dataPublicacao(LocalDateTime.parse("2025-05-25T09:15"))
                        .seriedadeAlerta(SeriedadeAlerta.INFORMATIVO)
                        .fonte("CETESB")
                        .ativo(false)
                        .build()
        ));

        // Dicas (idem)
        dicaPreparacaoRepository.saveAll(List.of(
                DicaPreparacao.builder()
                        .titulo("Kit de emergência")
                        .conteudo("Inclua água potável, alimentos não perecíveis, lanterna, pilhas, documentos e medicamentos de uso contínuo.")
                        .categoria("Prevenção")
                        .dataAtualizacao(LocalDateTime.parse("2025-05-15T09:30"))
                        .build(),
                DicaPreparacao.builder()
                        .titulo("Chuvas fortes") // Corrigido: "fortes"
                        .conteudo("Não caminhe em áreas alagadas, mantenha-se em locais altos e evite contato com a rede elétrica.")
                        .categoria("Segurança")
                        .dataAtualizacao(LocalDateTime.parse("2025-05-20T14:45"))
                        .build(),
                DicaPreparacao.builder()
                        .titulo("Contatos de Emergência")
                        .conteudo("Mantenha uma lista atualizada com telefones da Defesa Civil, Corpo de Bombeiros, e familiares.")
                        .categoria("Organização")
                        .dataAtualizacao(LocalDateTime.parse("2025-05-25T08:10"))
                        .build()
        ));
    }
}
