import { useState, useEffect } from "react";
import toast from "react-hot-toast";
import {
  listarOS,
  cadastrarOS,
  atualizarOS,
  excluirOS
} from "../services/osService";
import {
  PencilIcon,
  TrashIcon,
  PlusIcon,
  MagnifyingGlassIcon
} from "@heroicons/react/24/outline";
import ManutencaoModal from "../components/ManutencaoModal";

export default function Manutencao() {
  const [ordens, setOrdens] = useState([]);
  const [busca, setBusca] = useState("");
  const [modalAberto, setModalAberto] = useState(false);
  const [ordemEdicao, setOrdemEdicao] = useState(null);

  useEffect(() => {
    async function carregar() {
      try {
        const dados = await listarOS();
        setOrdens(dados);
      } catch (e) {
        toast.error("Erro ao carregar ordens de serviço");
      }
    }
    carregar();
  }, []);

  const handleSalvar = async (form) => {
    if (!form.tipo || !form.setor || !form.status || !form.equipamento_id || !form.solicitante_id) {
      toast.error("Preencha todos os campos obrigatórios!");
      return;
    }

    try {
      if (ordemEdicao) {
        await atualizarOS(ordemEdicao.id, form);
        toast.success("Ordem atualizada!");
      } else {
        await cadastrarOS(form);
        toast.success("Ordem adicionada!");
      }

      const novasOrdens = await listarOS();
      setOrdens(novasOrdens);
      setModalAberto(false);
      setOrdemEdicao(null);
    } catch (e) {
        try {
          // Este e pode ser o objeto Response do fetch, tenta ler o JSON e mostrar a mensagem
          if (e instanceof Response) {
            e.json().then(errorData => {
              toast.error(errorData.erro || "Erro ao salvar ordem");
            }).catch(() => {
              toast.error("Erro ao salvar ordem");
            });
          } else if (e.message) {
            // Se for erro JS normal com mensagem
            toast.error(e.message);
          } else {
            toast.error("Erro ao salvar ordem");
          }
        } catch {
          toast.error("Erro ao salvar ordem");
        }
      }
  };

  const handleEditar = (ordem) => {
    setOrdemEdicao(ordem);
    setModalAberto(true);
  };

  const handleExcluir = async (id) => {
    if (!window.confirm("Deseja realmente excluir esta ordem?")) return;
    try {
      await excluirOS(id);
      const novasOrdens = await listarOS();
      setOrdens(novasOrdens);
      toast.success("Ordem excluída!");
    } catch (e) {
      toast.error("Erro ao excluir ordem");
    }
  };

  const ordensFiltradas = ordens.filter((ordem) =>
    ordem.tipo?.toLowerCase().includes(busca.toLowerCase()) ||
    ordem.setor?.toLowerCase().includes(busca.toLowerCase()) ||
    ordem.recorrencia?.toLowerCase().includes(busca.toLowerCase()) ||
    ordem.detalhes?.toLowerCase().includes(busca.toLowerCase())
  );

  return (
    <div className="w-full min-h-screen bg-gray-100 p-0">
      {/* Cabeçalho */}
      <div className="sticky top-0 z-10 bg-white flex items-center justify-between px-8 py-6 border-b shadow-sm">
        <h1 className="text-3xl font-bold text-emerald-700">Ordens de Manutenção</h1>
        <div className="flex gap-2">
          <div className="relative">
            <input
              value={busca}
              onChange={(e) => setBusca(e.target.value)}
              placeholder="Buscar por tipo, setor, recorrência ou detalhes..."
              className="border rounded-lg p-2 pl-8 w-72 focus:outline-emerald-600"
            />
            <MagnifyingGlassIcon className="w-5 h-5 absolute left-2 top-2 text-gray-400" />
          </div>
          <button
            onClick={() => {
              setModalAberto(true);
              setOrdemEdicao(null);
            }}
            className="bg-emerald-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-emerald-700 shadow"
          >
            <PlusIcon className="w-5 h-5" /> Nova Ordem
          </button>
        </div>
      </div>

      {/* Cards */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-6 p-8">
        {ordensFiltradas.length === 0 && (
          <div className="text-gray-500 col-span-full text-center">Nenhuma ordem encontrada.</div>
        )}

        {ordensFiltradas.map((ordem) => (
          <div
            key={ordem.id}
            className="rounded-xl shadow-md p-6 bg-white flex flex-col gap-2 border hover:shadow-lg transition"
          >
            <div className="flex justify-between items-center mb-2">
              <span className="font-bold text-lg text-emerald-700">
                {ordem.equipamento?.peca || "-"}
              </span>
              <span
                className={`px-3 py-1 rounded-full text-sm font-bold 
                  ${ordem.status === "Atrasada"
                    ? "bg-red-100 text-red-700"
                    : ordem.status === "Concluída"
                      ? "bg-emerald-100 text-emerald-800"
                      : "bg-yellow-100 text-yellow-800"
                  }`}
              >
                {ordem.status}
              </span>
            </div>
            <div className="text-gray-600 text-sm">
              Responsável: <span className="font-medium">{ordem.solicitante?.nome || "-"}</span>
            </div>
            <div className="text-gray-600 text-sm">
              Tipo: <span className="font-medium">{ordem.tipo || "-"}</span>
            </div>
            <div className="text-gray-600 text-sm">
              Setor: <span className="font-medium">{ordem.setor || "-"}</span>
            </div>
            <div className="text-gray-600 text-sm">
              Recorrência: <span className="font-medium">{ordem.recorrencia || "-"}</span>
            </div>
            <div className="text-gray-600 text-sm">
              Descrição: <span className="font-medium">{ordem.detalhes || "-"}</span>
            </div>
            <div className="flex gap-2 mt-3">
              <button
                onClick={() => handleEditar(ordem)}
                className="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 flex items-center gap-1"
              >
                <PencilIcon className="w-4 h-4" /> Editar
              </button>
              <button
                onClick={() => handleExcluir(ordem.id)}
                className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 flex items-center gap-1"
              >
                <TrashIcon className="w-4 h-4" /> Excluir
              </button>
            </div>
          </div>
        ))}
      </div>

      <ManutencaoModal
        open={modalAberto}
        onClose={() => {
          setModalAberto(false);
          setOrdemEdicao(null);
        }}
        onSalvar={handleSalvar}
        ordemEdicao={ordemEdicao}
      />
    </div>
  );
}
