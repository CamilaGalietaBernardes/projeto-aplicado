export const buscarNotificacoesEstoque = async () => {
  try {
    const res = await fetch("http://localhost:5000/notificacoes-estoque");
    if (!res.ok) throw new Error("Erro ao buscar notificações de estoque");
    const dados = await res.json();
    return dados;
  } catch (e) {
    console.error("Erro ao buscar notificações:", e);
    return [];
  }
};
