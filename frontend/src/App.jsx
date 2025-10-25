import { BrowserRouter, Routes, Route } from "react-router-dom";
import { Toaster } from "react-hot-toast";
import Login from "./pages/Login";
import Estoque from "./pages/Estoque";
import Manutencao from "./pages/Manutencao";
import Relatorios from "./pages/Relatorios";
import RotaProtegida from "./components/RotaProtegida";
import DashboardLayout from "./components/DashboardLayout";
import Home from './pages/Home';

function App() {
  return (
    <BrowserRouter>
      <Toaster position="top-right" reverseOrder={false} />
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route
          path="/"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Home />
              </DashboardLayout>
            </RotaProtegida>
          }
        />
        <Route
          path="/home"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Home />
              </DashboardLayout>
            </RotaProtegida>
          }
        />
        <Route
          path="/estoque"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Estoque />
              </DashboardLayout>
            </RotaProtegida>
          }
        />
        <Route
          path="/manutencao"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Manutencao />
              </DashboardLayout>
            </RotaProtegida>
          }
        />
        <Route
          path="/relatorios"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Relatorios />
              </DashboardLayout>
            </RotaProtegida>
          }
        />
        <Route path="*" element={<Login />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
