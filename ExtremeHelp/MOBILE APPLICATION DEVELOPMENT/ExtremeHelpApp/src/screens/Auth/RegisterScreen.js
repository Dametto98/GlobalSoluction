// ====================================================================================
// Arquivo: src/screens/Auth/RegisterScreen.js
// ====================================================================================
import React, { useState, useContext } from 'react';
import { View, Text, StyleSheet, Alert, ScrollView, KeyboardAvoidingView, Platform, TouchableOpacity } from 'react-native';
import { AuthContext } from '../../contexts/AuthContext';
import CustomInput from '../../components/CustomInput';
import CustomButton from '../../components/CustomButton';
import LoadingIndicator from '../../components/LoadingIndicator';
import { APP_COLORS, USER_TYPES } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';

export default function RegisterScreen({ navigation }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');
  const [phone, setPhone] = useState('');
  const [selectedUserType, setSelectedUserType] = useState(USER_TYPES.SOLICITANTE); // SOLICITANTE ou VOLUNTARIO
  const { register, isLoadingAuth } = useContext(AuthContext);
  const [localLoading, setLocalLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);

  const handleRegister = async () => {
    if (!name.trim() || !email.trim() || !password || !confirmPassword) {
      Alert.alert("Campos Incompletos", "Nome, e-mail e senha são obrigatórios para o cadastro.");
      return;
    }
    if (password !== confirmPassword) {
      Alert.alert("Senhas Divergentes", "As senhas digitadas não coincidem. Por favor, verifique.");
      return;
    }
    if (password.length < 6) {
      Alert.alert("Senha Curta", "Sua senha deve ter pelo menos 6 caracteres para maior segurança.");
      return;
    }
    setLocalLoading(true);
    try {
      // O userType aqui é 'SOLICITANTE' ou 'VOLUNTARIO' (do app)
      // A função apiService.registerUser mapeará para o que a API espera se necessário.
      await register({ 
          name, 
          email, 
          password, 
          phone: phone.trim() || null,
          userType: selectedUserType 
      });
      Alert.alert(
        "Cadastro Realizado!", 
        "Sua conta foi criada com sucesso. Por favor, faça login para acessar o aplicativo.",
        [{ text: "OK", onPress: () => navigation.navigate('Login') }] // Redireciona para login
      );
    } catch (error) {
      console.error("Register screen error:", error);
      Alert.alert("Erro no Cadastro", error.message || "Não foi possível realizar seu cadastro. Verifique os dados ou tente mais tarde.");
    } finally {
      setLocalLoading(false);
    }
  };
  
  if (isLoadingAuth || localLoading) {
    return <LoadingIndicator message="Criando sua conta..."/>;
  }

  return (
    <KeyboardAvoidingView 
        behavior={Platform.OS === "ios" ? "padding" : "height"}
        style={styles.keyboardView}
    >
      <ScrollView contentContainerStyle={styles.scrollContainer} keyboardShouldPersistTaps="handled">
        <View style={styles.container}>
          <TouchableOpacity onPress={() => navigation.goBack()} style={styles.backButton}>
            <Ionicons name="arrow-back-outline" size={28} color={APP_COLORS.primary} />
          </TouchableOpacity>
          
          <Text style={styles.headerTitle}>Crie sua Conta</Text>
          <Text style={styles.headerSubtitle}>É rápido, fácil e você já poderá fazer a diferença ou encontrar ajuda.</Text>

          <CustomInput 
            label="Nome Completo"
            placeholder="Seu nome como será exibido" value={name} onChangeText={setName} 
            leftIcon={<Ionicons name="person-outline" size={22} color={APP_COLORS.mediumGray} />}
          />
          <CustomInput 
            label="E-mail"
            placeholder="Seu melhor e-mail para contato" value={email} onChangeText={setEmail} 
            keyboardType="email-address" autoCapitalize="none"
            leftIcon={<Ionicons name="mail-outline" size={22} color={APP_COLORS.mediumGray} />}
          />
          <CustomInput 
            label="Telefone (Opcional)"
            placeholder="(XX) XXXXX-XXXX" value={phone} onChangeText={setPhone} 
            keyboardType="phone-pad"
            leftIcon={<Ionicons name="call-outline" size={22} color={APP_COLORS.mediumGray} />}
          />
          <CustomInput 
            label="Senha"
            placeholder="Crie uma senha segura (mín. 6 caracteres)" value={password} onChangeText={setPassword} 
            secureTextEntry={!showPassword}
            leftIcon={<Ionicons name="lock-closed-outline" size={22} color={APP_COLORS.mediumGray} />}
            rightIcon={<Ionicons name={showPassword ? "eye-off-outline" : "eye-outline"} size={24} color={APP_COLORS.mediumGray} onPress={() => setShowPassword(!showPassword)} />}
          />
          <CustomInput 
            label="Confirmar Senha"
            placeholder="Digite sua senha novamente" value={confirmPassword} onChangeText={setConfirmPassword} 
            secureTextEntry={!showConfirmPassword}
            leftIcon={<Ionicons name="lock-closed-outline" size={22} color={APP_COLORS.mediumGray} />}
            rightIcon={<Ionicons name={showConfirmPassword ? "eye-off-outline" : "eye-outline"} size={24} color={APP_COLORS.mediumGray} onPress={() => setShowConfirmPassword(!showConfirmPassword)} />}
          />
          
          <Text style={styles.labelUserType}>Qual seu objetivo no aplicativo?</Text>
          <View style={styles.userTypeSelector}>
            <CustomButton 
                title="Preciso de Ajuda" 
                onPress={() => setSelectedUserType(USER_TYPES.SOLICITANTE)}
                type={selectedUserType === USER_TYPES.SOLICITANTE ? 'PRIMARY' : 'TERTIARY'}
                style={styles.userTypeButton}
                textStyle={selectedUserType === USER_TYPES.SOLICITANTE ? {color: APP_COLORS.white} : {color: APP_COLORS.primary}}
                leftIcon={<Ionicons name="hand-left-outline" size={20} color={selectedUserType === USER_TYPES.SOLICITANTE ? APP_COLORS.white : APP_COLORS.primary} />}
            />
            <CustomButton 
                title="Quero Ajudar" 
                onPress={() => setSelectedUserType(USER_TYPES.VOLUNTARIO)}
                type={selectedUserType === USER_TYPES.VOLUNTARIO ? 'PRIMARY_GREEN' : 'TERTIARY'}
                style={styles.userTypeButton}
                textStyle={selectedUserType === USER_TYPES.VOLUNTARIO ? {color: APP_COLORS.white} : {color: APP_COLORS.primaryGreen}}
                leftIcon={<Ionicons name="heart-outline" size={20} color={selectedUserType === USER_TYPES.VOLUNTARIO ? APP_COLORS.white : APP_COLORS.primaryGreen} />}
            />
          </View>

          <CustomButton 
            title="Criar Minha Conta" 
            onPress={handleRegister} 
            style={{marginTop: 25}} 
            type={selectedUserType === USER_TYPES.VOLUNTARIO ? "PRIMARY_GREEN" : "PRIMARY"}
            leftIcon={<Ionicons name="person-add-outline" size={22} color={APP_COLORS.white} />}  
            isLoading={localLoading}
          />
        </View>
      </ScrollView>
    </KeyboardAvoidingView>
  );
}

// Estilos do RegisterScreen (mantidos e usando APP_COLORS)
const styles = StyleSheet.create({
  keyboardView: { flex: 1, backgroundColor: APP_COLORS.lightGray, },
  scrollContainer: { flexGrow: 1, justifyContent: 'center', paddingVertical: 20, },
  container: { paddingHorizontal: 25, },
  backButton: { position: 'absolute', top: Platform.OS === 'ios' ? 40 : 15, left: 10, zIndex: 1, padding:10 },
  headerTitle: {
    fontSize: 26, // Um pouco menor para caber bem
    fontWeight: '700',
    color: APP_COLORS.darkGray,
    textAlign: 'center',
    marginTop: Platform.OS === 'ios' ? 20 : 50,
    marginBottom: 8,
  },
  headerSubtitle: {
    fontSize: 15,
    color: APP_COLORS.mediumGray,
    textAlign: 'center',
    marginBottom: 25,
    paddingHorizontal: 10,
  },
  labelUserType: {
    fontSize: 16,
    color: APP_COLORS.darkGray,
    marginBottom: 12,
    marginTop: 20,
    fontWeight: '600',
  },
  userTypeSelector: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 20,
  },
  userTypeButton: {
    flex: 1,
    marginHorizontal: 5,
  },
});