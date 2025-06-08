import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { APP_COLORS } from '../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import { parseApiDateString } from '../utils/helpers';

export default function TipCard({ item }) {
    if (!item) return null;
    const date = parseApiDateString(item.dataAtualizacao);

    return (
        <View style={styles.card}>
            <View style={styles.header}>
                <View style={styles.iconContainer}>
                    <Ionicons name="bulb-outline" size={24} color={APP_COLORS.info} />
                </View>
                <View style={styles.headerTextContainer}>
                    <Text style={styles.title}>{item.titulo || "Dica Importante"}</Text>
                    {item.categoria && <Text style={styles.category}>{item.categoria}</Text>}
                </View>
            </View>
            <Text style={styles.content}>{item.conteudo || "Sem conteúdo."}</Text>
            {date && <Text style={styles.date}>Atualizado em: {date.toLocaleDateString('pt-BR')}</Text>}
        </View>
    );
};

const styles = StyleSheet.create({
  card: {
    backgroundColor: APP_COLORS.white,
    borderRadius: 12,
    padding: 18,
    marginVertical: 8,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 1, },
    shadowOpacity: 0.1,
    shadowRadius: 3,
    elevation: 2,
    borderWidth:1,
    borderColor: '#e0e0e0'
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  iconContainer: {
    backgroundColor: 'rgba(23, 162, 184, 0.1)',
    borderRadius: 20,
    width: 40,
    height: 40,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  headerTextContainer: {
      flex: 1,
  },
  title: {
    fontSize: 17,
    fontWeight: 'bold',
    color: APP_COLORS.darkGray,
  },
  category: {
      fontSize: 12,
      color: APP_COLORS.info,
      fontWeight: '600',
  },
  content: {
    fontSize: 15,
    color: '#555',
    lineHeight: 22,
  },
  date: {
      fontSize: 12,
      color: APP_COLORS.mediumGray,
      fontStyle: 'italic',
      textAlign: 'right',
      marginTop: 10,
  }
});
