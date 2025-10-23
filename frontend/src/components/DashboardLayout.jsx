import { useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";
import { Menu, Package, Wrench, LogOut, Bell, CheckCircle, AlertTriangle } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";
import { buscarNotificacoesEstoque } from "../services/EstoqueNotificacoesApi";



const DashboardLayout = ({ children }) => {
  const navigate = useNavigate();
  const [menuAberto, setMenuAberto] = useState(false);
  const [notificacoes, setNotificacoes] = useState([]);
  const [mostrarAlertas, setMostrarAlertas] = useState(false);
  const { logout } = useAuth();
  const { usuario } = useAuth();

  const toggleMenu = () => {
    setMenuAberto(!menuAberto);
  };

  const toggleAlertas = () => {
    setMostrarAlertas(!mostrarAlertas);
  };

 useEffect(() => {
  const atualizarNotificacoes = async () => {
    try {
      const alertas = await buscarNotificacoesEstoque();
      setNotificacoes(alertas);
    } catch (error) {
      console.error("Erro ao buscar notificações do estoque:", error);
      setNotificacoes([]);
    }
  };

  atualizarNotificacoes();

  const interval = setInterval(atualizarNotificacoes, 5000);

  return () => clearInterval(interval);
}, []);

useEffect(() => {
  const handleClickOutside = (event) => {
    if (mostrarAlertas && !event.target.closest('.popup-notificacoes')) {
      setMostrarAlertas(false);
    }
  };

  document.addEventListener('click', handleClickOutside);
  return () => document.removeEventListener('click', handleClickOutside);
}, [mostrarAlertas]);

const navigateToItem = (notificacao) => {
  const nome = notificacao.nome_peca || notificacao.item || notificacao.mensagem;
  navigate(`/estoque?abrirPeca=${notificacao.id}`);
  setMostrarAlertas(false);
};
  return (
    <div>
      <div className="flex flex-col min-h-screen bg-gray-100 dark:bg-gray-900 dark:text-white transition-colors">
        {/* Navbar */}
        <header className="bg-emerald-600 dark:bg-emerald-800 text-white flex items-center justify-between px-6 py-4 shadow-md relative">
          <div className="flex items-center gap-4">
            <h1
              className="text-2xl font-bold cursor-pointer"
              onClick={() => navigate("/estoque")}
            >
              Sistema de Manutenção
            </h1>

            {/* Menu Desktop */}
            <nav className="hidden md:flex gap-4 ml-6">
              <button
                onClick={() => navigate("/manutencao")}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded"
              >
                <Wrench size={18} /> Manutenção
              </button>
              <button
                onClick={() => navigate("/estoque")}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded"
              >
                <Package size={18} /> Estoque
              </button>
              <button
                onClick={() => navigate("/relatorios")}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded"
              >
                📊 Relatórios
              </button>
            </nav>
          </div>

          {/* Botões Desktop */}
          <div className="hidden md:flex items-center gap-4 relative">
            {/* Nome do Usuário */}
            {usuario && (
              <span className="font-semibold text-white bg-emerald-700 px-3 py-1 rounded-lg">
                Bem-vindo, {usuario.nome}
              </span>
            )}
            {/* Botão de Notificações */}
            <div className="relative">
              <button
                  onClick={(e) => {
                  e.stopPropagation(); // IMPEDIR PROPAGAÇÃO
                  toggleAlertas();
                }}
                className="hover:bg-emerald-700 px-3 py-2 rounded relative"
                title="Ver notificações"
              >
                <Bell size={24} />
                {notificacoes.length > 0 && (
                  <span className="absolute -top-1 -right-1 bg-red-600 text-white text-xs font-bold rounded-full w-5 h-5 flex items-center justify-center">
                    {notificacoes.length}
                  </span>
                )}
              </button>

              {/* Popup de Alertas */}
              {mostrarAlertas && (
                <div
                  className="popup-notificacoes absolute right-0 mt-2 w-80 bg-white dark:bg-gray-800 shadow-lg rounded-lg p-4 text-black dark:text-white z-50 animate-slide-down"
                  onClick={(e) => e.stopPropagation()}
                >
                  <h2 className="font-bold mb-3 border-b border-gray-300 dark:border-gray-700 pb-1">
                    Notificações
                  </h2>

                  {notificacoes.length > 0 ? (
                    [...notificacoes]
                      .sort((a, b) => a.id - b.id)
                      .map((n) => {
                        const itemName = n.mensagem;
                        return (
                          <div
                            key={n.id}
                            role="button"
                            tabIndex={0}
                            onKeyDown={(e) => {
                              if (e.key === "Enter" || e.key === " ") {
                                navigateToItem(n);
                              }
                            }}
                            onClick={() => navigateToItem(n)}
                            className="group flex items-start gap-3 p-2 mb-2 rounded-md cursor-pointer transform transition duration-200 ease-out
                                      hover:translate-x-1 hover:shadow-md hover:bg-emerald-50 dark:hover:bg-emerald-800 focus:outline-none focus:ring-2 focus:ring-emerald-400
                                      border-b border-gray-300 dark:border-gray-700"
                            title={itemName}
                          > 
                           <AlertTriangle size={18} className="flex-shrink-0 text-yellow-500 mt-1" />

                            <div className="flex-1 min-w-0">
                              <div className="flex items-center justify-between">
                                <span className="font-medium text-sm truncate">{n.nome_peca}</span>
                                {n.quantidade_restante !== undefined && (
                                  <span className="text-xs text-gray-500 dark:text-gray-400 ml-2">
                                    ({n.qtd_min} un.)
                                  </span>
                                )}
                              </div>
                              <p className="font-medium text-xs text-gray-600 dark:text-gray-300 mt-1 truncate group-hover:whitespace-normal 
                                            group-hover:overflow-visible group-hover:text-clip transition-all duration-200">
                                {n.mensagem}
                              </p>
                            </div>
                            {/* Botão que aparece só no hover */}
                            <button
                              onClick={(e) => {
                                e.stopPropagation(); // evita acionar o onClick do container duas vezes
                                navigateToItem(n);
                              }}
                              aria-label={`Ver ${itemName}`}
                              className="ml-2 mt-3 opacity-0 group-hover:opacity-100 transform translate-x-1 group-hover:translate-x-0
                                        transition duration-200 text-sm px-2 py-2 rounded bg-emerald-600 hover:bg-emerald-700 text-white"
                            >
                              Ver
                            </button>
                          </div>
                        );
                      })
                  ) : (
                    <div className="text-gray-500 text-sm">Sem novas notificações</div>
                  )}
                </div>
              )}
            </div>

            {/* Botão de Logout */}
            <button
              onClick={ logout }
              className="bg-red-500 hover:bg-red-600 px-4 py-2 rounded font-semibold flex items-center gap-2"
            >
              <LogOut size={18} /> Sair
            </button>
          </div>

          {/* Botão hambúrguer no mobile */}
          <div className="md:hidden flex items-center gap-3">
            <button
              onClick={(e) => {
                e.stopPropagation(); // IMPEDIR PROPAGAÇÃO
                toggleAlertas();
              }}
              title="Ver notificações"
            >
              <Bell size={24} />
              {notificacoes.length > 0 && (
                <span className="absolute top-2 right-2 block h-2 w-2 rounded-full bg-red-500"></span>
              )}
            </button>

            <button onClick={toggleMenu}>
              <Menu size={28} />
            </button>
          </div>

          {/* Menu Mobile */}
          {menuAberto && (
            <div className="absolute top-full left-0 w-full bg-emerald-600 dark:bg-emerald-800 flex flex-col items-center py-4 md:hidden z-50 animate-slide-down">
              <button
                onClick={() => {
                  navigate("/manutencao");
                  setMenuAberto(false);
                }}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded w-full text-center"
              >
                <Wrench size={18} /> Manutenção
              </button>
              <button
                onClick={() => {
                  navigate("/estoque");
                  setMenuAberto(false);
                }}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded w-full text-center"
              >
                <Package size={18} /> Estoque
              </button>
              <button
                onClick={() => {
                  navigate("/relatorios");
                  setMenuAberto(false);
                }}
                className="flex items-center gap-2 hover:bg-emerald-700 px-4 py-2 rounded w-full text-center"
              >
                📊 Relatórios
              </button>
              <button
                onClick={() => {
                  handleLogout();
                  setMenuAberto(false);
                }}
                className="flex items-center gap-2 bg-red-500 hover:bg-red-600 px-4 py-2 rounded w-full text-center mt-2"
              >
                <LogOut size={18} /> Sair
              </button>
            </div>
          )}
        </header>

        {/* Conteúdo Principal */}
        <main className="flex-1 p-6">{children}</main>
      </div>
    </div>
  );
};

const styles = `
  @keyframes slide-down {
    from { transform: translateY(-10px); opacity: 0; }
    to { transform: translateY(0); opacity: 1; }
  }

  .animate-slide-down {
    animation: slide-down 0.3s ease-out;
  }
`;

if (typeof document !== 'undefined') {
  const styleSheet = document.createElement("style");
  styleSheet.innerText = styles;
  document.head.appendChild(styleSheet);
}
export default DashboardLayout;
