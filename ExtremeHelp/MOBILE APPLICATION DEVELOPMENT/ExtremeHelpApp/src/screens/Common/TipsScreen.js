import React, { useState, useEffect, useCallback } from 'react';
import { View, StyleSheet, FlatList } from 'react-native';
import * as apiService from '../../services/api';
import LoadingIndicator from '../../../components/LoadingIndicator'; // <<< CAMINHO CORRIGIDO
import CustomButton from '../../../components/CustomButton'; // <<< CAMINHO CORRIGIDO
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import TipCard from '../../../components/TipCard'; // <<< CAMINHO CORRIGIDO
import EmptyState from '../../../components/EmptyState'; // <<< CAMINHO CORRIGIDO
import { parseApiDateString } from '../../utils/helpers';

export default function TipsScreen() {
  const [tips, setTips] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [error, setError] = useState(null);

  const loadTips = useCallback(async () => {
    setIsLoading(true);
    setError(null);
    try {
      const data = await apiService.fetchTips();
      setTips((data || []).sort((a,b) => parseApiDateString(b.dataAtualizacao) - parseApiDateString(a.dataAtualizacao)));
    } catch (err) {
      setError(err.message || "Não foi possível carregar as dicas.");
      setTips([]);
    } finally {
      setIsLoading(false);
    }
  }, []);

  useEffect(() => {
    loadTips();
  }, [loadTips]);

  if (isLoading) {
    return <LoadingIndicator message="Carregando dicas de preparação..." />;
  }

  if (error) {
    return (
      <View style={styles.container}>
        <EmptyState
            icon={<Ionicons name="cloud-offline-outline" size={60} color={APP_COLORS.mediumGray} />}
            title="Erro ao Carregar"
            message={error}
            button={<CustomButton title="Tentar Novamente" onPress={loadTips} />}
        />
      </View>
    );
  }
  
  return (
    <View style={styles.container}>
       {tips.length === 0 ? (
        <EmptyState
            icon={<Ionicons name="book-outline" size={60} color={APP_COLORS.info} />}
            title="Sem Dicas no Momento"
            message="Nenhuma dica de preparação foi cadastrada ainda. Volte mais tarde!"
            button={<CustomButton title="Atualizar" onPress={loadTips} type="SECONDARY"/>}
        />
      ) : (
        <FlatList
          data={tips}
          keyExtractor={(item) => item.id.toString()}
          renderItem={({ item }) => <TipCard item={item} />}
          onRefresh={loadTips}
          refreshing={isLoading}
          contentContainerStyle={styles.listContent}
        />
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, backgroundColor: '#e3f2fd' },
  listContent: {
      paddingHorizontal: 10,
      paddingVertical: 15,
  }
});