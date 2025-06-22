import React, { useState, useEffect } from "react";

const EstoqueModal = React.memo(function EstoqueModal({
  open,
  onClose,
  onSalvar,
  editandoId,
  itemEdicao // novo prop
}) {
  const [form, setForm] = useState({
    nome: "",
    quantidade: "",
    tipo: "",
    qtd_min: ""
  });

  useEffect(() => {
    if (open) {
      setForm(itemEdicao || { nome: "", quantidade: "", tipo: "", qtd_min: "" });
    }
  }, [open, itemEdicao]);

  if (!open) return null;
  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50" aria-modal="true" role="dialog">
      <div className="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
        <h2 className="text-2xl font-bold mb-4 text-gray-700">
          {editandoId ? "Editar Peça/Ferramenta" : "Nova Peça/Ferramenta"}
        </h2>
        <input
          type="text"
          placeholder="Nome"
          value={form.nome}
          onChange={e => setForm(f => ({ ...f, nome: e.target.value }))}
          className="w-full mb-4 p-2 border rounded"
        />
        <input
          type="number"
          placeholder="Quantidade"
          value={form.quantidade}
          onChange={e => setForm(f => ({ ...f, quantidade: e.target.value }))}
          className="w-full mb-4 p-2 border rounded"
        />
        <input
          type="text"
          placeholder="Tipo (Ferramenta/Peça)"
          value={form.tipo}
          onChange={e => setForm(f => ({ ...f, tipo: e.target.value }))}
          className="w-full mb-4 p-2 border rounded"
        />
        <input
          type="number"
          placeholder="Quantidade Mínima"
          value={form.qtd_min}
          onChange={e => setForm(f => ({ ...f, qtd_min: e.target.value }))}
          className="w-full mb-4 p-2 border rounded"
        />
        <div className="flex justify-end space-x-4">
          <button
            onClick={() => onSalvar(form)}
            className="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded"
          >
            Salvar
          </button>
          <button
            onClick={onClose}
            className="bg-gray-400 hover:bg-gray-500 text-white px-4 py-2 rounded"
            aria-label="Cancelar"
          >
            Cancelar
          </button>
        </div>
      </div>
    </div>
  );
});

export default EstoqueModal;