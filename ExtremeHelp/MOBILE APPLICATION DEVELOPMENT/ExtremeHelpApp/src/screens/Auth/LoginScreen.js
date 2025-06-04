// ====================================================================================
// Arquivo: src/screens/Auth/LoginScreen.js
// ====================================================================================
import React, { useState, useContext } from 'react';
import { View, Text, StyleSheet, Alert, KeyboardAvoidingView, Platform, ScrollView } from 'react-native';
import { AuthContext } from '../../contexts/AuthContext';
import CustomInput from '../../components/CustomInput';
import CustomButton from '../../components/CustomButton';
import LoadingIndicator from '../../components/LoadingIndicator';
import { APP_COLORS } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';

export default function LoginScreen({ navigation }) {
  const [email, setEmail] = useState(''); // Ex: p.barbosa@mottomap.com (ADMIN) ou gustavo@mottomap.com (VOLUNTARIO)
  const [password, setPassword] = useState(''); // Ex: barbosa12345 ou gustavo12345
  const { login, isLoadingAuth } = useContext(AuthContext); // isLoadingAuth do context
  const [isLoggingIn, setIsLoggingIn] = useState(false); // Loading local da tela
  const [showPassword, setShowPassword] = useState(false);

  const handleLogin = async () => {
    if (!email.trim() || !password) {
      Alert.alert("Atenção", "Por favor, preencha seu e-mail e senha.");
      return;
    }
    setIsLoggingIn(true);
    try {
      await login(email, password); // Chama a função login do AuthContext
      // A navegação será tratada pelo AppNavigator ao detectar userToken no AuthContext
    } catch (error) {
      // A mensagem de erro já vem tratada do AuthContext/apiService
      Alert.alert("Erro no Login", error.message || "Não foi possível fazer login. Verifique suas credenciais.");
    } finally {
      setIsLoggingIn(false);
    }
  };

  // Se o context ainda estiver carregando dados do AsyncStorage, mostrar loading
  if (isLoadingAuth) {
    return <LoadingIndicator message="Inicializando..."/>;
  }
  // Se esta tela estiver processando o login, mostrar loading específico
  if (isLoggingIn) {
    return <LoadingIndicator message="Autenticando sua conta..."/>;
  }

  return (
    <KeyboardAvoidingView 
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        style={styles.keyboardView}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer} keyboardShouldPersistTaps="handled">
        <View style={styles.container}>
          <Ionicons name="shield-checkmark-outline" size={80} color={APP_COLORS.primary} style={styles.logoIcon} />
          <Text style={styles.appName}>ExtremeHelp</Text>
          <Text style={styles.subtitle}>Conectando quem precisa com quem pode ajudar.</Text>
          
          <View style={styles.form}>
            <CustomInput
              placeholder="Seu e-mail"
              value={email}
              onChangeText={setEmail}
              keyboardType="email-address"
              autoCapitalize="none"
              leftIcon={<Ionicons name="mail-outline" size={22} color={APP_COLORS.mediumGray} />}
            />
            <CustomInput
              placeholder="Sua senha"
              value={password}
              onChangeText={setPassword}
              secureTextEntry={!showPassword}
              leftIcon={<Ionicons name="lock-closed-outline" size={22} color={APP_COLORS.mediumGray} />}
              rightIcon={
                <Ionicons 
                    name={showPassword ? "eye-off-outline" : "eye-outline"} 
                    size={24} 
                    color={APP_COLORS.mediumGray} 
                    onPress={() => setShowPassword(!showPassword)}
                />
              }
            />
            <CustomButton 
                title="Entrar" 
                onPress={handleLogin} 
                style={{marginTop: 25, marginBottom:15}}
                leftIcon={<Ionicons name="log-in-outline" size={22} color={APP_COLORS.white} />} 
                isLoading={isLoggingIn} // Passar estado de loading para o botão
            />
          </View>

          <CustomButton
            title="Ainda não tem conta? Cadastre-se"
            onPress={() => navigation.navigate('Register')}
            type="TERTIARY" // Usar TERTIARY para um look mais de link
            textStyle={{fontSize:15, color: APP_COLORS.primary, fontWeight:'normal'}}
          />
          
          <Text style={styles.footerText}>FIAP © Global Solution {new Date().getFullYear()}</Text>
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  keyboardView: { flex: 1, backgroundColor: APP_COLORS.lightGray, },
  scrollContainer: { flexGrow: 1, justifyContent: 'center', },
  container: {
    alignItems: 'center',
    paddingHorizontal: 30,
    paddingVertical: 40,
  },
  logoIcon: { marginBottom: 15, },
  appName: {
    fontSize: 32,
    fontWeight: '700',
    color: APP_COLORS.primary,
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: APP_COLORS.darkGray,
    marginBottom: 35,
    textAlign: 'center',
    paddingHorizontal: 10,
  },
  form: { width: '100%', },
  footerText: {
      marginTop: 40,
      fontSize: 12,
      color: APP_COLORS.mediumGray,
  }
});
