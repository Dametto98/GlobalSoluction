// ====================================================================================
// Arquivo: src/contexts/AuthContext.js
// ====================================================================================
import React, { createContext, useState, useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';
import * as apiService from '../services/api';
import { USER_TYPES, API_USER_TYPES } from '../utils/constants';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [userToken, setUserToken] = useState(null);
  const [userType, setUserType] = useState(null); // SOLICITANTE, VOLUNTARIO, ADMIN (do app)
  const [userId, setUserId] = useState(null);
  const [userName, setUserName] = useState(null);
  const [isLoadingAuth, setIsLoadingAuth] = useState(true);

  const mapApiUserTypeToAppUserType = (apiTipoUsuario) => {
    const upperApiTipoUsuario = apiTipoUsuario?.toUpperCase();
    if (upperApiTipoUsuario === API_USER_TYPES.ADMIN) return USER_TYPES.ADMIN;
    if (upperApiTipoUsuario === API_USER_TYPES.VOLUNTARIO) return USER_TYPES.VOLUNTARIO;
    
    // Se a API retornar "SOLICITANTE" diretamente, ou se não for ADMIN/VOLUNTARIO, consideramos SOLICITANTE.
    // A API no Insomnia não tem um tipo "SOLICITANTE" explícito no login, usa "ADMIN".
    // Ajuste esta lógica se a sua API retornar tipos diferentes ou se precisar de uma regra mais complexa.
    // Por exemplo, se um ADMIN também puder ser um solicitante, você precisaria de mais informações.
    // Assumindo que se não for VOLUNTARIO ou ADMIN, é um solicitante por padrão no app.
    // Ou, se sua API retornar um tipo "USUARIO", você mapearia para "SOLICITANTE".
    console.log(`API tipoUsuario: ${upperApiTipoUsuario}, mapeado para App UserType`);
    return USER_TYPES.SOLICITANTE; // Default se não for ADMIN ou VOLUNTARIO.
  };

  const login = async (email, password) => {
    setIsLoadingAuth(true);
    try {
      const response = await apiService.loginUser({ email, password }); // API: /login
      // Sua API retorna: token, id, nome, email, tipoUsuario
      if (response && response.token && response.id && response.tipoUsuario && response.nome) {
        const appUserType = mapApiUserTypeToAppUserType(response.tipoUsuario);
        
        setUserToken(response.token);
        setUserId(response.id.toString());
        setUserName(response.nome);
        setUserType(appUserType);

        await AsyncStorage.setItem('userToken', response.token);
        await AsyncStorage.setItem('userId', response.id.toString());
        await AsyncStorage.setItem('userType', appUserType); // Armazenar o tipo do App
        await AsyncStorage.setItem('userName', response.nome);
      } else {
        throw new Error(response.message || "Resposta inválida da API de login. Verifique os dados retornados.");
      }
    } catch (error) {
      console.error("AuthContext Login Error:", error.message);
      await AsyncStorage.multiRemove(['userToken', 'userType', 'userId', 'userName']);
      setUserToken(null); setUserType(null); setUserId(null); setUserName(null);
      throw error; // Re-throw para a tela de login tratar e exibir a mensagem
    } finally {
      setIsLoadingAuth(false);
    }
  };

  const register = async (userDataFromForm) => { 
    // userDataFromForm: { name, email, password, phone, userType (do app: 'SOLICITANTE' ou 'VOLUNTARIO') }
    setIsLoadingAuth(true);
    try {
      // A função apiService.registerUser já formata os dados para a API /usuario
      // A API /usuario (POST) cria o usuário. Não necessariamente retorna um token para login imediato.
      const response = await apiService.registerUser(userDataFromForm);
      // O frontend deve instruir o usuário a fazer login após o registro.
      return response; // Retorna a resposta para a tela de registro (ex: exibir mensagem de sucesso)
    } catch (error) {
      console.error("AuthContext Register Error:", error.message);
      throw error; // Re-throw para a tela de registro tratar
    } finally {
      setIsLoadingAuth(false);
    }
  };

  const logout = async () => {
    setIsLoadingAuth(true);
    try {
      // Opcional: Chamar um endpoint de logout na API para invalidar o token no servidor, se existir.
      // await apiService.logoutUserOnApi();
      await AsyncStorage.multiRemove(['userToken', 'userType', 'userId', 'userName']);
    } catch (e) {
      console.error("AuthContext Logout Error (AsyncStorage):", e);
    } finally {
      setUserToken(null); setUserType(null); setUserId(null); setUserName(null);
      setIsLoadingAuth(false);
    }
  };

  const isLoggedIn = async () => {
    try {
      setIsLoadingAuth(true);
      const token = await AsyncStorage.getItem('userToken');
      const storedAppUserType = await AsyncStorage.getItem('userType'); // Tipo do App (SOLICITANTE, VOLUNTARIO, ADMIN)
      const id = await AsyncStorage.getItem('userId');
      const name = await AsyncStorage.getItem('userName');
      
      if (token && storedAppUserType && id) {
        // Opcional: Validar token com a API aqui (ex: uma chamada a /me ou um endpoint de validação)
        // Se o token for inválido, chamar logout()
        setUserToken(token);
        setUserId(id);
        setUserName(name || 'Usuário');
        setUserType(storedAppUserType);
      } else {
        // Se alguma informação essencial estiver faltando, limpar tudo
        await AsyncStorage.multiRemove(['userToken', 'userType', 'userId', 'userName']);
        setUserToken(null); setUserType(null); setUserId(null); setUserName(null);
      }
    } catch (e) {
      console.error("AuthContext isLoggedIn Error:", e);
      await AsyncStorage.multiRemove(['userToken', 'userType', 'userId', 'userName']);
      setUserToken(null); setUserType(null); setUserId(null); setUserName(null);
    } finally {
      setIsLoadingAuth(false);
    }
  };

  useEffect(() => {
    isLoggedIn();
  }, []);

  return (
    <AuthContext.Provider value={{ userToken, userType, userId, userName, isLoadingAuth, login, logout, register }}>
      {children}
    </AuthContext.Provider>
  );
};