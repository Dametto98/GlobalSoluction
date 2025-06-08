import axios from 'axios';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';
import { formatDateToAPI, formatDateToAPIDateOnly } from '../utils/helpers';

const ANDROID_API_URL = 'http://10.0.2.2:8080';
const IOS_API_URL = 'http://localhost:8080';
// const LOCAL_NETWORK_API_URL = 'http://SEU_IP_NA_REDE_LOCAL:8080'; 

const API_BASE_URL = Platform.OS === 'android' ? ANDROID_API_URL : IOS_API_URL;
// const API_BASE_URL = LOCAL_NETWORK_API_URL; // Para teste em dispositivo físico

const apiClient = axios.create({
  baseURL: API_BASE_URL,
  timeout: 20000,
});

apiClient.interceptors.request.use(
  async (config) => {
    const token = await AsyncStorage.getItem('userToken');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    if ((config.method === 'post' || config.method === 'put') && !config.headers['Content-Type']) {
        config.headers['Content-Type'] = 'application/json';
    }
    config.headers['User-Agent'] = 'ExtremeHelpApp/1.0.2'; 
    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config;
    if (error.response) {
        if (error.response.status === 401 && !originalRequest._retry) {
            originalRequest._retry = true;
            console.warn("API: Erro 401 - Token inválido ou expirado. O usuário pode precisar ser deslogado.");
            // O AuthContext.logout() pode ser chamado pela tela que originou a chamada
        }
        let errorMessage = `Erro ${error.response.status} da API.`;
        if (error.response.data) {
            if (typeof error.response.data === 'string') {
                errorMessage = error.response.data;
            } else if (error.response.data.message) {
                errorMessage = error.response.data.message;
            } else if (error.response.data.error) {
                errorMessage = error.response.data.error;
            }
        } else if (error.message) {
            errorMessage = error.message;
        }
        return Promise.reject({ message: errorMessage, status: error.response.status, data: error.response.data });
    } else if (error.request) {
        console.error("API: Sem resposta do servidor.", error.request);
        return Promise.reject({ message: "Servidor indisponível. Verifique sua conexão ou tente mais tarde." });
    } else {
        console.error("API: Erro ao configurar requisição.", error.message);
        return Promise.reject({ message: "Erro interno ao tentar comunicar com o servidor." });
    }
  }
);

// --- Autenticação e Usuário ---
export const loginUser = (credentials) => apiClient.post('/login', credentials).then(res => res.data);

export const registerUser = (userDataFromForm) => {
    const apiUserData = {
        nome: userDataFromForm.name,
        email: userDataFromForm.email,
        senha: userDataFromForm.password,
        telefone: userDataFromForm.phone || null,
        tipoUsuario: userDataFromForm.userType.toUpperCase(),
        // dataRegistro e status são definidos pelo backend, conforme Insomnia
    };
    return apiClient.post('/usuario', apiUserData).then(res => res.data);
};

export const fetchAllUsers = () => apiClient.get('/usuario').then(res => res.data);
export const fetchUserById = (id) => apiClient.get(`/usuario/${id}`).then(res => res.data);
export const updateUser = (id, userData) => apiClient.put(`/usuario/${id}`, userData).then(res => res.data);
export const deleteUser = (id) => apiClient.delete(`/usuario/${id}`).then(res => res.data);


// --- PedidoAjuda ---
// GET /pedido-ajuda (com possível filtro por idUsuario, se a API suportar)
export const fetchHelpRequests = (filters = {}) => apiClient.get('/pedido-ajuda', { params: filters }).then(res => res.data);

export const createHelpRequest = (requestDataFromForm, userId) => {
    const apiRequestData = {
        tipoAjuda: requestDataFromForm.type,
        descricão: requestDataFromForm.description, // Atenção ao 'ã'
        latitude: requestDataFromForm.location.latitude,
        longitude: requestDataFromForm.location.longitude,
        endereco: requestDataFromForm.location.address,
        dataPedido: formatDateToAPI(new Date()), // API espera "dd/MM/yyyy HH:mm"
        statusPedido: requestDataFromForm.status || "PENDENTE",
        idUsuario: parseInt(userId, 10),
    };
    return apiClient.post('/pedido-ajuda', apiRequestData).then(res => res.data);
};
export const fetchHelpRequestById = (id) => apiClient.get(`/pedido-ajuda/${id}`).then(res => res.data);
export const updateHelpRequest = (id, updateData) => {
    // Garanta que dataPedido seja formatada se estiver presente em updateData
    if (updateData.dataPedido && updateData.dataPedido instanceof Date) {
        updateData.dataPedido = formatDateToAPI(updateData.dataPedido);
    }
    return apiClient.put(`/pedido-ajuda/${id}`, updateData).then(res => res.data);
};
export const deleteHelpRequest = (id) => apiClient.delete(`/pedido-ajuda/${id}`).then(res => res.data);

