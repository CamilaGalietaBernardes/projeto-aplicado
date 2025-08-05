import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { FaTools } from "react-icons/fa";
import CadastroModal from "../components/CadastroModal";
import { LockClosedIcon, UserIcon, EyeIcon, EyeSlashIcon } from "@heroicons/react/24/outline";
import { autenticar, cadastrarUsuario } from "../services/authService";
import { useAuth } from "../contexts/AuthContext";
import toast from "react-hot-toast";

const Login = () => {
  const [usuario, setUsuario] = useState("");
  const [senha, setSenha] = useState("");
  const [showSenha, setShowSenha] = useState(false);
  const [loading, setLoading] = useState(false);
  const [erro, setErro] = useState("");
  const [modalCadastro, setModalCadastro] = useState(false);
  const { login } = useAuth();
  const navigate = useNavigate();

  const handleCadastrar = async (dados) => {
    try {
      await cadastrarUsuario({
        nome: dados.nome,
        email: dados.email,
        funcao: dados.funcao,
        setor: dados.setor,
        senha: dados.senha
      });
      toast.success("Usuário cadastrado com sucesso!");
      setModalCadastro(false);
    } catch (e) {
      toast.error(e.message);
    }
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    if (modalCadastro) return;
    setErro("");
    setLoading(true);
    try {
      const usuarioEncontrado = await autenticar(usuario, senha);
      login(usuarioEncontrado); // Atualiza o contexto
      navigate("/", { replace: true });
    } catch (err) {
      setErro(err.message);
    }
    setLoading(false);
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-emerald-100 to-emerald-300">
      <form
        onSubmit={handleLogin}
        className="bg-white shadow-xl rounded-2xl p-10 w-full max-w-md flex flex-col gap-6 animate-slide-down"
      >
        <div className="flex flex-col items-center gap-2 mb-2">
          <FaTools size={64} className="text-emerald-600" />
          <h2 className="text-2xl font-bold text-emerald-700">Bem-vindo!</h2>
          <span className="text-gray-500 text-sm">Acesse sua conta para continuar</span>
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-1">Usuário</label>
          <div className="relative">
            <UserIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
            <input
              value={usuario}
              onChange={e => setUsuario(e.target.value)}
              placeholder="Digite seu usuário"
              className="w-full pl-10 pr-3 py-2 border rounded-lg focus:outline-emerald-600"
              autoFocus
            />
          </div>
        </div>
        <div>
          <label className="block text-gray-700 font-medium mb-1">Senha</label>
          <div className="relative">
            <LockClosedIcon className="w-5 h-5 absolute left-3 top-2.5 text-gray-400" />
            <input
              type={showSenha ? "text" : "password"}
              value={senha}
              onChange={e => setSenha(e.target.value)}
              placeholder="Digite sua senha"
              className="w-full pl-10 pr-10 py-2 border rounded-lg focus:outline-emerald-600"
            />
            <button
              type="button"
              tabIndex={-1}
              className="absolute right-3 top-2.5 text-gray-400 hover:text-emerald-600"
              onClick={() => setShowSenha(s => !s)}
            >
              {showSenha ? <EyeSlashIcon className="w-5 h-5" /> : <EyeIcon className="w-5 h-5" />}
            </button>
          </div>
        </div>
        {erro && <div className="text-red-500 text-sm text-center">{erro}</div>}
        <button
          type="submit"
          className="w-full bg-emerald-600 text-white py-2 rounded-lg font-semibold hover:bg-emerald-700 transition flex items-center justify-center"
          disabled={loading || modalCadastro}
        >
          {loading ? (
            <>
              <svg className="animate-spin h-5 w-5 mr-2 text-white" viewBox="0 0 24 24">
                <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4" fill="none"/>
                <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
              </svg>
              Entrando...
            </>
          ) : "Entrar"}
        </button>
        <button
          type="button"
          className="w-full mt-2 bg-white border border-emerald-600 text-emerald-700 py-2 rounded-lg font-semibold hover:bg-emerald-50 transition"
          onClick={() => setModalCadastro(true)}
        >
          Cadastrar
        </button>
        <div className="text-xs text-gray-400 text-center mt-2">
          © {new Date().getFullYear()} SENAI Vitória
        </div>
      </form>
      <CadastroModal
        open={modalCadastro}
        onClose={() => setModalCadastro(false)}
        onCadastrar={handleCadastrar}
      />
    </div>
  );
};

export default Login;