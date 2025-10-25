import { useState, useEffect } from "react";
import toast from "react-hot-toast";
import { PencilIcon, TrashIcon, PlusIcon, MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import EstoqueModal from "../components/EstoqueModal";
import { listarEstoque, cadastrarPeca, atualizarPeca, excluirPeca } from "../services/estoqueService";
import { useLocation, useNavigate } from "react-router-dom";

export default function Estoque() {
  const [itens, setItens] = useState([]);
  const [busca, setBusca] = useState("");
  const [modalAberto, setModalAberto] = useState(false);
  const [itemEdicao, setItemEdicao] = useState(null);
  const location = useLocation();
  const navigate = useNavigate();

  const fecharModal = () => {
      setModalAberto(false);
      setItemEdicao(null);
      navigate("/estoque", { replace: true });
    };

  useEffect(() => {
    carregarEstoque();
  }, []);

  useEffect(() => {
    const query = new URLSearchParams(location.search);
    const abrirPecaId = query.get("abrirPeca");
    
    if (abrirPecaId && itens.length > 0) {
      const item = itens.find(it => String(it.id) === abrirPecaId);
      if (item) {
        setItemEdicao({
          ...item,
          nome: item.peca,
          quantidade: item.qtd,
          tipo: item.categoria,
          qtd_min: item.qtd_min
        });
        setModalAberto(true);
      }
    }
  }, [location.search, itens]);

  async function carregarEstoque() {
    try {
      const dados = await listarEstoque();
      setItens(dados);
    } catch (e) {
      toast.error("Erro ao carregar estoque");
    }
  }

const handleSalvar = async (form) => {
  if (!form.nome || !form.quantidade || !form.qtd_min) {
    toast.error("Preencha todos os campos!");
    return;
  }

  try {
    if (itemEdicao) {
      await atualizarPeca(itemEdicao.id, {
        nome: form.nome,
        qtd: Number(form.quantidade),
        categoria: form.tipo || "Outro", 
        qtd_min: Number(form.qtd_min)
      });
      toast.success("Item atualizado!");
    } else {
      const dados = {
        nome: form.nome,
        qtd: Number(form.quantidade),
        categoria: form.tipo || "Outro",
        qtd_min: Number(form.qtd_min),
      };
      await cadastrarPeca(dados);
      toast.success("Item adicionado!");
    }

        setModalAberto(false);
        setItemEdicao(null);
        navigate("/estoque", { replace: true });
        carregarEstoque();
      } catch (e) {
        toast.error(e.message);
      }
    };

  const handleEditar = (item) => {
    setItemEdicao({
      ...item,
      nome: item.peca,
      quantidade: item.qtd,
      tipo: item.categoria,
      qtd_min: item.qtd_min
    });
    setModalAberto(true);
  };

  const handleExcluir = async (id) => {
    if (!window.confirm("Deseja realmente excluir este item?")) return;
    try {
      await excluirPeca(id);
      toast.success("Item excluído!");
      carregarEstoque();
    } catch (e) {
      toast.error(e.message);
    }
  };

  const itensFiltrados = itens.filter(item =>
    item.peca?.toLowerCase().includes(busca.toLowerCase()) ||
    item.categoria?.toLowerCase().includes(busca.toLowerCase())
  );

  return (
    <div className="w-full min-h-screen bg-gray-100 p-0">
      {/* Cabeçalho fixo */}
      <div className="sticky top-0 z-10 bg-white flex items-center justify-between px-8 py-6 border-b shadow-sm">
        <h1 className="text-3xl font-bold text-emerald-700">Gestão de Estoque</h1>
        <div className="flex gap-2">
          <div className="relative">
            <input
              value={busca}
              onChange={e => setBusca(e.target.value)}
              placeholder="Buscar por nome ou categoria..."
              className="border rounded-lg p-2 pl-8 w-64 focus:outline-emerald-600"
            />
            <MagnifyingGlassIcon className="w-5 h-5 absolute left-2 top-2 text-gray-400" />
          </div>
          <button
            onClick={() => { setModalAberto(true); setItemEdicao(null); }}
            className="bg-emerald-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-emerald-700 shadow"
          >
            <PlusIcon className="w-5 h-5" /> Adicionar
          </button>
        </div>
      </div>
      {/* Cards de estoque */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-6 p-8">
        {itensFiltrados.length === 0 && (
          <div className="text-gray-500 col-span-full text-center">Nenhum item encontrado.</div>
        )}
        {itensFiltrados.map((item) => (
          <div key={item.id} className="rounded-xl shadow-md p-6 bg-white flex flex-col gap-2 border hover:shadow-lg transition">
            <div className="flex justify-between items-center mb-2">
              <span className="font-bold text-lg text-emerald-700">{item.peca}</span>
              <span className={`px-3 py-1 rounded-full text-sm font-bold 
                ${item.qtd <= item.qtd_min ? "bg-red-100 text-red-700" : "bg-emerald-100 text-emerald-800"}`}>
                {item.qtd} un.
              </span>
            </div>
            <div className="text-gray-600 text-sm">Categoria: <span className="font-medium">{item.categoria || "-"}</span></div>
            <div className="flex gap-2 mt-3">
              <button onClick={() => handleEditar(item)} className="bg-blue-500 text-white px-3 py-1 rounded hover:bg-blue-600 flex items-center gap-1">
                <PencilIcon className="w-4 h-4" /> Editar
              </button>
              <button onClick={() => handleExcluir(item.id)} className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 flex items-center gap-1">
                <TrashIcon className="w-4 h-4" /> Excluir
              </button>
            </div>
          </div>
        ))}
      </div>
      <EstoqueModal
        open={modalAberto}
        onClose={fecharModal}
        onSalvar={handleSalvar}
        itemEdicao={itemEdicao}
        editandoId={itemEdicao?.id}
      />
    </div>
  );
}