import React, { useState, useCallback, useContext } from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
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

export default function MyAssignmentsScreen() {
  const navigation = useNavigation();
  const [assignments, setAssignments] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);
  const { userId } = useContext(AuthContext);

  const loadAssignments = useCallback(async () => {
    if (!userId) {
      setError("ID do voluntário não encontrado. Faça login novamente.");
      setIsLoading(false);
      return;
    }
    setIsLoading(true);
    setError(null);
    try {
      const assignmentData = await apiService.fetchMyAssignments(userId);
      const processedAssignments = (assignmentData || []).map(asg => {
          if (!asg.pedidoAjuda) {
              console.warn(`Atendimento ID ${asg.id} não possui detalhes do pedido aninhado.`);
              return null;
          }
          return {
            ...asg.pedidoAjuda,
            atendimentoId: asg.id,
            dataAceite: asg.dataAceite,
          };
      }).filter(Boolean);

      setAssignments(processedAssignments.sort((a,b) => parseApiDateString(b.dataAceite) - parseApiDateString(a.dataAceite)));
    } catch (err) {
      setError(err.message || "Não foi possível carregar seus atendimentos.");
      setAssignments([]);
    } finally {
      setIsLoading(false);
    }
  }, [userId]);

  useFocusEffect(
    useCallback(() => {
      loadAssignments();
    }, [loadAssignments])
  );

  if (isLoading) {
    return <LoadingIndicator message="Carregando seus atendimentos..." />;
  }

  if (error) {
    return (
      <View style={styles.container}>
        <EmptyState
            icon={<Ionicons name="cloud-offline-outline" size={60} color={APP_COLORS.mediumGray} />}
            title="Erro ao Carregar"
            message={error}
            button={<CustomButton title="Tentar Novamente" onPress={loadAssignments} type="PRIMARY_GREEN" />}
        />
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {assignments.length === 0 ? (
        <EmptyState
            icon={<Ionicons name="heart-dislike-outline" size={60} color={APP_COLORS.primaryGreen} />}
            title="Nenhum Atendimento"
            message="Você ainda não aceitou nenhum pedido de ajuda."
            button={<CustomButton title="Ver Pedidos Disponíveis" onPress={() => navigation.navigate('VerPedidosVoluntarioTab')} type="PRIMARY_GREEN"/>}
        />
      ) : (
        <FlatList
          data={assignments}
          keyExtractor={(item) => item.atendimentoId.toString()}
          renderItem={({ item }) => (
            <RequestCard 
                item={item} 
                onPress={() => navigation.navigate('RequestDetail', { requestId: item.id })}
                cardType="voluntario"
            />
          )}
          onRefresh={loadAssignments}
          refreshing={isLoading}
          contentContainerStyle={{ paddingHorizontal: 10, paddingTop: 10, paddingBottom: 20 }}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: APP_COLORS.lightGreen },
});