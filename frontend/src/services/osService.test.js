// src/services/osService.test.js
import { jest } from '@jest/globals';
import { API_URL } from '../config.js';

global.fetch = jest.fn();

import {
  listarOS,
  cadastrarOS,
  atualizarOS,
  excluirOS,
} from './osService.js';

describe('Serviço de Ordens de Serviço (OS)', () => {
  beforeEach(() => {
    fetch.mockReset();
  });

  test('listarOS retorna JSON em sucesso', async () => {
    const payload = [{ id: 1, descricao: 'Troca de filtro' }];
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await listarOS();
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/ordemservico`);
    expect(res).toEqual(payload);
  });

  test('listarOS lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(listarOS()).rejects.toThrow('Erro ao buscar ordens de serviço');
  });

  test('cadastrarOS faz POST e retorna JSON em sucesso', async () => {
    const dados = { descricao: 'Troca de óleo', prioridade: 'ALTA' };
    const payload = { id: 10, ...dados };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await cadastrarOS(dados);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/ordemservico`, expect.objectContaining({
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados),
    }));
    expect(res).toEqual(payload);
  });

  test('cadastrarOS lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(cadastrarOS({})).rejects.toThrow('Erro ao cadastrar ordem de serviço');
  });

  test('atualizarOS faz PUT e retorna JSON em sucesso', async () => {
    const id = 7;
    const dados = { descricao: 'Ajuste de correia', prioridade: 'MEDIA' };
    const payload = { id, ...dados };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await atualizarOS(id, dados);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/ordemservico/${id}`, expect.objectContaining({
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados),
    }));
    expect(res).toEqual(payload);
  });

  test('atualizarOS lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(atualizarOS(1, {})).rejects.toThrow('Erro ao atualizar ordem de serviço');
  });

  test('excluirOS faz DELETE e retorna JSON em sucesso', async () => {
    const id = 15;
    const payload = { sucesso: true };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => payload,
    });

    const res = await excluirOS(id);

    expect(fetch).toHaveBeenCalledWith(`${API_URL}/ordemservico/${id}`, expect.objectContaining({
      method: 'DELETE',
    }));
    expect(res).toEqual(payload);
  });

  test('excluirOS lança erro quando resposta não for ok', async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(excluirOS(99)).rejects.toThrow('Erro ao excluir ordem de serviço');
  });
});
