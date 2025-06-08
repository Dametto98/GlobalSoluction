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
import jakarta.persistence.SequenceGenerator;
import jakarta.persistence.Table;
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
@Schema(description = "Entidade que representa um alerta no sistema da ExtemeHelp")
@Table(name = "T_EH_ALERTA")
public class Alerta {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "alerta_seq_gen")
    @SequenceGenerator(name = "alerta_seq_gen", sequenceName = "SEQ_EH_ALERTA", allocationSize = 1)
    @Schema(description = "ID único do alerta", example = "1", readOnly = true)
    @Column(name = "CD_ALERTA")
    private Long id;

    @NotBlank(message = "O título é obrigatório")
    @Size(max = 150, message = "O título deve ter no máximo 150 caracteres")
    @Schema(description = "Título do alerta", example = "Alerta de enchente na zona leste", required = true)
    @Column(name = "DS_TITULO")
    private String titulo;

    @NotBlank(message = "A mensagem é obrigatória")
    @Size(max = 2000, message = "A mensagem deve ter no máximo 2000 caracteres")
    @Schema(description = "Mensagem explicando o conteúdo do alerta", example = "As fortes chuvas causaram alagamentos em diversos bairros da zona leste.", required = true)
    @Column(name = "DS_MENSAGEM")
    private String mensagem;

    @NotNull(message = "A data de publicação é obrigatória")
    @PastOrPresent(message = "A data de publicação não pode ser no futuro")
    @JsonFormat(pattern = "dd/MM/yyyy HH:mm")
    @Schema(description = "Data e hora da publicação do alerta", example = "01/05/2025 10:45", required = true)
    @Column(name = "DT_PUBLICACAO")
    private LocalDateTime dataPublicacao;

    @NotNull(message = "O nivel de seriedade do alerta é obrigatório")
    @Enumerated(EnumType.STRING)
    @Schema(description = "Nível de seriedade do alerta", example = "GRAVE", required = true, allowableValues = {"INFORMATIVO", "MODERADO", "GRAVE", "CRITICO"})
    @Column(name = "DS_SERIEDADE")
    private SeriedadeAlerta seriedadeAlerta;

    @Size(max = 100, message = "A fonte deve ter no máximo 100 caracteres")
    @Schema(description = "Fonte da informação do alerta", example = "Defesa Civil de São Paulo")
    @Column(name = "DS_FONTE")
    private String fonte;

    @NotNull(message = "O campo 'ativo' é obrigatório")
    @Schema(description = "Indica se o alerta está ativo ou não", example = "true", required = true)
    @Column(name = "DS_ATIVO")
    private Boolean ativo;
}
