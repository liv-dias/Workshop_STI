import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  withCredentials: true,

  headers: {
    'Api-Key': 'mackleaps' 
  }
})


api.interceptors.response.use(
  (response) => {
    return response // Se deu 200 OK, deixa passar normal
  },
  (error) => {
    if (error.response) {
      
      // 401: Sessão expirou ou não existe
      if (error.response.status === 401) {
        
        // Chuta pro login
        window.location.href = '/' 
      } 
      
      // 403: não tem permissão 
      else if (error.response.status === 403) {
        alert('Acesso Negado: Você não tem permissão para realizar esta ação.')
       
      }
    }

    //SEMPRE rejeita a promessa no final para quebrar o fluxo lá no componente Vue
    return Promise.reject(error)
  }
)

export default api