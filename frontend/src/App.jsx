import { BrowserRouter, Routes, Route } from "react-router-dom";
import Login from "./pages/Login";
import Estoque from "./pages/Estoque";
import Manutencao from "./pages/Manutencao";
import Relatorios from "./pages/Relatorios";
import RotaProtegida from "./components/RotaProtegida";
import DashboardLayout from "./components/DashboardLayout";

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/login" element={<Login />} />
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
          path="/"
          element={
            <RotaProtegida>
              <DashboardLayout>
                <Manutencao />
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
