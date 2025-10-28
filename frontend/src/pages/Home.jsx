import { useState, useEffect } from "react";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
import {
  HomeIcon,
  WrenchScrewdriverIcon,
  CubeIcon,
  DocumentChartBarIcon,
  ExclamationTriangleIcon,
  CheckCircleIcon,
  ClockIcon,
  ArrowRightIcon
} from "@heroicons/react/24/outline";

import { API_URL } from "../config.js";

export default function Home() {
  const navigate = useNavigate();
  const [estatisticas, setEstatisticas] = useState({
    totalOrdens: 0,
    ordensConcluidas: 0,
    ordensPendentes: 0,
    ordensAtrasadas: 0,
    totalPecas: 0,
    pecasBaixoEstoque: 0,
    ultimasOrdens: [],
    pecasCriticas: []
  });

  useEffect(() => {
    carregarDados();
  }, []);

  const carregarDados = async () => {
    try {
      // Carregar ordens de serviço
      const resOrdens = await fetch(`${API_URL}/ordemservico`);
      const ordens = await resOrdens.json();

      // Carregar peças do estoque
      const resPecas = await fetch(`${API_URL}/peca`);
      const pecas = await resPecas.json();

      // Processar estatísticas
      const concluidas = ordens.filter(o => o.status === "Concluída").length;
      const emAndamento = ordens.filter(o => o.status === "Em Andamento").length;
      const atrasadas = ordens.filter(o => o.status === "Atrasada").length;
      const baixoEstoque = pecas.filter(p => p.qtd <= p.qtd_min);

      // Últimas 5 ordens
      const ultimasOrdens = ordens
        .sort((a, b) => new Date(b.data) - new Date(a.data))
        .slice(0, 5)
        .map(o => ({
          id: o.id,
          equipamento: o.equipamento?.peca || "Sem Nome",
          status: o.status,
          tipo: o.tipo,
          data: new Date(o.data).toLocaleDateString("pt-BR")
        }));

      // Peças críticas (baixo estoque)
      const pecasCriticas = baixoEstoque.slice(0, 5).map(p => ({
        id: p.id,
        nome: p.peca,
        quantidade: p.qtd,
        minima: p.qtd_min
      }));

      setEstatisticas({
        totalOrdens: ordens.length,
        ordensConcluidas: concluidas,
        ordensEmAndamento: emAndamento,
        ordensAtrasadas: atrasadas,
        totalPecas: pecas.length,
        pecasBaixoEstoque: baixoEstoque.length,
        ultimasOrdens,
        pecasCriticas
      });
    } catch (error) {
      console.error("Erro ao carregar dados:", error);
      toast.error("Erro ao carregar informações do dashboard");
    }
  };

  // Dados para gráficos
  const dataStatus = [
    { name: "Concluída", value: estatisticas.ordensConcluidas },
    { name: "Pendente", value: estatisticas.ordensPendentes },
    { name: "Atrasada", value: estatisticas.ordensAtrasadas }
  ];

  const COLORS = ["#059669", "#f59e42", "#dc2626"];

  const atalhos = [
    {
      titulo: "Ordens de Manutenção",
      descricao: "Gerenciar ordens de serviço",
      icon: WrenchScrewdriverIcon,
      rota: "/manutencao",
      cor: "bg-blue-500"
    },
    {
      titulo: "Gestão de Estoque",
      descricao: "Controlar peças e materiais",
      icon: CubeIcon,
      rota: "/estoque",
      cor: "bg-emerald-500"
    },
    {
      titulo: "Relatórios",
      descricao: "Visualizar análises e métricas",
      icon: DocumentChartBarIcon,
      rota: "/relatorios",
      cor: "bg-purple-500"
    }
  ];

  return (
    <div className="w-full min-h-screen bg-gray-100 p-0">
      {/* Cabeçalho fixo */}
      <div className="sticky top-0 z-10 bg-white flex items-center justify-between px-8 py-6 border-b shadow-sm">
        <div className="flex items-center gap-3">
          <HomeIcon className="w-8 h-8 text-emerald-700" />
          <h1 className="text-3xl font-bold text-emerald-700">Página Inicial</h1>
        </div>
        <div className="text-sm text-gray-600">
          {new Date().toLocaleDateString("pt-BR", {
            weekday: "long",
            year: "numeric",
            month: "long",
            day: "numeric"
          })}
        </div>
      </div>

      {/* Indicadores principais (KPIs) */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-6 gap-6 p-8">
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <WrenchScrewdriverIcon className="w-10 h-10 text-emerald-600 mb-2" />
          <span className="text-gray-500 text-sm">Ordens Totais</span>
          <span className="text-3xl font-bold text-emerald-700">{estatisticas.totalOrdens}</span>
        </div>
        
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <CheckCircleIcon className="w-10 h-10 text-emerald-600 mb-2" />
          <span className="text-gray-500 text-sm">Concluídas</span>
          <span className="text-3xl font-bold text-emerald-700">{estatisticas.ordensConcluidas}</span>
        </div>
        
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <ClockIcon className="w-10 h-10 text-yellow-600 mb-2" />
          <span className="text-gray-500 text-sm">Em Andamento</span>
          <span className="text-3xl font-bold text-yellow-600">{estatisticas.ordensEmAndamento}</span>
        </div>
        
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <ExclamationTriangleIcon className="w-10 h-10 text-red-600 mb-2" />
          <span className="text-gray-500 text-sm">Atrasadas</span>
          <span className="text-3xl font-bold text-red-600">{estatisticas.ordensAtrasadas}</span>
        </div>
        
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <CubeIcon className="w-10 h-10 text-blue-600 mb-2" />
          <span className="text-gray-500 text-sm">Peças em Estoque</span>
          <span className="text-3xl font-bold text-blue-700">{estatisticas.totalPecas}</span>
        </div>
        
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center hover:shadow-lg transition">
          <ExclamationTriangleIcon className="w-10 h-10 text-red-600 mb-2" />
          <span className="text-gray-500 text-sm">Baixo Estoque</span>
          <span className="text-3xl font-bold text-red-600">{estatisticas.pecasBaixoEstoque}</span>
        </div>
      </div>

      {/* Atalhos rápidos */}
      <div className="px-8 mb-8">
        <h2 className="text-xl font-bold text-gray-700 mb-4">Acesso Rápido</h2>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {atalhos.map((atalho, index) => (
            <div
              key={index}
              onClick={() => navigate(atalho.rota)}
              className="bg-white rounded-xl shadow p-6 flex items-center gap-4 cursor-pointer hover:shadow-lg transition group"
            >
              <div className={`${atalho.cor} rounded-lg p-4`}>
                <atalho.icon className="w-8 h-8 text-white" />
              </div>
              <div className="flex-1">
                <h3 className="font-bold text-gray-800">{atalho.titulo}</h3>
                <p className="text-sm text-gray-500">{atalho.descricao}</p>
              </div>
              <ArrowRightIcon className="w-6 h-6 text-gray-400 group-hover:text-emerald-600 transition" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}
