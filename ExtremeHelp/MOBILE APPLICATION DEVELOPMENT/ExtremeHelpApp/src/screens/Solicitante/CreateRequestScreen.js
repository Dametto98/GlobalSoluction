// ====================================================================================
// Arquivo: src/screens/Solicitante/CreateRequestScreen.js
// ====================================================================================
import React, { useState, useContext, useEffect } from 'react';
import { View, Text, StyleSheet, Alert, ScrollView, TextInput, TouchableOpacity, Platform } from 'react-native';
import CustomButton from '../../components/CustomButton';
import CustomInput from '../../components/CustomInput';
import * as apiService from '../../services/api';
import LoadingIndicator from '../../components/LoadingIndicator';
import { AuthContext } from '../../contexts/AuthContext';
import { APP_COLORS, HELP_TYPES_LIST, USER_TYPES } from '../../utils/constants';
import { Ionicons } from '@expo/vector-icons';
// import * as Location from 'expo-location'; // Descomente se for usar GPS

export default function CreateRequestScreen({ navigation }) {
  const [description, setDescription] = useState(''); // API: descricão
  const [selectedHelpType, setSelectedHelpType] = useState(HELP_TYPES_LIST[0]); // API: tipoAjuda
  const [address, setAddress] = useState(''); // API: endereco
  const [latitude, setLatitude] = useState(null); // API: latitude
  const [longitude, setLongitude] = useState(null); // API: longitude
  const [isLoading, setIsLoading] = useState(false);
  const [isGettingLocation, setIsGettingLocation] = useState(false);
  const { userId, userType } = useContext(AuthContext);

  // Redirecionar se não for solicitante (ou admin, se admin puder criar)
  useEffect(() => {
    if (userType !== USER_TYPES.SOLICITANTE && userType !== USER_TYPES.ADMIN) {
      Alert.alert("Acesso Negado", "Apenas solicitantes podem criar pedidos de ajuda.");
      navigation.goBack();
    }
  }, [userType, navigation]);


  // Função para obter localização GPS (requer permissão expo-location)
  // const getCurrentLocation = async () => {
  //   let { status } = await Location.requestForegroundPermissionsAsync();
  //   if (status !== 'granted') {
  //     Alert.alert('Permissão de Localização', 'Para usar o GPS, precisamos da sua permissão para acessar a localização.');
  //     return;
  //   }
  //   try {
  //     setIsGettingLocation(true);
  //     // Tenta obter uma localização com precisão razoável rapidamente
  //     let location = await Location.getCurrentPositionAsync({ accuracy: Location.Accuracy.Balanced, timeout: 7000 });
  //     setLatitude(location.coords.latitude);
  //     setLongitude(location.coords.longitude);
      
  //     // Tenta obter o endereço a partir das coordenadas (Geocodificação Reversa)
  //     // try {
  //     //   let reverseGeocode = await Location.reverseGeocodeAsync({ latitude: location.coords.latitude, longitude: location.coords.longitude });
  //     //   if (reverseGeocode.length > 0) {
  //     //     const rg = reverseGeocode[0];
  //     //     const formattedAddress = `${rg.street || ''}${rg.streetNumber ? ' ' + rg.streetNumber : ''}${rg.district ? ', ' + rg.district : ''}${rg.city ? ', ' + rg.city : ''}${rg.postalCode ? ' - ' + rg.postalCode : ''}`;
  //     //     if (!address && formattedAddress.trim()) setAddress(formattedAddress.trim()); // Só preenche se o campo de endereço estiver vazio
  //     //   }
  //     // } catch (geoError) {
  //     //   console.warn("Erro na geocodificação reversa:", geoError);
  //     // }
  //     Alert.alert("Localização GPS Obtida!", `Lat: ${location.coords.latitude.toFixed(4)}, Lon: ${location.coords.longitude.toFixed(4)}`);
  //   } catch (error) {
  //       Alert.alert("Erro de Localização", "Não foi possível obter sua localização GPS no momento. Tente novamente ou insira o endereço manualmente.")
  //       console.error("Error getting location", error);
  //   } finally {
  //       setIsGettingLocation(false);
  //   }
  // };

  const handleSubmit = async () => {
    if (!description.trim() || !selectedHelpType) {
      Alert.alert("Campos Obrigatórios", "A descrição e o tipo de ajuda são essenciais.");
      return;
    }
    if (!address.trim() && (latitude === null || longitude === null)) {
        Alert.alert("Localização Necessária", "Por favor, forneça um endereço ou use o GPS para definir sua localização.");
        return;
    }
    if (!userId) {
        Alert.alert("Erro de Autenticação", "Não foi possível identificar o usuário. Por favor, faça login novamente.");
        return;
    }

    setIsLoading(true);
    try {
      const requestPayload = {
        type: selectedHelpType,
        description: description,
        location: { 
            latitude: latitude || 0.0, // API pode exigir um valor, mesmo que seja 0.0 se não obtido
            longitude: longitude || 0.0,
            address: address.trim() || "Não informado", // Envia endereço mesmo que lat/lon sejam 0
        },
        // dataPedido: será gerado pelo apiService ou backend
        status: "PENDENTE", // Status inicial
      };
      
      await apiService.createHelpRequest(requestPayload, userId); // Passa userId para o serviço
      Alert.alert("Pedido Enviado!", "Seu pedido de ajuda foi registrado com sucesso. Acompanhe em 'Meus Pedidos'.");
      // Limpar formulário
      setDescription('');
      setAddress('');
      setLatitude(null);
      setLongitude(null);
      setSelectedHelpType(HELP_TYPES_LIST[0]);
      navigation.navigate('MeusPedidosTab'); // Navega para a lista de pedidos do usuário
    } catch (error) {
      console.error("Create request screen error:", error);
      Alert.alert("Erro ao Enviar Pedido", error.message || "Não foi possível registrar seu pedido. Verifique os dados e sua conexão.");
    } finally {
      setIsLoading(false);
    }
  };

  if (isGettingLocation) {
      return <LoadingIndicator message="Obtendo sua localização GPS..." />
  }
  if (isLoading) {
    return <LoadingIndicator message="Enviando seu pedido de ajuda..." />;
  }

  return (
    <ScrollView contentContainerStyle={styles.scrollContainer} keyboardShouldPersistTaps="handled">
      <View style={styles.container}>
        {/* <Text style={styles.headerTitle}>Solicitar Ajuda Urgente</Text> */}
        
        <View style={styles.fieldGroup}>
            <Text style={styles.label}><Ionicons name="document-text-outline" size={20} color={APP_COLORS.darkGray} /> O que você precisa?</Text>
            <TextInput
              style={styles.textArea}
              placeholder="Ex: Minha casa foi afetada pela enchente, estou sem energia e preciso de água potável e alimentos para 2 adultos e 1 criança."
              value={description}
              onChangeText={setDescription}
              multiline
              numberOfLines={Platform.OS === 'ios' ? 5 : 5} // Ajuste para melhor visualização
            />
        </View>

        <View style={styles.fieldGroup}>
            <Text style={styles.label}><Ionicons name="medkit-outline" size={20} color={APP_COLORS.darkGray} /> Qual o tipo de ajuda principal?</Text>
            <View style={styles.pickerContainer}>
                {HELP_TYPES_LIST.map(type => (
                    <TouchableOpacity 
                        key={type} 
                        style={[styles.pickerOption, selectedHelpType === type && styles.pickerOptionSelected]}
                        onPress={() => setSelectedHelpType(type)}
                    >
                        <Text style={[styles.pickerOptionText, selectedHelpType === type && styles.pickerOptionTextSelected]}>{type}</Text>
                    </TouchableOpacity>
                ))}
            </View>
        </View>

        <View style={styles.fieldGroup}>
            <Text style={styles.label}><Ionicons name="location-outline" size={20} color={APP_COLORS.darkGray} /> Onde você está?</Text>
            <CustomInput
              placeholder="Endereço completo ou ponto de referência"
              value={address}
              onChangeText={setAddress}
              containerStyle={{marginBottom:10}}
              leftIcon={<Ionicons name="map-outline" size={22} color={APP_COLORS.mediumGray}/>}
            />
            {/* <CustomButton 
                title={latitude && longitude ? "Atualizar GPS" : "Usar Localização GPS"} 
                // onPress={getCurrentLocation} 
                type="SECONDARY" 
                leftIcon={<Ionicons name="navigate-circle-outline" size={20} color={APP_COLORS.primarySolicitante}/>}
                style={{marginBottom:5}}
                isLoading={isGettingLocation}
            /> */}
            {latitude !== null && longitude !== null && (
                <Text style={styles.gpsInfo}>
                    <Ionicons name="checkmark-circle-outline" size={14} color={APP_COLORS.primaryGreen}/> Coordenadas GPS: Lat {latitude.toFixed(4)}, Lon {longitude.toFixed(4)}
                </Text>
            )}
        </View>
        
        <CustomButton 
            title="Enviar Pedido de Ajuda" 
            onPress={handleSubmit} 
            style={{marginTop: 30}}
            leftIcon={<Ionicons name="send-outline" size={22} color={APP_COLORS.white}/>} 
            isLoading={isLoading}
        />
      </View>
    </ScrollView>
  );
}

