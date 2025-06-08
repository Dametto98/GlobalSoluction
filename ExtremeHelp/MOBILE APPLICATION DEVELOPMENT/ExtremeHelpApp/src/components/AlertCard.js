import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Linking } from 'react-native';
import { APP_COLORS, ALERT_SERIOUSNESS_API } from '../utils/constants';
import { Ionicons } from '@expo/vector-icons';
import { parseApiDateString } from '../utils/helpers';

export default function AlertCard({ item }) {
    if (!item) return null;

    const getSeriousnessStyle = (seriedade) => {
        const s = seriedade?.toUpperCase() || '';
        if (s === ALERT_SERIOUSNESS_API.CRITICO) return { style: styles.seriedadeCritico, icon: 'flash' };
        if (s === ALERT_SERIOUSNESS_API.ALTO) return { style: styles.seriedadeAlto, icon: 'flame' };
        if (s === ALERT_SERIOUSNESS_API.MODERADO) return { style: styles.seriedadeModerado, icon: 'warning' };
        return { style: styles.seriedadeBaixo, icon: 'information-circle' }; // BAIXO ou default
    };
    
    const seriousnessInfo = getSeriousnessStyle(item.seriedadeAlerta);
    const date = parseApiDateString(item.dataPublicacao);

    return (
        <View style={[styles.card, seriousnessInfo.style]}>
            <View style={styles.header}>
                <Ionicons name={seriousnessInfo.icon} size={24} color={APP_COLORS.white} />
                <Text style={styles.title}>{item.titulo || "Alerta"}</Text>
            </View>
            <Text style={styles.message}>{item.mensagem || "Sem detalhes."}</Text>
            <View style={styles.footer}>
                <Text style={styles.footerText}>Fonte: {item.fonte || 'Não informada'}</Text>
                <Text style={styles.footerText}>{date ? date.toLocaleString('pt-BR') : ''}</Text>
            </View>
            {item.sourceUrl && (
                <TouchableOpacity onPress={() => Linking.openURL(item.sourceUrl).catch(err => console.error("Failed to open URL", err))}>
                    <Text style={styles.link}>Ver Fonte Oficial</Text>
                </TouchableOpacity>
            )}
        </View>
    );
};

const styles = StyleSheet.create({
  card: {
    borderRadius: 12,
    padding: 15,
    marginVertical: 8,
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2, },
    shadowOpacity: 0.15,
    shadowRadius: 4,
    elevation: 3,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  title: {
    fontSize: 17,
    fontWeight: 'bold',
    color: APP_COLORS.white,
    marginLeft: 10,
    flex: 1,
  },
  message: {
    fontSize: 15,
    color: APP_COLORS.white,
    lineHeight: 21,
    marginBottom: 12,
  },
  footer: {
      flexDirection: 'row',
      justifyContent: 'space-between',
      borderTopWidth: 1,
      borderTopColor: 'rgba(255,255,255,0.3)',
      paddingTop: 8,
  },
  footerText: {
    fontSize: 12,
    color: 'rgba(255,255,255,0.8)',
  },
  link: {
      fontSize: 14,
      color: APP_COLORS.white,
      marginTop: 10,
      fontWeight: 'bold',
      textDecorationLine: 'underline',
  },
  seriedadeCritico: { backgroundColor: '#c82333' }, // Vermelho mais escuro
  seriedadeAlto: { backgroundColor: '#dc3545' }, // Vermelho perigo
  seriedadeModerado: { backgroundColor: '#ffc107', }, // Amarelo aviso
  seriedadeBaixo: { backgroundColor: '#17a2b8' }, // Azul info
});