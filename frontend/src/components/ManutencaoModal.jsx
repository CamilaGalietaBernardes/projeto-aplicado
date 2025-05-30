import { useEffect, useState } from "react";

export default function ManutencaoModal({ open, onClose, onSalvar, ordemEdicao }) {
  const [form, setForm] = useState({
    equipamento: "",
    responsavel: "",
    tipo: "",
    status: "",
    descricao: "",
  });

  useEffect(() => {
    if (ordemEdicao) {
      setForm({
        equipamento: ordemEdicao.equipamento || "",
        responsavel: ordemEdicao.responsavel || "",
        tipo: ordemEdicao.tipo || "",
        status: ordemEdicao.status || "",
        descricao: ordemEdicao.descricao || "",
      });
    } else {
      setForm({
        equipamento: "",
        responsavel: "",
        tipo: "",
        status: "",
        descricao: "",
      });
    }
  }, [ordemEdicao, open]);

  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-40">
      <div className="bg-white rounded-xl shadow-lg w-full max-w-lg p-8 relative">
        <button
          className="absolute top-3 right-4 text-gray-400 hover:text-red-500 text-2xl"
          onClick={onClose}
          title="Fechar"
        >
          ×
        </button>
        <h2 className="text-2xl font-bold mb-6 text-emerald-700">
          {ordemEdicao ? "Editar Ordem" : "Nova Ordem de Manutenção"}
        </h2>
        <form
          onSubmit={e => {
            e.preventDefault();
            onSalvar(form);
          }}
          className="flex flex-col gap-4"
        >
          <div>
            <label className="block font-medium mb-1">Equipamento *</label>
            <input
              className="border rounded w-full p-2"
              value={form.equipamento}
              onChange={e => setForm(f => ({ ...f, equipamento: e.target.value }))}
              required
            />
          </div>
          <div>
            <label className="block font-medium mb-1">Responsável *</label>
            <input
              className="border rounded w-full p-2"
              value={form.responsavel}
              onChange={e => setForm(f => ({ ...f, responsavel: e.target.value }))}
              required
            />
          </div>
          <div>
            <label className="block font-medium mb-1">Tipo *</label>
            <select
              className="border rounded w-full p-2"
              value={form.tipo}
              onChange={e => setForm(f => ({ ...f, tipo: e.target.value }))}
              required
            >
              <option value="">Selecione</option>
              <option value="Corretiva">Corretiva</option>
              <option value="Preventiva">Preventiva</option>
            </select>
          </div>
          <div>
            <label className="block font-medium mb-1">Status *</label>
            <select
              className="border rounded w-full p-2"
              value={form.status}
              onChange={e => setForm(f => ({ ...f, status: e.target.value }))}
              required
            >
              <option value="">Selecione</option>
              <option value="Pendente">Pendente</option>
              <option value="Em Execução">Em Execução</option>
              <option value="Concluída">Concluída</option>
              <option value="Atrasada">Atrasada</option>
            </select>
          </div>
          <div>
            <label className="block font-medium mb-1">Descrição</label>
            <textarea
              className="border rounded w-full p-2"
              value={form.descricao}
              onChange={e => setForm(f => ({ ...f, descricao: e.target.value }))}
              rows={3}
            />
          </div>
          <div className="flex justify-end gap-2 mt-4">
            <button
              type="button"
              className="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300"
              onClick={onClose}
            >
              Cancelar
            </button>
            <button
              type="submit"
              className="px-4 py-2 rounded bg-emerald-600 text-white hover:bg-emerald-700"
            >
              {ordemEdicao ? "Salvar Alterações" : "Cadastrar"}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}