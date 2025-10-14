const API_URL = import.meta.env.VITE_API_URL;

export async function listarOS() {
  const res = await fetch(`${API_URL}/ordemservico`);
  if (!res.ok) throw new Error("Erro ao buscar ordens de serviço");
  return res.json();
}

export async function cadastrarOS(dados) {
  const res = await fetch(`${API_URL}/ordemservico`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw res;
  return res.json();
}

export async function atualizarOS(id, dados) {
  const res = await fetch(`${API_URL}/ordemservico/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw res;
  return res.json();
}

export async function excluirOS(id) {
  const res = await fetch(`${API_URL}/ordemservico/${id}`, {
    method: "DELETE"
  });
  if (!res.ok) throw new Error("Erro ao excluir ordem de serviço");
  return res.json();
}