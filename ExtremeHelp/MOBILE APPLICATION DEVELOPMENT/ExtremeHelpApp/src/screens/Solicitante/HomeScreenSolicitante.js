import React, { useContext } from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, TouchableOpacity } from 'react-native';
import CustomButton from '../../../components/EmptyState';
import { AuthContext } from '../../contexts/AuthContext';
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';

export default function HomeScreenSolicitante({ navigation }) {
  const { logout, userName } = useContext(AuthContext);

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.headerContainer}>
          <Ionicons name="person-circle-outline" size={80} color={APP_COLORS.accentSolicitante} />
          <Text style={styles.greeting}>Olá, {userName || 'Usuário'}!</Text>
          <Text style={styles.subGreeting}>Estamos aqui para ajudar. O que você precisa hoje?</Text>
        </View>
        
        <View style={styles.actionsContainer}>
          <CustomButton
            title="Fazer um Novo Pedido"
            onPress={() => navigation.navigate('CriarPedidoTab')}
            style={styles.actionButton}
            leftIcon={<Ionicons name="add-circle-outline" size={24} color={APP_COLORS.white} />}
          />
          <CustomButton
            title="Acompanhar Meus Pedidos"
            onPress={() => navigation.navigate('MeusPedidosTab')}
            style={styles.actionButton}
            type="SECONDARY"
            leftIcon={<Ionicons name="list-outline" size={24} color={APP_COLORS.primarySolicitante} />}
          />
        </View>

        <View style={styles.infoSection}>
            <TouchableOpacity style={styles.infoCard} onPress={() => navigation.navigate('AlertasSolicitanteTab')}>
                <Ionicons name="notifications-outline" size={30} color={APP_COLORS.warning} />
                <Text style={styles.infoCardTitle}>Alertas Recentes</Text>
                <Text style={styles.infoCardText}>Veja os últimos avisos de segurança.</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.infoCard} onPress={() => navigation.navigate('DicasSolicitanteTab')}>
                <Ionicons name="bulb-outline" size={30} color={APP_COLORS.success} />
                <Text style={styles.infoCardTitle}>Dicas de Preparação</Text>
                <Text style={styles.infoCardText}>Saiba como se proteger em emergências.</Text>
            </TouchableOpacity>
        </View>
        
        <CustomButton 
            title="Sair do App" 
            onPress={logout} 
            type="DANGER" 
            style={styles.logoutButton}
            leftIcon={<Ionicons name="log-out-outline" size={22} color={APP_COLORS.white} />}
        />
      </ScrollView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  safeArea: { flex: 1, backgroundColor: APP_COLORS.lightBlue, },
  scrollContainer: { flexGrow: 1, paddingVertical: 20, paddingHorizontal: 20, },
  headerContainer: { alignItems: 'center', marginBottom: 30, paddingTop: 20, },
  greeting: { fontSize: 26, fontWeight: 'bold', color: APP_COLORS.accentSolicitante, marginTop: 10, },
  subGreeting: { fontSize: 16, color: APP_COLORS.primarySolicitante, marginTop: 5, textAlign: 'center', },
  actionsContainer: { marginBottom: 30, },
  actionButton: { marginVertical: 10, paddingVertical: 15, },
  infoSection: { flexDirection: 'row', justifyContent: 'space-between', marginBottom: 30, },
  infoCard: {
    backgroundColor: APP_COLORS.white,
    borderRadius: 10,
    padding: 15,
    width: '48%',
    alignItems: 'center',
    shadowColor: "#000",
    shadowOffset: { width: 0, height: 2, },
    shadowOpacity: 0.1,
    shadowRadius: 3.84,
    elevation: 3,
  },
  infoCardTitle: { fontSize: 15, fontWeight: 'bold', color: APP_COLORS.darkGray, marginTop: 8, textAlign: 'center', },
  infoCardText: { fontSize: 13, color: '#666', textAlign: 'center', marginTop: 4, },
  logoutButton: { marginTop: 20, }
});


