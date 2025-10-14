const API_URL = import.meta.env.VITE_API_URL;

export async function listarEstoque() {
  const res = await fetch(`${API_URL}/peca`);
  if (!res.ok) throw new Error("Erro ao buscar estoque");
  return res.json();
}

export async function cadastrarPeca(dados) {
  console.log("Dados recebidos no service:", dados);
  const res = await fetch(`${API_URL}/peca`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao cadastrar peça");
  return res.json();
}

export async function atualizarPeca(id, dados) {
  const res = await fetch(`${API_URL}/peca/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao atualizar peça");
  return res.json();
}

export async function excluirPeca(id) {
  const res = await fetch(`${API_URL}/peca/${id}`, {
    method: "DELETE"
  });
  if (!res.ok) {
    const erro = await res.json();
    throw new Error(erro.erro || "Erro ao excluir peça");
  }
  return await res.json();
}

export async function listarEquipamentos() {
  const res = await fetch(`${API_URL}/peca`);
  if (!res.ok) throw new Error("Erro ao buscar peças");
  return res.json();
}

