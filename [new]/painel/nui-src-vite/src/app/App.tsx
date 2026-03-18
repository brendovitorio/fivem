import { useState } from "react";
import { Header } from "./components/mdt/Header";
import { Sidebar } from "./components/mdt/Sidebar";
import { Dashboard } from "./components/mdt/Dashboard";
import { Administration } from "./components/mdt/Administration";
import { Reports } from "./components/mdt/Reports";
import { BOLO } from "./components/mdt/BOLO";
import { Warrants } from "./components/mdt/Warrants";
import { Civilians } from "./components/mdt/Civilians";
import { Vehicles } from "./components/mdt/Vehicles";
import { PenalCode } from "./components/mdt/PenalCode";
import { Department } from "./components/mdt/Department";
import { useMdt } from "./hooks/useMdt";

export default function App() {
  const [activeView, setActiveView] = useState("dashboard");
  const mdt = useMdt();

  const renderContent = () => {
    switch (activeView) {
      case "dashboard":
        return <Dashboard officer={mdt.officer} reports={mdt.reports} warrants={mdt.warrants} onIssueFine={mdt.issueFine} onIssuePrison={mdt.issuePrison} />;
      case "civis":
        return <Civilians onSearch={mdt.searchCivilian} result={mdt.searchResult} onIssueFine={mdt.issueFine} onIssuePrison={mdt.issuePrison} />;
      case "veiculos":
        return <Vehicles />;
      case "relatorios":
        return <Reports reports={mdt.reports} onCreate={mdt.createReport} onSolve={mdt.solveReport} onRemove={mdt.removeReport} />;
      case "bolo":
        return <BOLO warrants={mdt.warrants} onRemove={mdt.removeWarrant} />;
      case "warrants":
        return <Warrants warrants={mdt.warrants} onCreate={mdt.createWarrant} onRemove={mdt.removeWarrant} />;
      case "codigo-penal":
        return <PenalCode />;
      case "departamento":
        return <Department officer={mdt.officer} />;
      case "administracao":
        return <Administration officer={mdt.officer} stats={mdt.stats} />;
      default:
        return <Dashboard officer={mdt.officer} reports={mdt.reports} warrants={mdt.warrants} onIssueFine={mdt.issueFine} onIssuePrison={mdt.issuePrison} />;
    }
  };

  if (!mdt.visible) return null;

  return (
    <div className="h-screen w-screen bg-[#0D1117] flex flex-col overflow-hidden text-white">
      <Header officer={mdt.officer} notifications={mdt.warrants.length + mdt.reports.length} onClose={mdt.close} onRefresh={mdt.refresh} />
      <div className="flex flex-1 overflow-hidden">
        <Sidebar activeItem={activeView} onItemClick={setActiveView} isSuperior={mdt.officer.isSuperior} />
        <main className="flex-1 overflow-y-auto bg-[#0D1117]">
          {mdt.error ? <div className="m-8 rounded-lg border border-red-500/30 bg-red-500/10 p-4 text-red-200">{mdt.error}</div> : null}
          {mdt.loading ? <div className="m-8 rounded-lg border border-[#21262D] bg-[#161B22] p-4 text-[#8B949E]">Carregando MDT...</div> : renderContent()}
        </main>
      </div>
    </div>
  );
}
