import { useState, useEffect } from "react";
import { createPortal } from "react-dom";
import { LockClosedIcon, UserIcon, EnvelopeIcon } from "@heroicons/react/24/outline";

export default function CadastroModal({ open, onClose, onCadastrar }) {
  const [form, setForm] = useState({
    nome: "",
    email: "",
    usuario: "",
    funcao: "",
    setor: "",
    senha: "",
    confirmar: "",
  });
  const [erro, setErro] = useState("");

  useEffect(() => {
    if (open) {
      setForm({ nome: "", email: "", usuario: "", funcao: "", setor: "", senha: "", confirmar: "" });
      setErro("");
    }
  }, [open]);

  if (!open) return null;

  const handleSubmit = (e) => {
    e.preventDefault();
    setErro("");
    if (!form.nome || !form.email || !form.usuario || !form.funcao || !form.setor || !form.senha || !form.confirmar) {
      setErro("Preencha todos os campos.");
      return;
    }
    if (form.senha !== form.confirmar) {
      setErro("As senhas não coincidem.");
      return;
    }
    onCadastrar(form);
  };

  // Conteúdo do modal
  const modalContent = (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-40">
      <div className="bg-white rounded-2xl shadow-xl w-full max-w-md p-8 relative animate-slide-down">
        <button
          className="absolute top-3 right-4 text-gray-400 hover:text-red-500 text-2xl"
          onClick={onClose}
          title="Fechar"
        >
          ×
        </button>
        <h2 className="text-2xl font-bold text-emerald-700 mb-6 text-center">Criar Conta</h2>
        <form className="flex flex-col gap-4" onSubmit={handleSubmit}>
          {/* ...restante do formulário... */}
          <div>
            <label className="block font-medium mb-1">Nome completo</label>
            <input
              className="border rounded w-full p-2"
              value={form.nome}
              onChange={e => setForm(f => ({ ...f, nome: e.target.value }))}
              required
            />
          </div>
          <div>
            <label className="block font-medium mb-1">E-mail</label>
            <div className="relative">
              <EnvelopeIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
              <input
                type="email"
                className="border rounded w-full p-2 pl-10"
                value={form.email}
                onChange={e => setForm(f => ({ ...f, email: e.target.value }))}
                required
              />
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">Usuário</label>
            <div className="relative">
              <UserIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
              <input
                className="border rounded w-full p-2 pl-10"
                value={form.usuario}
                onChange={e => setForm(f => ({ ...f, usuario: e.target.value }))}
                required
              />
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">funçao</label>
            <div className="relative">
              <EnvelopeIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
              <input
                className="border rounded w-full p-2 pl-10"
                value={form.funcao}
                onChange={e => setForm(f => ({ ...f, funcao: e.target.value }))}
                required
              />
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">setor</label>
            <div className="relative">
              <EnvelopeIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
              <input
                className="border rounded w-full p-2 pl-10"
                value={form.setor}
                onChange={e => setForm(f => ({ ...f, setor: e.target.value }))}
                required
              />
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">Senha</label>
            <div className="relative">
              <LockClosedIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
              <input
                type="password"
                className="border rounded w-full p-2 pl-10"
                value={form.senha}
                onChange={e => setForm(f => ({ ...f, senha: e.target.value }))}
                required
              />
            </div>
          </div>
          <div>
            <label className="block font-medium mb-1">Confirmar Senha</label>
            <input
              type="password"
              className="border rounded w-full p-2"
              value={form.confirmar}
              onChange={e => setForm(f => ({ ...f, confirmar: e.target.value }))}
              required
            />
          </div>
          {erro && <div className="text-red-500 text-sm text-center">{erro}</div>}
          <button
            type="submit"
            className="w-full bg-emerald-600 text-white py-2 rounded-lg font-semibold hover:bg-emerald-700 transition"
          >
            Cadastrar
          </button>
        </form>
      </div>
    </div>
  );

  return createPortal(modalContent, document.getElementById("modal-root"));
}