package br.com.fiap.extremehelp.dto;

import java.time.LocalDateTime;

import com.fasterxml.jackson.annotation.JsonFormat;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.PastOrPresent;
import jakarta.validation.constraints.Positive;
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
public class AtendimentoVoluntarioRequestDto {
    @Id 
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Schema(description = "ID único do atendimento voluntario de um pedido de ajuda", example = "1", readOnly = true)
    private long id;

    @NotNull(message = "A data é obrigatória")
    @PastOrPresent(message = "A data de aceite não pode estar no futuro.")
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    @Schema(description = "Data de aceite do pedido de ajuda", example = "30/05/2025 10:30", required = true)
    private LocalDateTime dataAceite;

    @PastOrPresent(message = "A data de conclusão não pode estar no futuro.")
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    @Schema(description = "Data de conclusão do atendimento de ajuda", example = "31/05/2025 18:55")
    private LocalDateTime dataConclusao;

    @Size(max = 500, message = "A observação deve ter no máximo 500 caracteres")
    @Schema(description = "Observação detalhada da ajuda", example = "2 cestas basicas entregues para a família, pedido concluido!")
    private String observacoes;

    @NotNull(message = "O ID do pedido de ajuda é obrigatório")
    @Positive(message = "O ID não pode ser zero ou negativo")
    @Schema(description = "ID do pedido de ajuda", example = "1", minimum = "1")
    private Long idPedidoAjuda;

    @NotNull(message = "O ID do usuário é obrigatório")
    @Positive(message = "O ID não pode ser zero ou negativo")
    @Schema(description = "ID do usuário que se voluntariou para atender o pedido", example = "1", minimum = "1")
    private Long idUsuario;
}
