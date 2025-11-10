// src/services/authService.test.js
import { jest } from '@jest/globals';
import { API_URL } from '../config.js';

global.fetch = jest.fn();

import {
  getUsuarios,
  salvarUsuarios,
  autenticar,
  cadastrarUsuario,
  listarUsuarios
} from './authService.js';

describe('Funções de usuários', () => {

  beforeEach(() => {
    localStorage.clear();
    fetch.mockReset();
  });

  test("getUsuarios retorna array vazio se não houver usuários", () => {
    expect(getUsuarios()).toEqual([]);
  });

  test("salvarUsuarios armazena os usuários corretamente", () => {
    const usuarios = [{ id: 1, nome: "Mike" }];
    salvarUsuarios(usuarios);

    const armazenado = JSON.parse(localStorage.getItem("usuarios"));
    expect(armazenado).toEqual(usuarios);
  });

  test("getUsuarios retorna os usuários armazenados", () => {
    const usuarios = [{ id: 1, nome: "Camila" }];
    localStorage.setItem("usuarios", JSON.stringify(usuarios));
    expect(getUsuarios()).toEqual(usuarios);
  });

  test("autenticar faz requisição POST e retorna JSON em sucesso", async () => {
    const fakeResponse = { token: "abc123" };

    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => fakeResponse
    });

    const resultado = await autenticar("user", "pass");
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/login`, expect.objectContaining({
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ usuario: "user", senha: "pass" })
    }));
    expect(resultado).toEqual(fakeResponse);
  });

  test("autenticar lança erro se a resposta não for ok", async () => {
    fetch.mockResolvedValueOnce({
      ok: false,
      json: async () => ({ erro: "Usuário inválido" })
    });

    await expect(autenticar("user", "wrong"))
      .rejects.toThrow("Usuário inválido");
  });

  test("cadastrarUsuario faz POST e retorna JSON em sucesso", async () => {
    const fakeResponse = { id: 1, nome: "Mike" };
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => fakeResponse
    });

    const resultado = await cadastrarUsuario({ nome: "Mike" });
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/usuarios`, expect.objectContaining({
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ nome: "Mike" })
    }));
    expect(resultado).toEqual(fakeResponse);
  });

  test("cadastrarUsuario lança erro se a resposta não for ok", async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(cadastrarUsuario({ nome: "X" }))
      .rejects.toThrow("Erro ao cadastrar usuário");
  });

  test("listarUsuarios faz GET e retorna JSON em sucesso", async () => {
    const fakeUsuarios = [{ id: 1, nome: "Camila" }];
    fetch.mockResolvedValueOnce({
      ok: true,
      json: async () => fakeUsuarios
    });

    const resultado = await listarUsuarios();
    expect(fetch).toHaveBeenCalledWith(`${API_URL}/usuarios`);
    expect(resultado).toEqual(fakeUsuarios);
  });

  test("listarUsuarios lança erro se a resposta não for ok", async () => {
    fetch.mockResolvedValueOnce({ ok: false });
    await expect(listarUsuarios())
      .rejects.toThrow("Erro ao buscar usuários");
  });
});
