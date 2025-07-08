import { salvar, ler } from "../utils/storage";

const CHAVE_NOTIFICACOES = "notificacoes";

export const adicionarNotificacao = (mensagem) => {
  const notificacoes = ler(CHAVE_NOTIFICACOES, []);
  const notificao_existente = notificacoes.some((n) => n.mensagem === mensagem);
  
  if (notificao_existente) return;

  const novaNotificacao = { id: Date.now(), mensagem };
  salvar(CHAVE_NOTIFICACOES, [...notificacoes, novaNotificacao]);
};

export const listarNotificacoes = () => {
  return ler(CHAVE_NOTIFICACOES) || [];
};

export const limparNotificacoes = () => salvar(CHAVE_NOTIFICACOES, []);
