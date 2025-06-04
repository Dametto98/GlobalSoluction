export const USER_TYPES = {
    SOLICITANTE: 'SOLICITANTE', // Tipo usado internamente no App e enviado no cadastro
    VOLUNTARIO: 'VOLUNTARIO', // Tipo usado internamente no App e enviado no cadastro
    ADMIN: 'ADMIN',         // Tipo que pode vir da API
  };
  
  export const API_USER_TYPES = { // Tipos que sua API retorna/espera (exemplo do Insomnia)
      ADMIN: 'ADMIN',
      VOLUNTARIO: 'VOLUNTARIO',
      // Se sua API tiver um tipo específico para solicitante, adicione aqui
      // Caso contrário, o app tratará usuários não-VOLUNTARIO/ADMIN como SOLICITANTE
  };
  
  export const APP_COLORS = {
    primary: '#00579c', // Um azul mais escuro e sóbrio
    primarySolicitante: '#007bff',
    accentSolicitante: '#0056b3',
    primaryVoluntario: '#28a745',
    accentVoluntario: '#1e7e34',
    primaryGreen: '#28a745', // Sinônimo para consistência
    accentAdmin: '#6f42c1', // Roxo para Admin
    lightGray: '#f0f4f7',
    mediumGray: '#adb5bd',
    darkGray: '#343a40',
    white: '#ffffff',
    black: '#000000',
    danger: '#dc3545',
    warning: '#ffc107',
    info: '#17a2b8',
    success: '#28a745',
    lightBlue: '#e7f3ff', // Fundo para tela de solicitante
    lightGreen: '#e9f7ef', // Fundo para tela de voluntário
  };
  
  export const HELP_REQUEST_STATUS_API = { // Status como sua API os define
    PENDENTE: 'PENDENTE',
    EM_ATENDIMENTO: 'EM_ATENDIMENTO',
    CONCLUIDO: 'CONCLUIDO',
    CANCELADO: 'CANCELADO',
  };
  
  export const HELP_TYPES_LIST = ["Alimentação", "Abrigo", "Medicamentos", "Resgate Leve", "Roupa/Cobertor", "Transporte", "Outro"];
  
  export const ALERT_SERIOUSNESS_API = {
      BAIXO: 'BAIXO',
      MODERADO: 'MODERADO',
      ALTO: 'ALTO',
      CRITICO: 'CRITICO',
  };