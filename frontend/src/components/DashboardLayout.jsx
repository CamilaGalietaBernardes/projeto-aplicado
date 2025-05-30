import { useNavigate } from "react-router-dom";
import { useState, useEffect } from "react";
import { listarNotificacoes } from "../services/notificacoesService";
import { Menu, Package, Wrench, LogOut, Bell } from "lucide-react";
import { useAuth } from "../contexts/AuthContext";


const DashboardLayout = ({ children }) => {
  const navigate = useNavigate();
  const [menuAberto, setMenuAberto] = useState(false);
  const [notificacoes, setNotificacoes] = useState(listarNotificacoes());
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
    const interval = setInterval(() => {
      setNotificacoes(listarNotificacoes());
    }, 2000);
    return () => clearInterval(interval);
  }, []);

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
                onClick={toggleAlertas}
                className="hover:bg-emerald-700 px-3 py-2 rounded relative"
                title="Ver notificações"
              >
                <Bell size={24} />
                {notificacoes.length > 0 && (
                  <span className="absolute top-0 right-0 block h-2 w-2 rounded-full bg-red-500"></span>
                )}
              </button>

              {/* Popup de Alertas */}
              {mostrarAlertas && (
                <div className="absolute right-0 mt-2 w-64 bg-white dark:bg-gray-800 shadow-lg rounded-md p-4 text-black dark:text-white z-50">
                  <h2 className="font-bold mb-2">Notificações</h2>
                  {notificacoes.map((notificacao) => (
                    <div key={notificacao.id} className="mb-2">
                      {notificacao.mensagem}
                    </div>
                  ))}
                  {notificacoes.length === 0 && (
                    <div className="text-gray-500">Sem novas notificações</div>
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
            <button onClick={toggleAlertas} title="Ver notificações">
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

export default DashboardLayout;
