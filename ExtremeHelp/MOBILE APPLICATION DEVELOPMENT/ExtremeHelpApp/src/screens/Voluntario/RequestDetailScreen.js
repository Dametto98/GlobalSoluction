import React, { useState, useEffect, useCallback, useContext } from 'react';
import { View, Text, StyleSheet, ScrollView, Alert, TouchableOpacity, Linking } from 'react-native';
import * as apiService from '../../services/api';
import CustomButton from '../../components/CustomButton';
import LoadingIndicator from '../../components/LoadingIndicator';
import { AuthContext } from '../../contexts/AuthContext';
import { APP_COLORS, USER_TYPES, HELP_REQUEST_STATUS_API } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import { formatDateToAPI, parseApiDateString } from '../../utils/helpers'; // Para exibir data

export default function RequestDetailScreen({ route, navigation }) {
  const { requestId } = route.params;
  const [request, setRequest] = useState(null); // API: PedidoAjuda
  const [isLoading, setIsLoading] = useState(true);
  const [isAccepting, setIsAccepting] = useState(false);
  const [error, setError] = useState(null);
  const { userId, userType, userName } = useContext(AuthContext);

  const loadRequestDetails = useCallback(async () => {
    if (!requestId) {
        setError("ID do pedido inválido.");
        setIsLoading(false);
        return;
    }
    setIsLoading(true);
    setError(null);
    try {
      const data = await apiService.fetchHelpRequestById(requestId);
      setRequest(data);
    } catch (err) {
      console.error("Erro ao buscar detalhes do pedido:", err);
      setError(err.message || "Não foi possível carregar os detalhes do pedido.");
    } finally {
      setIsLoading(false);
    }
  }, [requestId]);

  useEffect(() => {
    loadRequestDetails();
  }, [loadRequestDetails]);

  const handleAcceptRequest = async () => {
    if (!request || !userId) {
        Alert.alert("Erro", "Dados insuficientes para aceitar o pedido.");
        return;
    }
    // Um voluntário não deve aceitar o próprio pedido (se a lógica permitir que um voluntário também seja solicitante)
    if (request.idUsuario === parseInt(userId, 10)) { 
        Alert.alert("Ação Inválida", "Você não pode aceitar seu próprio pedido de ajuda.");
        return;
    }

    Alert.alert(
      "Confirmar Atendimento",
      `Você, ${userName}, confirma que deseja se voluntariar para atender ao pedido de "${request.tipoAjuda}"?`,
      [
        { text: "Cancelar", style: "cancel" },
        { 
          text: "Sim, Quero Ajudar!", 
          style: "default",
          onPress: async () => {
            setIsAccepting(true);
            try {
              // O serviço apiService.acceptHelpRequestAssignment já formata a dataAceite
              await apiService.acceptHelpRequestAssignment(request.id, userId);
              
              Alert.alert("Atendimento Iniciado!", "Você aceitou este pedido. O solicitante será notificado (se aplicável). Por favor, proceda com o atendimento.");
              
              // Atualizar o status do pedido localmente para feedback imediato (opcional)
              // setRequest(prev => ({ ...prev, statusPedido: HELP_REQUEST_STATUS_API.EM_ATENDIMENTO, volunteerId: userId }));
              
              // Navegar para "Meus Atendimentos" ou voltar para a lista
              navigation.replace('MeusAtendimentosVoluntarioTab'); // Usar replace para não poder voltar para este detalhe
            } catch (err) {
              console.error("Erro ao aceitar pedido:", err)
              Alert.alert("Erro ao Aceitar", err.message || "Não foi possível registrar seu atendimento para este pedido. Tente novamente.");
            } finally {
              setIsAccepting(false);
            }
          }
        }
      ],
      { cancelable: true }
    );
  };

  const openMaps = () => {
    if (request?.latitude && request?.longitude) {
        const scheme = Platform.OS === 'ios' ? 'maps:' : 'geo:';
        const latLng = `${request.latitude},${request.longitude}`;
        const label = request.endereco || 'Local do Pedido';
        const url = Platform.OS === 'ios' ? `${scheme}0,0?q=${label}@${latLng}` : `${scheme}${latLng}?q=${label}`;
        Linking.openURL(url).catch(err => Alert.alert("Erro ao Abrir Mapa", "Não foi possível abrir o aplicativo de mapas."));
    } else if (request?.endereco) {
        Linking.openURL(`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(request.endereco)}`)
            .catch(err => Alert.alert("Erro ao Abrir Mapa", "Não foi possível abrir o aplicativo de mapas."));
    } else {
        Alert.alert("Localização Indisponível", "Não há informações de localização para abrir no mapa.");
    }
  };


  if (isLoading) {
    return <LoadingIndicator message="Carregando detalhes do pedido..." />;
  }

  if (error) {
    return (
      <View style={styles.centeredMessage}>
        <Ionicons name="alert-circle-outline" size={50} color={APP_COLORS.danger} />
        <Text style={styles.errorText}>Erro: {error}</Text>
        <CustomButton title="Tentar Novamente" onPress={loadRequestDetails} type="PRIMARY_GREEN" />
      </View>
    );
  }

  if (!request) {
    return (
      <View style={styles.centeredMessage}>
        <Ionicons name="search-outline" size={50} color={APP_COLORS.mediumGray} />
        <Text style={styles.infoText}>Pedido não encontrado ou indisponível.</Text>
      </View>
    );
  }

  // Voluntário/Admin só pode aceitar se estiver PENDENTE
  const canAccept = (userType === USER_TYPES.VOLUNTARIO || userType === USER_TYPES.ADMIN) && 
                    request.statusPedido === HELP_REQUEST_STATUS_API.PENDENTE &&
                    request.idUsuario !== parseInt(userId, 10); // Não pode aceitar o próprio pedido

  const isMyOwnRequest = userType === USER_TYPES.SOLICITANTE && request.idUsuario === parseInt(userId, 10);


  return (
    <ScrollView style={styles.container} contentContainerStyle={styles.contentScroll}>
      <View style={styles.card}>
        <View style={styles.headerSection}>
            <Ionicons name="document-text-outline" size={30} color={APP_COLORS.primaryVoluntario} />
            <Text style={styles.mainTitle}>{request.tipoAjuda || "Detalhes do Pedido"}</Text>
        </View>

        <View style={styles.detailRow}>
          <Ionicons name="information-circle-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
          <Text style={styles.label}>Descrição:</Text>
          <Text style={styles.value}>{request.descricão}</Text>
        </View>

        <View style={styles.detailRow}>
          <Ionicons name="location-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
          <Text style={styles.label}>Endereço:</Text>
          <Text style={styles.value}>{request.endereco || "Não informado"}</Text>
        </View>
        
        {(request.latitude && request.longitude && request.latitude !== 0 && request.longitude !== 0) && (
            <View style={styles.detailRow}>
                <Ionicons name="map-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
                <Text style={styles.label}>Coordenadas:</Text>
                <Text style={styles.value}>Lat: {request.latitude.toFixed(5)}, Lon: {request.longitude.toFixed(5)}</Text>
                <TouchableOpacity onPress={openMaps} style={styles.mapLink}>
                    <Text style={styles.mapLinkText}>Ver no Mapa</Text>
                </TouchableOpacity>
            </View>
        )}

        <View style={styles.detailRow}>
          <Ionicons name="calendar-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
          <Text style={styles.label}>Data do Pedido:</Text>
          <Text style={styles.value}>{request.dataPedido ? parseApiDateString(request.dataPedido)?.toLocaleString('pt-BR') : "Não informada"}</Text>
        </View>

        <View style={styles.detailRow}>
          <Ionicons name="flag-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
          <Text style={styles.label}>Status Atual:</Text>
          <Text style={[styles.value, styles.statusValue, request.statusPedido && styles[`status${request.statusPedido.replace(/\s+/g, '')}`]]}>
            {request.statusPedido || "Desconhecido"}
          </Text>
        </View>

        {/* Adicionar informações do solicitante se a API fornecer e for pertinente (cuidado com privacidade) */}
        {/* {request.usuario && (
            <View style={styles.detailRow}>
                <Ionicons name="person-outline" size={20} color={APP_COLORS.darkGray} style={styles.icon} />
                <Text style={styles.label}>Solicitante:</Text>
                <Text style={styles.value}>{request.usuario.nome || "Não informado"}</Text>
            </View>
        )} */}
      </View>

      {canAccept && (
        <CustomButton
          title="Aceitar e Iniciar Atendimento"
          onPress={handleAcceptRequest}
          isLoading={isAccepting}
          disabled={isAccepting}
          style={{ marginHorizontal:15, marginTop: 20, marginBottom:30 }}
          type="PRIMARY_GREEN"
          leftIcon={<Ionicons name="checkmark-circle-outline" size={22} color={APP_COLORS.white} />}
        />
      )}

      {isMyOwnRequest && request.statusPedido === HELP_REQUEST_STATUS_API.PENDENTE && (
        <CustomButton
            title="Cancelar Meu Pedido"
            // onPress={handleCancelMyRequest} // Implementar esta função em apiService e aqui
            type="DANGER"
            style={{ marginHorizontal:15, marginTop: 20, marginBottom:30 }}
            leftIcon={<Ionicons name="close-circle-outline" size={22} color={APP_COLORS.white} />}
        />
      )}
      
      {request.statusPedido !== HELP_REQUEST_STATUS_API.PENDENTE && !isMyOwnRequest && !canAccept && (
        <Text style={styles.infoStatusText}>
            {request.statusPedido === HELP_REQUEST_STATUS_API.EM_ATENDIMENTO ? "Este pedido já está sendo atendido por outro voluntário." :
             request.statusPedido === HELP_REQUEST_STATUS_API.CONCLUIDO ? "Este pedido já foi concluído." :
             request.statusPedido === HELP_REQUEST_STATUS_API.CANCELADO ? "Este pedido foi cancelado pelo solicitante." :
             "Este pedido não está mais disponível para atendimento."}
        </Text>
      )}

    </ScrollView>
  );
}

