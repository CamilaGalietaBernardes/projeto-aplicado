import { createContext, useContext, useEffect, useState } from "react";

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [autenticado, setAutenticado] = useState(() => {
    return localStorage.getItem("autenticado") === "true";
  });
  const [usuario, setUsuario] = useState(() => {
    const raw = localStorage.getItem("usuarioLogado");
    if (!raw || raw === "undefined") return null;
    try {
      return JSON.parse(raw);
    } catch {
      return null;
    }
  });

  useEffect(() => {
    localStorage.setItem("autenticado", autenticado ? "true" : "false");
  }, [autenticado]);

  function login(usuarioObj) {
    setUsuario(usuarioObj);
    setAutenticado(true);
    localStorage.setItem("usuarioLogado", JSON.stringify(usuarioObj));
  }

  function logout() {
    setUsuario(null);
    setAutenticado(false);
    localStorage.removeItem("usuarioLogado");
  }

  return (
    <AuthContext.Provider value={{ autenticado, login, logout }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  return useContext(AuthContext);
}