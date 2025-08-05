import { listarNotificacoes, limparNotificacoes } from "../services/notificacoesService";
import toast from "react-hot-toast";
import { useState, useEffect } from "react";

const Notificacoes = () => {
  const [notificacoes, setNotificacoes] = useState([]);

  useEffect(() => {
    setNotificacoes(listarNotificacoes());
  }, []);

  const handleLimpar = () => {
    limparNotificacoes();
    toast.success("Notificações limpas!");
    setNotificacoes([]);
  };

  return (
    <div className="max-w-xl mx-auto mt-10 bg-white p-6 rounded shadow">
      <h1 className="text-2xl font-bold mb-4">Notificações</h1>
      <button
        onClick={handleLimpar}
        className="mb-4 bg-emerald-600 text-white px-4 py-2 rounded hover:bg-emerald-700"
      >
        Limpar todas
      </button>
      <ul>
        {notificacoes.length === 0 && (
          <li className="text-gray-500">Nenhuma notificação.</li>
        )}
        {notificacoes.map(n => (
          <li key={n.id} className="mb-2 border-b pb-2">{n.mensagem}</li>
        ))}
      </ul>
    </div>
  );
};

export default Notificacoes;