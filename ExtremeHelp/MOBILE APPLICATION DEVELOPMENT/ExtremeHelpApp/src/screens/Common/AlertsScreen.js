import React, { useState, useEffect, useCallback } from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import * as apiService from '../../services/api';
import LoadingIndicator from '../../../components/LoadingIndicator'; // <<< CAMINHO CORRIGIDO
import CustomButton from '../../../components/CustomButton'; // <<< CAMINHO CORRIGIDO
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import AlertCard from '../../../components/AlertCard'; // <<< CAMINHO CORRIGIDO
import EmptyState from '../../../components/EmptyState'; // <<< CAMINHO CORRIGIDO
import { parseApiDateString } from '../../utils/helpers';

export default function AlertsScreen() {
  const [alerts, setAlerts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadAlerts = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await apiService.fetchAlerts();
      setAlerts((data || []).filter(a => a.ativo).sort((a,b) => parseApiDateString(b.dataPublicacao) - parseApiDateString(a.dataPublicacao)));
    } catch (err) {
      setError(err.message || "Não foi possível carregar os alertas.");
      setAlerts([]);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadAlerts();
  }, [loadAlerts]);

  if (isLoading) {
    return <LoadingIndicator message="Carregando alertas importantes..." />;
  }

  if (error) {
    return (
      <View style={styles.container}>
        <EmptyState
            icon={<Ionicons name="cloud-offline-outline" size={60} color={APP_COLORS.mediumGray} />}
            title="Erro ao Carregar"
            message={error}
            button={<CustomButton title="Tentar Novamente" onPress={loadAlerts} />}
        />
      </View>
    );
  }
  
  return (
    <View style={styles.container}>
      {alerts.length === 0 ? (
        <EmptyState
            icon={<Ionicons name="shield-checkmark-outline" size={60} color={APP_COLORS.primaryGreen} />}
            title="Tudo Tranquilo"
            message="Nenhum alerta ativo no momento."
            button={<CustomButton title="Atualizar" onPress={loadAlerts} type="SECONDARY"/>}
        />
      ) : (
        <FlatList
          data={alerts}
          keyExtractor={(item) => item.id.toString()}
          renderItem={({ item }) => <AlertCard item={item} />}
          onRefresh={loadAlerts}
          refreshing={isLoading}
          contentContainerStyle={styles.listContent}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#fff9e6' },
  listContent: {
      paddingHorizontal: 10,
      paddingVertical: 15,
  }
});