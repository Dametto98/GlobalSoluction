import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';
import { APP_COLORS, HELP_REQUEST_STATUS_API } from '../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import CustomButton from './CustomButton';
import { parseApiDateString } from '../utils/helpers';


export default function RequestCard({ item, onPress, cardType = 'solicitante', showCancelButton = false, onCancelPress }) {
  if (!item) return null;

  const getStatusInfo = (status) => {
    const s = status?.toUpperCase() || '';
    if (s === HELP_REQUEST_STATUS_API.PENDENTE) return { style: styles.statusPendente, text: "Aguardando Voluntário" };
    if (s === HELP_REQUEST_STATUS_API.EM_ATENDIMENTO) return { style: styles.statusAtendimento, text: "Em Atendimento" };
    if (s === HELP_REQUEST_STATUS_API.CONCLUIDO) return { style: styles.statusConcluido, text: "Concluído" };
    if (s === HELP_REQUEST_STATUS_API.CANCELADO) return { style: styles.statusCancelado, text: "Cancelado" };
    return { style: styles.statusDesconhecido, text: status || "Desconhecido" };
  };
  
  const getIconForType = (type) => {
    const t = type?.toLowerCase() || '';
    if (t.includes('aliment')) return "fast-food-outline";
    if (t.includes('abrigo')) return "home-outline";
    if (t.includes('medicamento')) return "medkit-outline";
    if (t.includes('resgate')) return "walk-outline";
    if (t.includes('roupa')) return "shirt-outline";
    return "alert-circle-outline";
  };

  const statusInfo = getStatusInfo(item.statusPedido);
  const cardBorderColor = cardType === 'voluntario' ? APP_COLORS.primaryGreen : APP_COLORS.primarySolicitante;
  const date = parseApiDateString(item.dataPedido);

  return (
    <TouchableOpacity style={[styles.card, { borderLeftColor: cardBorderColor }]} onPress={onPress} disabled={!onPress}>
      <View style={styles.headerRow}>
        <Ionicons name={getIconForType(item.tipoAjuda)} size={24} color={cardBorderColor} style={styles.typeIcon} />
        <Text style={styles.cardTitle}>{item.tipoAjuda || 'Tipo não informado'}</Text>
        <View style={[styles.statusBadge, statusInfo.style]}>
            <Text style={styles.statusText}>{statusInfo.text}</Text>
        </View>
      </View>
      <Text style={styles.cardDescription} numberOfLines={2}>{item.descricão || 'Sem descrição detalhada.'}</Text>
      
      <View style={styles.detailRow}>
        <Ionicons name="location-outline" size={16} color={APP_COLORS.mediumGray} />
        <Text style={styles.detailText} numberOfLines={1}>{item.endereco || 'Localização não informada'}</Text>
      </View>
      
      <View style={styles.detailRow}>
        <Ionicons name="time-outline" size={16} color={APP_COLORS.mediumGray} />
        <Text style={styles.detailText}>{date ? date.toLocaleString('pt-BR', { day: '2-digit', month: 'short', year:'numeric', hour: '2-digit', minute: '2-digit'}) : 'Data indisponível'}</Text>
      </View>

      {showCancelButton && onCancelPress && (
        <CustomButton
            title="Cancelar Pedido"
            onPress={onCancelPress}
            type="DANGER"
            style={{marginTop: 15, paddingVertical: 8, borderRadius:8}}
            textStyle={{fontSize: 14}}
            leftIcon={<Ionicons name="close-circle-outline" size={18} color={APP_COLORS.white}/>}
        />
      )}
    </TouchableOpacity>
  );
}

const styles = StyleSheet.create({
  card: {
    backgroundColor: APP_COLORS.white,
    borderRadius: 12,
    padding: 18,
    marginVertical: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 4,
    elevation: 2,
    borderLeftWidth: 6,
  },
  headerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  typeIcon: { marginRight: 10, },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    color: APP_COLORS.darkGray,
    flex: 1, // Para empurrar o status para a direita
  },
  cardDescription: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
    marginBottom: 15,
    paddingLeft: 5,
  },
  detailRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  detailText: {
    fontSize: 13,
    color: '#555',
    marginLeft: 8,
  },
  statusBadge: {
    borderRadius: 15,
    paddingVertical: 5,
    paddingHorizontal: 10,
  },
  statusText: {
    fontSize: 12,
    color: APP_COLORS.white,
    fontWeight: 'bold',
  },
  statusPendente: { backgroundColor: APP_COLORS.warning },
  statusAtendimento: { backgroundColor: APP_COLORS.info },
  statusConcluido: { backgroundColor: APP_COLORS.success },
  statusCancelado: { backgroundColor: APP_COLORS.danger },
  statusDesconhecido: { backgroundColor: APP_COLORS.mediumGray },
});
