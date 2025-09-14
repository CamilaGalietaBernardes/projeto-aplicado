import { useEffect, useState } from "react";
import { ler, salvar } from "../utils/storage";
import { MagnifyingGlassIcon } from "@heroicons/react/24/outline";
import { saveAs } from "file-saver";
import {
  PieChart, Pie, Cell, Tooltip as RechartsTooltip, Legend,
  BarChart, Bar, XAxis, YAxis, CartesianGrid, ResponsiveContainer
} from "recharts";
import * as XLSX from "xlsx";


export default function Relatorios() {
  const [manutencoes, setManutencoes] = useState([]);
  const [estoque, setEstoque] = useState([]);
  const [busca, setBusca] = useState("");
  const [filtroStatus, setFiltroStatus] = useState("");
  const [filtroTipo, setFiltroTipo] = useState("");

const carregarEstoque = async () => {
    try {
      const response = await fetch("https://projeto-aplicado.onrender.com/peca");
      const dados = await response.json();
      const dadosFormatados = dados.map((e) => ({
        nome: e.peca,
        categoria: e.categoria,
        quantidade: e.qtd,
        qtd_min: e.qtd_min,
      }));
      salvar("estoque", dadosFormatados);
    } catch (error) {
      console.error("Erro ao carregar estoque:", error);
    }
  };

  const carregarManutencoes = async () => {
    try {
      const response = await fetch("https://projeto-aplicado.onrender.com/ordemservico");
      const dados = await response.json();
      const manutencoesFormatadas = dados.map((o) => ({
        id: o.id,
        equipamento: o.equipamento?.peca || "Sem Nome",
        responsavel: o.solicitante?.nome || "Sem Nome",
        tipo: o.tipo,
        status: o.status,
        dataAbertura: new Date(o.data).toLocaleDateString("pt-BR"),
        descricao: o.detalhes,
      }));
      salvar("manutencao", manutencoesFormatadas);
    } catch (error) {
      console.error("Erro ao carregar manutenções:", error);
    }
  };

  // Função utilitária para exportar CSV
  function exportarCSV(ordens) {
    if (!ordens.length) return;
    const header = ["Equipamento", "Responsável", "Tipo", "Status", "Abertura", "Descrição"];
    const rows = ordens.map(m =>
      [
        m.equipamento,
        m.responsavel,
        m.tipo,
        m.status,
        m.dataAbertura,
        (m.descricao || "").replace(/\n/g, " ")
      ].map(v => `"${(v || "").replace(/"/g, '""')}"`).join(",")
    );
    const csv = [header.join(","), ...rows].join("\r\n");
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    saveAs(blob, "relatorio-manutencao.csv");
  }

  function exportarExcel(manutencoes, estoque) {
  const worksheet1 = XLSX.utils.json_to_sheet(manutencoes.map((m) => ({
    Equipamento: m.equipamento,
    Responsável: m.responsavel,
    Tipo: m.tipo,
    Status: m.status,
    "Data de Abertura": m.dataAbertura,
    Descrição: m.descricao,
  })));

  const worksheet2 = XLSX.utils.json_to_sheet(estoque.map((e) => ({
    Nome: e.nome,
    Quantidade: e.quantidade,
    "Quantidade Mínima": e.qtd_min,
    Alerta: e.quantidade <= (e.qtd_min || 0) ? "⚠️ Baixo Estoque" : "OK"
  })));

  const workbook = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(workbook, worksheet1, "Ordens de Manutenção");
  XLSX.utils.book_append_sheet(workbook, worksheet2, "Estoque");

  const excelBuffer = XLSX.write(workbook, { bookType: "xlsx", type: "array" });
  const blob = new Blob([excelBuffer], { type: "application/octet-stream" });
  saveAs(blob, "relatorio_manutencao.xlsx");
} 

  useEffect(() => {
    Promise.all([carregarEstoque(), carregarManutencoes()]).then(() => {
      setEstoque(ler("estoque", []));
      setManutencoes(ler("manutencao", []));
    });
  }, []);

  // KPIs
  const totalOrdens = manutencoes.length;
  const concluidas = manutencoes.filter(m => m.status === "Concluída").length;
  const pendentes = manutencoes.filter(m => m.status === "Pendente").length;
  const atrasadas = manutencoes.filter(m => m.status === "Atrasada").length;
  const baixoEstoque = estoque.filter(e => 
    typeof e.quantidade === "number" && e.quantidade <= e.qtd_min).length;

  // Dados para gráficos
  const dataStatus = [
    { name: "Concluída", value: concluidas },
    { name: "Pendente", value: pendentes },
    { name: "Atrasada", value: atrasadas },
  ];
  const COLORS = ["#059669", "#f59e42", "#dc2626"];

  const dataTipo = [
    { name: "Corretiva", value: manutencoes.filter(m => m.tipo === "Corretiva").length },
    { name: "Preventiva", value: manutencoes.filter(m => m.tipo === "Preventiva").length },
  ];

  const dataEstoque = estoque.map(e => ({
    nome: e.nome,
    quantidade: e.quantidade,
    minima: e.qtd_min || 0,
  }));

  // Filtros
  const manutencoesFiltradas = manutencoes.filter(m =>
    (busca === "" ||
      m.equipamento?.toLowerCase().includes(busca.toLowerCase()) ||
      m.responsavel?.toLowerCase().includes(busca.toLowerCase()) ||
      m.tipo?.toLowerCase().includes(busca.toLowerCase())
    ) &&
    (filtroStatus === "" || m.status === filtroStatus) &&
    (filtroTipo === "" || m.tipo === filtroTipo)
  );

  return (
    <div className="w-full min-h-screen bg-gray-100 p-0">
      {/* Cabeçalho fixo */}
      <div className="sticky top-0 z-10 bg-white flex items-center justify-between px-8 py-6 border-b shadow-sm">
        <h1 className="text-3xl font-bold text-emerald-700">Relatórios Gerenciais</h1>
      </div>

      {/* Indicadores principais */}
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-6 p-8">
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-gray-500 text-sm">Ordens Totais</span>
          <span className="text-3xl font-bold text-emerald-700">{totalOrdens}</span>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-gray-500 text-sm">Concluídas</span>
          <span className="text-3xl font-bold text-emerald-700">{concluidas}</span>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-gray-500 text-sm">Pendentes</span>
          <span className="text-3xl font-bold text-yellow-600">{pendentes}</span>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <span className="text-gray-500 text-sm">Atrasadas</span>
          <span className="text-3xl font-bold text-red-600">{atrasadas}</span>
        </div>
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center col-span-1 md:col-span-2">
          <span className="text-gray-500 text-sm">Peças em Baixo Estoque</span>
          <span className="text-3xl font-bold text-red-600">{baixoEstoque}</span>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-8 px-8 mb-8">
        {/* Gráfico de status das manutenções */}
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <h3 className="font-bold mb-4 text-emerald-700">Distribuição de Status</h3>
          <ResponsiveContainer width="100%" height={250}>
            <PieChart>
              <Pie
                data={dataStatus}
                dataKey="value"
                nameKey="name"
                cx="50%"
                cy="50%"
                outerRadius={80}
                label
              >
                {dataStatus.map((entry, index) => (
                  <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                ))}
              </Pie>
              <RechartsTooltip />
              <Legend />
            </PieChart>
          </ResponsiveContainer>
        </div>
        {/* Gráfico de tipos de manutenção */}
        <div className="bg-white rounded-xl shadow p-6 flex flex-col items-center">
          <h3 className="font-bold mb-4 text-emerald-700">Tipos de Manutenção</h3>
          <ResponsiveContainer width="100%" height={250}>
            <BarChart data={dataTipo}>
              <CartesianGrid strokeDasharray="3 3" />
              <XAxis dataKey="name" />
              <YAxis allowDecimals={false} />
              <Bar dataKey="value" fill="#059669" />
              <RechartsTooltip />
              <Legend />
            </BarChart>
          </ResponsiveContainer>
        </div>
      </div>
      {/* Gráfico de estoque (opcional) */}
      <div className="bg-white rounded-xl shadow p-6 mx-8 mb-8">
        <h3 className="font-bold mb-4 text-emerald-700">Estoque de Peças</h3>
        <ResponsiveContainer width="100%" height={250}>
          <BarChart data={dataEstoque}>
            <CartesianGrid strokeDasharray="3 3" />
            <XAxis dataKey="nome" />
            <YAxis allowDecimals={false} />
            <Bar dataKey="quantidade" fill="#059669" name="Quantidade" />
            <Bar dataKey="minima" fill="#dc2626" name="Mínima" />
            <RechartsTooltip />
            <Legend />
          </BarChart>
        </ResponsiveContainer>
      </div>

      {/* Filtros e busca */}
      <div className="flex flex-wrap gap-4 items-center px-8 mb-4">
        <div className="relative">
          <input
            value={busca}
            onChange={e => setBusca(e.target.value)}
            placeholder="Buscar por equipamento, responsável ou tipo..."
            className="border rounded-lg p-2 pl-8 w-72 focus:outline-emerald-600"
          />
          <MagnifyingGlassIcon className="w-5 h-5 absolute left-2 top-2 text-gray-400" />
        </div>
        <select
          value={filtroStatus}
          onChange={e => setFiltroStatus(e.target.value)}
          className="border rounded-lg p-2"
        >
          <option value="">Todos os Status</option>
          <option value="Pendente">Pendente</option>
          <option value="Em Execução">Em Execução</option>
          <option value="Concluída">Concluída</option>
          <option value="Atrasada">Atrasada</option>
        </select>
        <select
          value={filtroTipo}
          onChange={e => setFiltroTipo(e.target.value)}
          className="border rounded-lg p-2"
        >
          <option value="">Todos os Tipos</option>
          <option value="Corretiva">Corretiva</option>
          <option value="Preventiva">Preventiva</option>
        </select>
        <button
          onClick={() => exportarCSV(manutencoesFiltradas)}
          className="bg-emerald-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-emerald-700 shadow"
        >
          Exportar CSV
        </button>
        <button
          onClick={() => exportarExcel(manutencoesFiltradas, estoque)}
          className="bg-emerald-600 text-white px-4 py-2 rounded-lg flex items-center gap-2 hover:bg-emerald-700 shadow"
        >
          Exportar Excel
        </button>
      </div>

      {/* Tabela analítica */}
      <div className="overflow-x-auto px-8 pb-8">
        <table className="min-w-full bg-white rounded-xl shadow">
          <thead>
            <tr className="bg-emerald-50 text-emerald-800">
              <th className="py-3 px-4 text-left">Equipamento</th>
              <th className="py-3 px-4 text-left">Responsável</th>
              <th className="py-3 px-4 text-left">Tipo</th>
              <th className="py-3 px-4 text-left">Status</th>
              <th className="py-3 px-4 text-left">Abertura</th>
              <th className="py-3 px-4 text-left">Descrição</th>
            </tr>
          </thead>
          <tbody>
            {manutencoesFiltradas.length === 0 && (
              <tr>
                <td colSpan={6} className="text-center text-gray-500 py-6">
                  Nenhuma ordem encontrada para os filtros selecionados.
                </td>
              </tr>
            )}
            {manutencoesFiltradas.map((m) => (
              <tr key={m.id} className="border-b hover:bg-emerald-50 transition">
                <td className="py-2 px-4">{m.equipamento}</td>
                <td className="py-2 px-4">{m.responsavel}</td>
                <td className="py-2 px-4">{m.tipo}</td>
                <td className="py-2 px-4">
                  <span className={`px-2 py-1 rounded-full text-xs font-bold
                    ${m.status === "Atrasada" ? "bg-red-100 text-red-700" :
                      m.status === "Concluída" ? "bg-emerald-100 text-emerald-800" :
                      m.status === "Em Execução" ? "bg-yellow-100 text-yellow-800" :
                      "bg-gray-100 text-gray-700"}`}>
                    {m.status}
                  </span>
                </td>
                <td className="py-2 px-4">{m.dataAbertura}</td>
                <td className="py-2 px-4">{m.descricao}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}