// Para "Meus Pedidos" (solicitante)
export const fetchMyHelpRequests = (userId) => 
    apiClient.get('/pedido-ajuda', { params: { idUsuario: parseInt(userId, 10) } })
    .then(res => res.data)
    .catch(err => { // Fallback se a API não suportar o filtro e retornar todos
        if (err.status === 400 || !err.data) { // Exemplo de como poderia ser um erro de param não suportado
             return apiClient.get('/pedido-ajuda').then(allRequests => allRequests.data.filter(req => req.idUsuario === parseInt(userId, 10)));
        }
        throw err;
    });


// --- AtendimentoVoluntario ---
export const fetchAssignments = (filters = {}) => apiClient.get('/atendimento-voluntario', { params: filters }).then(res => res.data);

export const acceptHelpRequestAssignment = (pedidoAjudaId, voluntarioId) => {
    const assignmentData = {
        dataAceite: formatDateToAPI(new Date()), // API espera "dd/MM/yyyy HH:mm"
        idPedidoAjuda: parseInt(pedidoAjudaId, 10),
        idUsuario: parseInt(voluntarioId, 10), // ID do voluntário
    };
    return apiClient.post('/atendimento-voluntario', assignmentData).then(res => res.data);
};
export const fetchAssignmentById = (id) => apiClient.get(`/atendimento-voluntario/${id}`).then(res => res.data);

export const updateAssignment = (id, assignmentUpdateData) => {
    // Formatar datas se presentes
    if (assignmentUpdateData.dataAceite && assignmentUpdateData.dataAceite instanceof Date) {
        assignmentUpdateData.dataAceite = formatDateToAPI(assignmentUpdateData.dataAceite);
    }
    if (assignmentUpdateData.dataConclusao && assignmentUpdateData.dataConclusao instanceof Date) {
        assignmentUpdateData.dataConclusao = formatDateToAPI(assignmentUpdateData.dataConclusao);
    }
    return apiClient.put(`/atendimento-voluntario/${id}`, assignmentUpdateData).then(res => res.data);
};
export const deleteAssignment = (id) => apiClient.delete(`/atendimento-voluntario/${id}`).then(res => res.data);

// Para "Meus Atendimentos" (voluntário)
export const fetchMyAssignments = (volunteerId) => 
    apiClient.get('/atendimento-voluntario', { params: { idUsuario: parseInt(volunteerId, 10) } })
    .then(res => res.data)
    .catch(err => { // Fallback
        if (err.status === 400 || !err.data) {
            return apiClient.get('/atendimento-voluntario').then(allAssignments => allAssignments.data.filter(asg => asg.idUsuario === parseInt(volunteerId, 10)));
        }
        throw err;
    });


// --- Alerta ---
export const fetchAlerts = () => apiClient.get('/alerta').then(res => res.data);
export const createAlert = (alertDataFromForm) => {
    const apiAlertData = {
        titulo: alertDataFromForm.titulo,
        mensagem: alertDataFromForm.mensagem,
        dataPublicacao: formatDateToAPI(new Date(alertDataFromForm.dataPublicacao || Date.now())), // API espera "dd/MM/yyyy HH:mm"
        seriedadeAlerta: alertDataFromForm.seriedadeAlerta?.toUpperCase() || 'BAIXO',
        fonte: alertDataFromForm.fonte || null,
        ativo: alertDataFromForm.ativo === undefined ? true : alertDataFromForm.ativo, // Default para true se não fornecido
    };
    return apiClient.post('/alerta', apiAlertData).then(res => res.data);
};
export const fetchAlertById = (id) => apiClient.get(`/alerta/${id}`).then(res => res.data);
export const updateAlert = (id, alertData) => {
    if (alertData.dataPublicacao && alertData.dataPublicacao instanceof Date) {
        alertData.dataPublicacao = formatDateToAPI(alertData.dataPublicacao);
    }
    return apiClient.put(`/alerta/${id}`, alertData).then(res => res.data);
};
export const deleteAlert = (id) => apiClient.delete(`/alerta/${id}`).then(res => res.data);


// --- DicaPreparacao ---
export const fetchTips = () => apiClient.get('/dica-preparacao').then(res => res.data);
export const createTip = (tipDataFromForm) => {
    const apiTipData = {
        titulo: tipDataFromForm.titulo,
        conteudo: tipDataFromForm.conteudo,
        categoria: tipDataFromForm.categoria || null,
        dataAtualizacao: formatDateToAPI(new Date(tipDataFromForm.dataAtualizacao || Date.now())), // API espera "dd/MM/yyyy HH:mm"
    };
    return apiClient.post('/dica-preparacao', apiTipData).then(res => res.data);
};
export const fetchTipById = (id) => apiClient.get(`/dica-preparacao/${id}`).then(res => res.data);
export const updateTip = (id, tipData) => {
     if (tipData.dataAtualizacao && tipData.dataAtualizacao instanceof Date) {
        tipData.dataAtualizacao = formatDateToAPI(tipData.dataAtualizacao);
    }
    return apiClient.put(`/dica-preparacao/${id}`, tipData).then(res => res.data);
};
export const deleteTip = (id) => apiClient.delete(`/dica-preparacao/${id}`).then(res => res.data);