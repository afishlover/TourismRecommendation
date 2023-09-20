import axios from 'axios';

const customAxios = axios.create();

// Request interceptor for API calls
customAxios.interceptors.request.use(
    async config => {
        return config; 
    },
    error => {
        Promise.reject(error)
    }
);

customAxios.interceptors.response.use(
    (response) => {
        return response?.data;
    },
    (error) => {
        const response = {
            code: 0,
            data: error?.response?.data,
        };
        
        throw response;
    }
);

export { customAxios };