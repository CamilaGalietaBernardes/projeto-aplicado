// src/services/notificacaoService.test.js
import { jest } from '@jest/globals';

jest.unstable_mockModule('../config', () => ({
  API_URL: 'http://localhost:5000'
}));

jest.unstable_mockModule('../utils/storage', () => ({
  salvar: jest.fn(),
  ler: jest.fn()
}));

const storage = await import('../utils/storage');

const {
  adicionarNotificacao,
  listarNotificacoes,
  limparNotificacoes
} = await import('./notificacoesService.js');

describe('Serviço de Notificações', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  test('adicionarNotificacao adiciona quando não é duplicada', () => {
    storage.ler.mockReturnValueOnce([]);

    const nowSpy = jest.spyOn(Date, 'now').mockReturnValue(1234567890);

    adicionarNotificacao('Estoque abaixo do mínimo');

    expect(storage.ler).toHaveBeenCalledWith('notificacoes', []);
    expect(storage.salvar).toHaveBeenCalledTimes(1);
    expect(storage.salvar).toHaveBeenCalledWith('notificacoes', [
      { id: 1234567890, mensagem: 'Estoque abaixo do mínimo' }
    ]);

    nowSpy.mockRestore();
  });

  test('adicionarNotificacao NÃO adiciona se já existir mensagem igual', () => {
    storage.ler.mockReturnValueOnce([
      { id: 1, mensagem: 'Falha ao cadastrar peça' }
    ]);

    adicionarNotificacao('Falha ao cadastrar peça');

    expect(storage.salvar).not.toHaveBeenCalled();
  });

  test('adicionarNotificacao mantém notificações prévias e adiciona ao final', () => {
    storage.ler.mockReturnValueOnce([
      { id: 10, mensagem: 'Primeira' }
    ]);

    const nowSpy = jest.spyOn(Date, 'now').mockReturnValue(777);

    adicionarNotificacao('Segunda');

    expect(storage.salvar).toHaveBeenCalledWith('notificacoes', [
      { id: 10, mensagem: 'Primeira' },
      { id: 777, mensagem: 'Segunda' }
    ]);

    nowSpy.mockRestore();
  });

  test('listarNotificacoes devolve o que vier de ler()', () => {
    const lista = [
      { id: 1, mensagem: 'A' },
      { id: 2, mensagem: 'B' }
    ];
    storage.ler.mockReturnValueOnce(lista);

    const res = listarNotificacoes();
    expect(storage.ler).toHaveBeenCalledWith('notificacoes');
    expect(res).toEqual(lista);
  });

  test('listarNotificacoes retorna [] quando ler() retorna undefined/null', () => {
    storage.ler.mockReturnValueOnce(undefined);

    const res = listarNotificacoes();
    expect(res).toEqual([]);
  });

  test('limparNotificacoes salva lista vazia', () => {
    limparNotificacoes();
    expect(storage.salvar).toHaveBeenCalledWith('notificacoes', []);
  });
});
