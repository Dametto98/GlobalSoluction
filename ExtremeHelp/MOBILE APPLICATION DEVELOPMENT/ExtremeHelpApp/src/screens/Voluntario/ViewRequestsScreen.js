import React, { useState, useCallback, useContext } from 'react';
import { View, Text, StyleSheet, FlatList, RefreshControl, Alert, TouchableOpacity } from 'react-native';
import { useFocusEffect, useNavigation } from '@react-navigation/native';
import * as apiService from '../../services/api';
import { AuthContext } from '../../contexts/AuthContext';
import RequestCard from '../../components/RequestCard';
import LoadingIndicator from '../../components/LoadingIndicator';
import CustomButton from '../../components/CustomButton';
import { APP_COLORS, USER_TYPES, HELP_REQUEST_STATUS_API } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';

export default function ViewRequestsScreen() {
  const navigation = useNavigation();
  const [requests, setRequests] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const [refreshing, setRefreshing] = useState(false);
  const { userType, userId } = useContext(AuthContext);

  const loadRequests = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      // Idealmente, a API deveria filtrar pedidos que ainda não foram atendidos ou que são relevantes.
      // Ex: status=PENDENTE ou status=AGUARDANDO_VOLUNTARIO
      // No Insomnia, GET /pedido-ajuda não mostra filtros.
      // Se for USER_TYPES.ADMIN, pode querer ver todos.
      let filters = { statusPedido: HELP_REQUEST_STATUS_API.PENDENTE }; // Filtro padrão para voluntários
      if (userType === USER_TYPES.ADMIN) {
          filters = {}; // Admin vê todos os status
      }

      const data = await apiService.fetchHelpRequests(filters);
      // Filtrar para não mostrar pedidos do próprio voluntário, se ele também for solicitante
      const filteredData = userType === USER_TYPES.VOLUNTARIO 
                           ? (data || []).filter(req => req.idUsuario !== parseInt(userId, 10))
                           : (data || []);
      setRequests(filteredData);
    } catch (err) {
      console.error("Erro ao buscar pedidos de ajuda:", err);
      setError(err.message || "Não foi possível carregar os pedidos de ajuda disponíveis.");
      setRequests([]);
    } finally {
      setIsLoading(false);
      setRefreshing(false);
    }
  }, [userType, userId]);

  useFocusEffect(
    useCallback(() => {
      loadRequests();
    }, [loadRequests])
  );

  const onRefresh = useCallback(() => {
    setRefreshing(true);
    loadRequests();
  }, [loadRequests]);

  const renderRequestItem = ({ item }) => (
    <RequestCard
      item={item} // A API retorna 'descricão', 'tipoAjuda', 'statusPedido', etc. O Card precisa mapear.
      onPress={() => navigation.navigate('RequestDetail', { 
          requestId: item.id,
          // Passar mais dados para evitar recarregar na tela de detalhe, se desejado
          // requestDetails: item 
      })}
      cardType={userType === USER_TYPES.VOLUNTARIO || userType === USER_TYPES.ADMIN ? 'voluntario' : 'solicitante'}
    />
  );

  if (isLoading && !refreshing) {
    return <LoadingIndicator message="Buscando pedidos de ajuda..." />;
  }

  if (error) {
    return (
      <View style={styles.centered}>
        <Ionicons name="cloud-offline-outline" size={60} color={APP_COLORS.mediumGray} />
        <Text style={styles.errorText}>Erro ao carregar: {error}</Text>
        <CustomButton title="Tentar Novamente" onPress={loadRequests} type="PRIMARY_GREEN" />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {requests.length === 0 ? (
        <View style={styles.centered}>
          <Ionicons name="leaf-outline" size={60} color={APP_COLORS.primaryGreen} />
          <Text style={styles.emptyText}>
            {userType === USER_TYPES.ADMIN ? "Nenhum pedido de ajuda encontrado com os filtros atuais." : "Nenhum pedido de ajuda disponível no momento. Obrigado por sua disposição!"}
          </Text>
          <CustomButton title="Atualizar Lista" onPress={onRefresh} type="SECONDARY" />
        </View>
      ) : (
        <FlatList
          data={requests}
          keyExtractor={(item) => item.id.toString()}
          renderItem={renderRequestItem}
          refreshControl={<RefreshControl refreshing={refreshing} onRefresh={onRefresh} colors={[APP_COLORS.primaryVoluntario]} tintColor={APP_COLORS.primaryVoluntario} />}
          contentContainerStyle={{ paddingBottom: 20 }}
          // ListHeaderComponent={
          //   <Text style={styles.listHeader}>
          //       {userType === USER_TYPES.ADMIN ? "Todos os Pedidos Registrados" : "Pedidos Aguardando Voluntários"}
          //   </Text>
          // }
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: APP_COLORS.lightGreen, paddingHorizontal:10, paddingTop:10 },
  centered: { flex: 1, justifyContent: 'center', alignItems: 'center', padding: 20, },
  // listHeader: { fontSize: 18, fontWeight: '600', marginBottom: 10, textAlign: 'center', color: APP_COLORS.primaryVoluntario },
  emptyText: { fontSize: 16, color: APP_COLORS.darkGray, textAlign: 'center', marginBottom: 20, lineHeight:22, },
  errorText: { color: APP_COLORS.danger, fontSize: 16, textAlign: 'center', marginBottom: 15, },
});