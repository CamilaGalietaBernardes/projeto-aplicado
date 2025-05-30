import { useState } from "react";

const FiltroRelatorios = () => {
  const [dataInicio, setDataInicio] = useState("");
  const [dataFim, setDataFim] = useState("");
  const [equipamento, setEquipamento] = useState("");

  const aplicarFiltro = () => {
    console.log("Filtrando relatórios entre:", dataInicio, "e", dataFim, "para o equipamento:", equipamento);
    // Aqui depois você pode integrar com API ou filtrar localmente os dados
  };

  return (
    <div className="flex flex-col md:flex-row gap-4 mb-6">
      <input
        type="date"
        value={dataInicio}
        onChange={(e) => setDataInicio(e.target.value)}
        className="border p-2 rounded-md w-full md:w-auto"
      />
      <input
        type="date"
        value={dataFim}
        onChange={(e) => setDataFim(e.target.value)}
        className="border p-2 rounded-md w-full md:w-auto"
      />
      <input
        type="text"
        placeholder="Nome do equipamento"
        value={equipamento}
        onChange={(e) => setEquipamento(e.target.value)}
        className="border p-2 rounded-md w-full md:w-auto"
      />
      <button
        onClick={aplicarFiltro}
        className="bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2 rounded-md font-semibold"
      >
        Aplicar Filtro
      </button>
    </div>
  );
};

export default FiltroRelatorios;