// Estilos de CreateRequestScreen
const styles = StyleSheet.create({
  scrollContainer: { flexGrow: 1, backgroundColor: APP_COLORS.white, },
  container: { flex: 1, paddingHorizontal: 20, paddingVertical:15, },
  fieldGroup: {
    marginBottom: 20,
  },
  label: { 
    fontSize: 17, 
    color: APP_COLORS.darkGray, 
    marginBottom: 10, 
    fontWeight: '600', 
    flexDirection:'row', 
    alignItems:'center' 
  },
  textArea: {
    borderWidth: 1,
    borderColor: APP_COLORS.mediumGray,
    borderRadius: 8,
    paddingHorizontal: 15,
    paddingVertical: 12,
    fontSize: 15,
    minHeight: 120,
    textAlignVertical: 'top',
    backgroundColor: APP_COLORS.lightGray,
    color: APP_COLORS.darkGray,
  },
  pickerContainer: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    justifyContent: 'flex-start',
  },
  pickerOption: {
    paddingVertical: 10,
    paddingHorizontal: 15,
    borderRadius: 20,
    borderWidth: 1.5,
    borderColor: APP_COLORS.mediumGray,
    marginRight: 10,
    marginBottom: 10,
    backgroundColor: APP_COLORS.lightGray,
  },
  pickerOptionSelected: {
    backgroundColor: APP_COLORS.primarySolicitante,
    borderColor: APP_COLORS.accentSolicitante,
  },
  pickerOptionText: {
    fontSize: 14,
    color: APP_COLORS.darkGray,
    fontWeight: '500',
  },
  pickerOptionTextSelected: {
    color: APP_COLORS.white,
    fontWeight: 'bold',
  },
  gpsInfo: {
      fontSize: 13,
      color: APP_COLORS.primaryGreen,
      textAlign: 'left',
      fontStyle: 'italic',
      marginTop: 8,
      marginLeft: 5,
  }
});