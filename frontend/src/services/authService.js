export function getUsuarios() {
  return JSON.parse(localStorage.getItem("usuarios") || "[]");
}

export function salvarUsuarios(usuarios) {
  localStorage.setItem("usuarios", JSON.stringify(usuarios));
}

export async function autenticar(usuario, senha) {
  const res = await fetch("http://localhost:5000/login", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ usuario, senha })
  });
  if (res.ok) {
    return await res.json(); // Dados do usuário
  } else {
    throw new Error("Usuário ou senha inválidos");
  }
}

export async function cadastrarUsuario(dados) {
  const res = await fetch("http://localhost:5000/usuarios", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao cadastrar usuário");
  return res.json();
}