// Estilos de RequestDetailScreen (mantidos e adaptados)
const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: APP_COLORS.lightGray, },
  contentScroll: { paddingBottom: 30, paddingTop:15 },
  card: {
    backgroundColor: APP_COLORS.white,
    borderRadius: 12,
    marginHorizontal: 15,
    padding: 20,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2, },
    shadowOpacity: 0.1,
    shadowRadius: 4,
    elevation: 3,
  },
  headerSection: {
    flexDirection: 'row',
    alignItems: 'center',
    borderBottomWidth: 1,
    borderBottomColor: APP_COLORS.lightGray,
    paddingBottom: 15,
    marginBottom: 15,
  },
  mainTitle: { 
    fontSize: 22, 
    fontWeight: 'bold', 
    color: APP_COLORS.primaryVoluntario, 
    marginLeft: 10,
    flexShrink: 1, // Para quebrar linha se for muito grande
  },
  detailRow: { 
    flexDirection: 'row', 
    marginBottom: 12, 
    alignItems: 'flex-start', // Para textos longos
  },
  icon: { 
    marginRight: 10, 
    marginTop: 2, // Alinhar melhor com o texto
    color: APP_COLORS.mediumGray,
  },
  label: { 
    fontSize: 15, 
    fontWeight: '600', 
    color: APP_COLORS.darkGray,
    width: 90, // Para alinhar os valores
  },
  value: { 
    fontSize: 15, 
    color: APP_COLORS.darkGray, 
    flex: 1, // Para quebrar linha se necessário
    lineHeight: 20,
  },
  statusValue: {
    fontWeight: 'bold',
  },
  mapLink: { marginLeft: 10, paddingVertical: 2, },
  mapLinkText: { color: APP_COLORS.primary, textDecorationLine: 'underline', fontSize: 14 },
  centeredMessage: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20, backgroundColor: APP_COLORS.lightGray },
  errorText: { color: APP_COLORS.danger, fontSize: 16, textAlign: 'center', marginBottom: 15, lineHeight:22, },
  infoText: { fontSize: 16, color: APP_COLORS.mediumGray, textAlign: 'center', paddingHorizontal:20, lineHeight:22, },
  infoStatusText: { 
      fontSize: 15, 
      color: APP_COLORS.info, 
      textAlign: 'center', 
      marginTop: 20, 
      fontStyle: 'italic', 
      paddingHorizontal: 20, 
      lineHeight:21,
  },
  // Estilos para status (exemplo, corresponder aos valores da API)
  statusPENDENTE: { color: APP_COLORS.warning, backgroundColor: '#fff8e1', paddingHorizontal:8, paddingVertical:3, borderRadius:5, alignSelf:'flex-start' },
  statusEM_ATENDIMENTO: { color: APP_COLORS.info, backgroundColor: '#e0f7fa', paddingHorizontal:8, paddingVertical:3, borderRadius:5, alignSelf:'flex-start' },
  statusCONCLUIDO: { color: APP_COLORS.success, backgroundColor: '#e8f5e9', paddingHorizontal:8, paddingVertical:3, borderRadius:5, alignSelf:'flex-start' },
  statusCANCELADO: { color: APP_COLORS.danger, backgroundColor: '#ffebee', paddingHorizontal:8, paddingVertical:3, borderRadius:5, alignSelf:'flex-start' },
});