import { salvar, ler } from "../utils/storage";

const CHAVE_NOTIFICACOES = "notificacoes";

export const adicionarNotificacao = (mensagem) => {
  const notificacoes = ler(CHAVE_NOTIFICACOES);
  const novaNotificacao = { id: Date.now(), mensagem };
  salvar(CHAVE_NOTIFICACOES, [...notificacoes, novaNotificacao]);
};

export const listarNotificacoes = () => ler(CHAVE_NOTIFICACOES);

export const limparNotificacoes = () => salvar(CHAVE_NOTIFICACOES, []);