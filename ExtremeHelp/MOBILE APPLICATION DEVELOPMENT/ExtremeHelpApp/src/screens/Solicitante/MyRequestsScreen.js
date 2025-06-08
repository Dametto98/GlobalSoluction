import React, { useState, useCallback, useContext } from 'react';
import { View, StyleSheet, FlatList, Alert } from 'react-native';
import { useFocusEffect, useNavigation } from '@react-navigation/native';
import * as apiService from '../../services/api';
import { AuthContext } from '../../contexts/AuthContext';
import RequestCard from '../../../components/RequestCard'; // <<< CAMINHO CORRIGIDO
import LoadingIndicator from '../../../components/LoadingIndicator'; // <<< CAMINHO CORRIGIDO
import CustomButton from '../../../components/CustomButton'; // <<< CAMINHO CORRIGIDO
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import EmptyState from '../../../components/EmptyState'; // <<< CAMINHO CORRIGIDO
import { parseApiDateString } from '../../utils/helpers';

export default function MyRequestsScreen() {
  const navigation = useNavigation();
  const [myRequests, setMyRequests] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { userId } = useContext(AuthContext);

  const loadMyRequests = useCallback(async () => {
    if (!userId) {
      setError("ID do usuário não encontrado. Faça login novamente.");
      setIsLoading(false);
      return;
    }
    setIsLoading(true);
    setError(null);
    try {
      const data = await apiService.fetchMyHelpRequests(userId);
      const sortedData = (data || []).sort((a, b) => {
        const dateA = parseApiDateString(a.dataPedido);
        const dateB = parseApiDateString(b.dataPedido);
        if (!dateA) return 1;
        if (!dateB) return -1;
        return dateB - dateA;
      });
      setMyRequests(sortedData);
    } catch (err) {
      setError(err.message || "Não foi possível carregar seus pedidos de ajuda.");
      setMyRequests([]);
    } finally {
      setIsLoading(false);
    }
  }, [userId]);

  useFocusEffect(
    useCallback(() => {
      loadMyRequests();
    }, [loadMyRequests])
  );

  const handleCancelRequest = async (requestId) => {
    Alert.alert(
      "Cancelar Pedido",
      "Você tem certeza que deseja cancelar este pedido de ajuda?",
      [
        { text: "Não, manter", style: "cancel" },
        { 
          text: "Sim, cancelar", 
          style: "destructive",
          onPress: async () => {
            setIsLoading(true);
            try {
              await apiService.updateHelpRequest(requestId, { statusPedido: "CANCELADO" });
              Alert.alert("Sucesso", "Seu pedido foi cancelado.");
              loadMyRequests();
            } catch (err) {
              Alert.alert("Erro", err.message || "Não foi possível cancelar o pedido.");
              setIsLoading(false);
            }
          }
        }
      ]
    );
  };

  if (isLoading) {
    return <LoadingIndicator message="Carregando seus pedidos..." />;
  }

  if (error) {
    return (
      <View style={styles.container}>
        <EmptyState
            icon={<Ionicons name="cloud-offline-outline" size={60} color={APP_COLORS.mediumGray} />}
            title="Erro ao Carregar"
            message={error}
            button={<CustomButton title="Tentar Novamente" onPress={loadMyRequests} />}
        />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {myRequests.length === 0 ? (
        <EmptyState
            icon={<Ionicons name="file-tray-outline" size={60} color={APP_COLORS.primarySolicitante} />}
            title="Nenhum Pedido Encontrado"
            message="Você ainda não fez nenhum pedido de ajuda."
            button={<CustomButton title="Pedir Ajuda Agora" onPress={() => navigation.navigate('CriarPedidoTab')} />}
        />
      ) : (
        <FlatList
          data={myRequests}
          keyExtractor={(item) => item.id.toString()}
          renderItem={({ item }) => (
            <RequestCard 
                item={item} 
                onPress={() => navigation.navigate('RequestDetail', { requestId: item.id })}
                cardType="solicitante"
                showCancelButton={item.statusPedido === 'PENDENTE'}
                onCancelPress={() => handleCancelRequest(item.id)}
            />
          )}
          onRefresh={loadMyRequests}
          refreshing={isLoading}
          contentContainerStyle={{ paddingHorizontal: 10, paddingTop: 10, paddingBottom: 20 }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: APP_COLORS.lightBlue },
});