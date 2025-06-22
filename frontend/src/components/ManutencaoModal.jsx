import { useState, useEffect } from "react";
import { Dialog } from "@headlessui/react";
import { listarEquipamentos } from "../services/estoqueService";
import { listarUsuarios } from "../services/authService";

// ...imports
export default function ManutencaoModal({ open, onSalvar, onClose, ordemEdicao }) {
  const [form, setForm] = useState({
    tipo: "",
    setor: "",
    recorrencia: "",
    detalhes: "",
    status: "",
    data: new Date().toISOString().split("T")[0],
    equipamento_id: "",
    solicitante_id: ""
  });

  const [equipamentos, setEquipamentos] = useState([]);
  const [usuarios, setUsuarios] = useState([]);

  useEffect(() => {
    if (ordemEdicao) {
      setForm({
        tipo: ordemEdicao.tipo || "",
        setor: ordemEdicao.setor || "",
        recorrencia: ordemEdicao.recorrencia || "",
        detalhes: ordemEdicao.detalhes || "",
        status: ordemEdicao.status || "",
        data: ordemEdicao.data?.split("T")[0] || new Date().toISOString().split("T")[0],
        equipamento_id: ordemEdicao.equipamento?.id || "",
        solicitante_id: ordemEdicao.solicitante?.id || ""
      });
    }
  }, [ordemEdicao]);

  useEffect(() => {
    async function carregarDados() {
      try {
        const [eqps, usrs] = await Promise.all([
          listarEquipamentos(),
          listarUsuarios()
        ]);
        setEquipamentos(eqps);
        setUsuarios(usrs);
      } catch (e) {
        console.error("Erro ao carregar dados:", e);
      }
    }
    carregarDados();
  }, []);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setForm(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = () => {
    if (!form.tipo || !form.setor || !form.status || !form.data || !form.equipamento_id || !form.solicitante_id) {
      alert("Preencha todos os campos obrigatórios.");
      return;
    }

    const dados = {
      ...form,
      equipamento_id: parseInt(form.equipamento_id),
      solicitante_id: parseInt(form.solicitante_id)
    };

    onSalvar(dados);
  };

  return (
    <Dialog open={open} onClose={onClose} className="relative z-50">
      <div className="fixed inset-0 bg-black/30" aria-hidden="true" />
      <div className="fixed inset-0 flex items-center justify-center p-4">
        <Dialog.Panel className="w-full max-w-lg bg-white rounded-xl shadow p-6 space-y-4">
          <Dialog.Title className="text-2xl font-bold text-emerald-700">
            {ordemEdicao ? "Editar Ordem" : "Nova Ordem de Serviço"}
          </Dialog.Title>

          <div className="space-y-3">
            <input name="tipo" value={form.tipo} onChange={handleChange} placeholder="Tipo" className="w-full p-2 border rounded" />
            <input name="setor" value={form.setor} onChange={handleChange} placeholder="Setor" className="w-full p-2 border rounded" />
            <input name="recorrencia" value={form.recorrencia} onChange={handleChange} placeholder="Recorrência" className="w-full p-2 border rounded" />
            <textarea name="detalhes" value={form.detalhes} onChange={handleChange} placeholder="Detalhes" className="w-full p-2 border rounded" />
            <select name="status" value={form.status} onChange={handleChange} className="w-full p-2 border rounded">
              <option value="">Selecione o status</option>
              <option value="Aberta">Aberta</option>
              <option value="Em andamento">Em andamento</option>
              <option value="Concluída">Concluída</option>
              <option value="Atrasada">Atrasada</option>
            </select>
            <input type="date" name="data" value={form.data} onChange={handleChange} className="w-full p-2 border rounded" />
            <select name="equipamento_id" value={form.equipamento_id} onChange={handleChange} className="w-full p-2 border rounded">
              <option value="">Selecione o Equipamento</option>
              {equipamentos.map((e) => (
                <option key={e.id} value={e.id}>{e.peca}</option>
              ))}
            </select>
            <select name="solicitante_id" value={form.solicitante_id} onChange={handleChange} className="w-full p-2 border rounded">
              <option value="">Selecione o Solicitante</option>
              {usuarios.map((u) => (
                <option key={u.id} value={u.id}>{u.nome}</option>
              ))}
            </select>
          </div>

          <div className="flex justify-end gap-2 mt-4">
            <button onClick={onClose} className="px-4 py-2 rounded border">Cancelar</button>
            <button type="button" onClick={handleSubmit} className="px-4 py-2 rounded bg-emerald-600 text-white">Salvar</button>
          </div>
        </Dialog.Panel>
      </div>
    </Dialog>
  );
}
