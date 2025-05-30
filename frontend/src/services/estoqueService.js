export async function listarEstoque() {
  const res = await fetch("http://localhost:5000/estoque");
  if (!res.ok) throw new Error("Erro ao buscar estoque");
  return res.json();
}

export async function cadastrarPeca(dados) {
  const res = await fetch("http://localhost:5000/estoque", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao cadastrar peça");
  return res.json();
}

export async function atualizarPeca(id, dados) {
  const res = await fetch(`http://localhost:5000/estoque/${id}`, {
    method: "PUT",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(dados)
  });
  if (!res.ok) throw new Error("Erro ao atualizar peça");
  return res.json();
}

export async function excluirPeca(id) {
  const res = await fetch(`http://localhost:5000/estoque/${id}`, {
    method: "DELETE"
  });
  if (!res.ok) throw new Error("Erro ao excluir peça");
  return res.json();
}