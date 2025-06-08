import React, { useContext } from 'react';
import { View, Text, StyleSheet, ScrollView, SafeAreaView, TouchableOpacity } from 'react-native';
import CustomButton from '../../components/CustomButton';
import { AuthContext } from '../../contexts/AuthContext';
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';

export default function HomeScreenVoluntario({ navigation }) {
  const { logout, userName } = useContext(AuthContext);

  return (
    <SafeAreaView style={styles.safeArea}>
      <ScrollView contentContainerStyle={styles.scrollContainer}>
        <View style={styles.headerContainer}>
          <Ionicons name="heart-circle-outline" size={80} color={APP_COLORS.accentVoluntario} />
          <Text style={styles.greeting}>Olá, {userName || 'Voluntário'}!</Text>
          <Text style={styles.subGreeting}>Obrigado por sua disposição em ajudar.</Text>
        </View>
        
        <View style={styles.actionsContainer}>
          <CustomButton
            title="Ver Pedidos de Ajuda"
            onPress={() => navigation.navigate('VerPedidosVoluntarioTab')}
            style={styles.actionButton}
            type="PRIMARY_GREEN"
            leftIcon={<Ionicons name="search-outline" size={24} color={APP_COLORS.white} />}
          />
          {/* CÓDIGO CORRIGIDO ABAIXO */}
          <CustomButton
            title="Meus Atendimentos"
            onPress={() => navigation.navigate('MeusAtendimentosVoluntarioTab')}
            type="SECONDARY"
            textStyle={{color: APP_COLORS.primaryGreen}}
            // As duas propriedades 'style' foram combinadas em um array:
            style={[styles.actionButton, {borderColor: APP_COLORS.primaryGreen}]}
            leftIcon={<Ionicons name="checkbox-outline" size={24} color={APP_COLORS.primaryGreen} />}
          />
        </View>

        <View style={styles.infoSection}>
            <TouchableOpacity style={styles.infoCard} onPress={() => navigation.navigate('AlertasVoluntarioTab')}>
                <Ionicons name="notifications-outline" size={30} color={APP_COLORS.warning} />
                <Text style={styles.infoCardTitle}>Alertas Recentes</Text>
                <Text style={styles.infoCardText}>Fique por dentro dos últimos avisos.</Text>
            </TouchableOpacity>
            <TouchableOpacity style={styles.infoCard} onPress={() => navigation.navigate('DicasVoluntarioTab')}>
                <Ionicons name="bulb-outline" size={30} color={APP_COLORS.info} />
                <Text style={styles.infoCardTitle}>Dicas para Voluntários</Text>
                <Text style={styles.infoCardText}>Informações importantes para sua atuação.</Text>
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
  safeArea: { flex: 1, backgroundColor: APP_COLORS.lightGreen, },
  scrollContainer: { flexGrow: 1, paddingVertical: 20, paddingHorizontal: 20, },
  headerContainer: { alignItems: 'center', marginBottom: 30, paddingTop: 20, },
  greeting: { fontSize: 26, fontWeight: 'bold', color: APP_COLORS.accentVoluntario, marginTop: 10, },
  subGreeting: { fontSize: 16, color: APP_COLORS.primaryVoluntario, marginTop: 5, textAlign: 'center', },
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
