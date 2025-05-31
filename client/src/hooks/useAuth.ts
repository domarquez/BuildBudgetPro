import { useQuery, useMutation } from "@tanstack/react-query";
import { queryClient } from "@/lib/queryClient";

interface User {
  id: number;
  username: string;
  email: string;
  firstName?: string;
  lastName?: string;
  role: string;
  isActive: boolean;
  createdAt: string;
  lastLogin?: string;
}

interface AuthResponse {
  user: User;
  token: string;
}

export function useAuth() {
  const token = localStorage.getItem('auth_token');

  const { data: user, isLoading, error } = useQuery<User>({
    queryKey: ["/api/auth/me"],
    enabled: !!token,
    retry: false,
    meta: {
      headers: token ? { Authorization: `Bearer ${token}` } : undefined,
    },
  });

  const loginMutation = useMutation({
    mutationFn: async (credentials: { username: string; password: string }): Promise<AuthResponse> => {
      const response = await fetch('/api/auth/login', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(credentials)
      });
      
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Error de autenticación');
      }
      
      return response.json();
    },
    onSuccess: (data) => {
      localStorage.setItem('auth_token', data.token);
      queryClient.setQueryData(["/api/auth/me"], data.user);
    },
  });

  const registerMutation = useMutation({
    mutationFn: async (userData: {
      username: string;
      email: string;
      password: string;
      firstName?: string;
      lastName?: string;
    }): Promise<AuthResponse> => {
      const response = await fetch('/api/auth/register', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(userData)
      });
      
      if (!response.ok) {
        const error = await response.json();
        throw new Error(error.message || 'Error en el registro');
      }
      
      return response.json();
    },
    onSuccess: (data) => {
      localStorage.setItem('auth_token', data.token);
      queryClient.setQueryData(["/api/auth/me"], data.user);
    },
  });

  const logout = () => {
    localStorage.removeItem('auth_token');
    queryClient.setQueryData(["/api/auth/me"], null);
    queryClient.clear();
    window.location.href = '/login';
  };

  const isAuthenticated = !!user && !error;
  const isAdmin = user?.role === 'admin';

  return {
    user,
    isLoading,
    isAuthenticated,
    isAdmin,
    login: loginMutation.mutate,
    register: registerMutation.mutate,
    logout,
    loginLoading: loginMutation.isPending,
    registerLoading: registerMutation.isPending,
  };
}