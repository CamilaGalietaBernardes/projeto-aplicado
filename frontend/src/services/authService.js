export function getUsuarios() {
  return JSON.parse(localStorage.getItem("usuarios") || "[]");
}

export function salvarUsuarios(usuarios) {
  localStorage.setItem("usuarios", JSON.stringify(usuarios));
}

const API_URL = "http://localhost:5000";

export async function autenticar(usuario, senha) {
  const response = await fetch(`${API_URL}/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ usuario, senha })
  });

  if (!response.ok) {
    const erro = await response.json();
    throw new Error(erro.erro || "Erro ao autenticar");
  }

  return await response.json();
}


export async function cadastrarUsuario(dados) {
  const res = await fetch(`${API_URL}/usuarios`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao cadastrar usuário");
  return res.json();
}

export async function listarUsuarios() {
  const res = await fetch(`${API_URL}/usuarios`);
  if (!res.ok) throw new Error("Erro ao buscar usuários");
  return res.json();
}
