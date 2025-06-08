package br.com.fiap.extremehelp.model;
import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
import jakarta.validation.constraints.DecimalMax;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;
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
@Schema(description = "Entidade que representa um pedido de ajuda no sistema da ExtemeHelp")
@Table(name = "T_EH_PEDIDO_AJUDA")
public class PedidoAjuda {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "pedido_ajuda_seq_gen")
    @SequenceGenerator(name = "pedido_ajuda_seq_gen", sequenceName = "SEQ_EH_PEDIDO_AJUDA", allocationSize = 1)
    @Schema(description = "ID único do pedido de ajuda", example = "1", readOnly = true)
    @Column(name = "CD_PEDIDO")
    private long id;

    @NotBlank   (message = "O tipo de ajuda é obrigatório")
    @Size(min = 5, max = 100, message = "O tipo de ajuda deve ter no mínimo 5 e no máximo 100 caracteres")
    @Schema(description = "Tipo de ajuda solicitada", example = "Alimentação", required = true)
    @Column(name = "DS_TIPO")
    private String tipoAjuda;

    @NotBlank(message = "A descrição é obrigatória")
    @Size(max = 1000, message = "A descrição deve ter no máximo 1000 caracteres")
    @Schema(description = "Descrição detalhada da ajuda", example = "Necessita de cesta básica para família de 4 pessoas", required = true)
    @Column(name = "DS_DESCRICAO")
    private String descricao;

    @NotNull(message = "Latitude é obrigatória")
    @DecimalMin(value = "-90.0", inclusive = true, message = "Latitude mínima é -90")
    @DecimalMax(value = "90.0", inclusive = true, message = "Latitude máxima é 90")
    @Schema(description = "Latitude da localização", example = "-23.550520", required = true)
    @Column(name = "DS_LATITUDE")
    private double latitude;

    @NotNull(message = "Longitude é obrigatória")
    @DecimalMin(value = "-180.0", inclusive = true, message = "Longitude mínima é -180")
    @DecimalMax(value = "180.0", inclusive = true, message = "Longitude máxima é 180")
    @Schema(description = "Longitude da localização", example = "-46.633308", required = true)
    @Column(name = "DS_LONGITUDE")
    private double longitude;

    @Size(max = 300, message = "O endereço deve ter no máximo 300 caracteres")
    @Schema(description = "Endereço da solicitação de ajuda", example = "Rua das Flores, 382, São Paulo, SP")
    @Column(name = "DS_ENDERECO")
    private String endereco;

    @NotNull(message = "A data é obrigatória")
    @PastOrPresent(message = "A data de registro não pode estar no futuro.")
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    @Schema(description = "Data de registro do pedido de ajuda", example = "30/05/2025 09:43", required = true)
    @Column(name = "DT_PEDIDO")
    private LocalDateTime dataPedido;

    @NotNull(message = "O status do pedido é obrigatório.")
    @Enumerated(EnumType.STRING)
    @Schema(description = "Status do pedido de ajuda (ex: PENDENTE, EM_ANDAMENTO, CONCLUIDO, CANCELADO)", example = "PENDENTE", required = true)
    @Column(name = "DS_STATUS")
    private StatusPedido statusPedido;

    @NotNull(message = "campo obrigatório")
    @ManyToOne
    @JoinColumn(name = "CD_USUARIO")
    private Usuario usuario;
}
