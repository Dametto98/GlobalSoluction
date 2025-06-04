// ====================================================================================
// Arquivo: src/utils/helpers.js
// ====================================================================================
/**
 * Formata um objeto Date para "dd/MM/yyyy HH:mm"
 * @param {Date} date Objeto Date
 * @returns {string} Data formatada ou string vazia
 */
export const formatDateToAPI = (date) => {
    if (!(date instanceof Date) || isNaN(date)) return '';
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Mês é 0-indexed
    const year = date.getFullYear();
    const hours = String(date.getHours()).padStart(2, '0');
    const minutes = String(date.getMinutes()).padStart(2, '0');
    return `${day}/${month}/${year} ${hours}:${minutes}`;
  };
  
  /**
   * Formata um objeto Date para "dd/MM/yyyy"
   * @param {Date} date Objeto Date
   * @returns {string} Data formatada ou string vazia
   */
  export const formatDateToAPIDateOnly = (date) => {
    if (!(date instanceof Date) || isNaN(date)) return '';
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0'); // Mês é 0-indexed
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  };
  
  /**
   * Converte uma string "dd/MM/yyyy HH:mm" ou "dd/MM/yyyy" para um objeto Date
   * @param {string} dateString Data no formato "dd/MM/yyyy HH:mm" ou "dd/MM/yyyy"
   * @returns {Date|null} Objeto Date ou null se inválido
   */
  export const parseApiDateString = (dateString) => {
    if (!dateString || typeof dateString !== 'string') return null;
    const partsDateTime = dateString.split(' ');
    const dateParts = partsDateTime[0].split('/');
    
    if (dateParts.length !== 3) return null;
    
    const day = parseInt(dateParts[0], 10);
    const month = parseInt(dateParts[1], 10) - 1; // Mês é 0-indexed
    const year = parseInt(dateParts[2], 10);
  
    if (partsDateTime.length === 2) {
      const timeParts = partsDateTime[1].split(':');
      if (timeParts.length !== 2) return null;
      const hours = parseInt(timeParts[0], 10);
      const minutes = parseInt(timeParts[1], 10);
      if (isNaN(day) || isNaN(month) || isNaN(year) || isNaN(hours) || isNaN(minutes)) return null;
      return new Date(year, month, day, hours, minutes);
    } else {
      if (isNaN(day) || isNaN(month) || isNaN(year)) return null;
      return new Date(year, month, day);
    }
  };
  
  