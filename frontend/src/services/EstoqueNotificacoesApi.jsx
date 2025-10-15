export const buscarNotificacoesEstoque = async () => {
  try {
    const res = await fetch(`${import.meta.env.VITE_API_URL}/notificacoes-estoque`);

    if (!res.ok) throw new Error("Erro ao buscar notificações de estoque");
    const dados = await res.json();
    return dados;
  } catch (e) {
    console.error("Erro ao buscar notificações:", e);
    return [];
  }
};
