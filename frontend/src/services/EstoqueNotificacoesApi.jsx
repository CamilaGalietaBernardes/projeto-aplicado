import { API_URL } from '../config.js';

export const buscarNotificacoesEstoque = async () => {
  try {
    const res = await fetch(`${API_URL}/notificacoes-estoque`);
    if (!res.ok) throw new Error("Erro ao buscar notificações de estoque");
    const dados = await res.json();
    return dados;
  } catch (e) {
    console.error("Erro ao buscar notificações:", e);
    return [];
  }
};
