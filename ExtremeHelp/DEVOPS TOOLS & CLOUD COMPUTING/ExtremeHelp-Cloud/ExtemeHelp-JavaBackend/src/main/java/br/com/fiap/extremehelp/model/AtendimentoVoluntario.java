    package br.com.fiap.extremehelp.model;

    import java.time.LocalDateTime;

    import com.fasterxml.jackson.annotation.JsonFormat;

    import io.swagger.v3.oas.annotations.media.Schema;
    import jakarta.persistence.Column;
    import jakarta.persistence.Entity;
    import jakarta.persistence.GeneratedValue;
    import jakarta.persistence.GenerationType;
    import jakarta.persistence.Id;
    import jakarta.persistence.JoinColumn;
    import jakarta.persistence.ManyToOne;
    import jakarta.persistence.OneToOne;
    import jakarta.persistence.SequenceGenerator;
    import jakarta.persistence.Table;
    import jakarta.validation.constraints.NotNull;
    import jakarta.validation.constraints.PastOrPresent;
    import jakarta.validation.constraints.Size;
    import lombok.AllArgsConstructor;
    import lombok.Builder;
    import lombok.Data;
    import lombok.NoArgsConstructor;

    @Entity
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    @Schema(description = "Entidade que representa um atendimento de vluntario no sistema da ExtemeHelp")
    @Table(name = "T_EH_ATENDIMENTO_VOLUNTARIO")
    public class AtendimentoVoluntario {
        @Id
        @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "atendimento_voluntario_seq_gen")
        @SequenceGenerator(name = "atendimento_voluntario_seq_gen", sequenceName = "SEQ_EH_ATENDIMENTO_VOLUNTARIO", allocationSize = 1)
        @Schema(description = "ID único do atendimento voluntario de um pedido de ajuda", example = "1", readOnly = true)
        @Column(name = "CD_ATENDIMENTO")
        private long id;

        @NotNull(message = "A data é obrigatória")
        @PastOrPresent(message = "A data de aceite não pode estar no futuro.")
        @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
        @Schema(description = "Data de aceite do pedido de ajuda", example = "30/05/2025 10:30", required = true)
        @Column(name = "DT_MOMENTO_ACEITE")
        private LocalDateTime dataAceite;

        @PastOrPresent(message = "A data de conclusão não pode estar no futuro.")
        @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
        @Schema(description = "Data de conclusão do atendimento de ajuda", example = "31/05/2025 18:55")
        @Column(name = "DT_MOMENTO_CONCLUSAO")
        private LocalDateTime dataConclusao;

        @Size(max = 500, message = "A observação deve ter no máximo 500 caracteres")
        @Schema(description = "Observação detalhada da ajuda", example = "2 cestas basicas entregues para a família, pedido concluido!")
        @Column(name = "DS_OBSERVACOES")
        private String observacoes;

        @NotNull(message = "campo obrigatório")
        @OneToOne
        @JoinColumn(name = "CD_PEDIDO")
        private PedidoAjuda pedidoAjuda;

        @NotNull(message = "campo obrigatório")
        @ManyToOne
        @JoinColumn(name = "CD_USUARIO")
        private Usuario usuario;
    }
