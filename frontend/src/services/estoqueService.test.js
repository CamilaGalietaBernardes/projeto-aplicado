// src/services/pecaService.test.js
import { jest } from '@jest/globals';
import { API_URL } from '../config.js';

global.fetch = jest.fn();

// (opcional) silencia console.log do cadastrarPeca
const consoleSpy = jest.spyOn(console, 'log').mockImplementation(() => {});

import {
  listarEstoque,
  cadastrarPeca,
  atualizarPeca,
  excluirPeca,
  listarEquipamentos,
} from './estoqueService.js';

describe('Serviço de Peças/Estoque', () => {
  beforeEach(() => {
    fetch.mockReset();
  });

  afterAll(() => {
    consoleSpy.mockRestore();
  });

  test('listarEstoque retorna JSON em sucesso', async () => {
    const payload = [{ id: 1, nome: 'Parafuso' }];
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await listarEstoque();
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/peca`);
    expect(res).toEqual(payload);
  });

  test('listarEstoque lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(listarEstoque()).rejects.toThrow('Erro ao buscar estoque');
  });

  test('cadastrarPeca faz POST e retorna JSON em sucesso', async () => {
    const dados = { nome: 'Parafuso', categoria: 'Fixadores', qtd: 10, qtd_min: 2 };
    const payload = { id: 10, ...dados };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await cadastrarPeca(dados);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/peca`, expect.objectContaining({
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados),
    }));
    expect(res).toEqual(payload);
  });

  test('cadastrarPeca usa mensagem de erro vinda de {erro}', async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: async () => ({ erro: 'Peça já cadastrada' }),
    });

    await expect(cadastrarPeca({ nome: 'X' }))
      .rejects.toThrow('Peça já cadastrada');
  });

  test('cadastrarPeca usa mensagem de erro vinda de {message}', async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: async () => ({ message: 'Campos inválidos' }),
    });

    await expect(cadastrarPeca({ nome: '' }))
      .rejects.toThrow('Campos inválidos');
  });

  test('cadastrarPeca cai no fallback quando body de erro não é JSON', async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: async () => { throw new Error('bad json'); },
    });

    await expect(cadastrarPeca({ nome: 'Y' }))
      .rejects.toThrow('Erro ao cadastrar peça');
  });

  test('atualizarPeca faz PUT e retorna JSON em sucesso', async () => {
    const id = 123;
    const dados = { nome: 'Arruela', qtd: 50 };
    const payload = { id, ...dados };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await atualizarPeca(id, dados);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/peca/${id}`, expect.objectContaining({
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados),
    }));
    expect(res).toEqual(payload);
  });

  test('atualizarPeca lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(atualizarPeca(1, { nome: 'Z' }))
      .rejects.toThrow('Erro ao atualizar peça');
  });

  test('excluirPeca faz DELETE e retorna JSON em sucesso', async () => {
    const id = 789;
    const payload = { sucesso: true };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await excluirPeca(id);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/peca/${id}`, expect.objectContaining({
      method: 'DELETE',
    }));
    expect(res).toEqual(payload);
  });

  test('excluirPeca usa mensagem de erro vinda de {erro}', async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: async () => ({ erro: 'Peça em uso' }),
    });

    await expect(excluirPeca(5)).rejects.toThrow('Peça em uso');
  });

  test('listarEquipamentos retorna JSON em sucesso', async () => {
    const payload = [{ id: 1, nome: 'Parafuso' }];
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await listarEquipamentos();
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/peca`);
    expect(res).toEqual(payload);
  });

  test('listarEquipamentos lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(listarEquipamentos()).rejects.toThrow('Erro ao buscar peças');
  });
});
