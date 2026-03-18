import { FileText, Gavel, Landmark, ShieldAlert } from "lucide-react";
import { useState } from "react";
import type { OfficerData, Report, Warrant } from "../../types/mdt";
import { reportSolved } from "../../hooks/useMdt";

export function Dashboard({ officer, reports, warrants, onIssueFine, onIssuePrison }: {
  officer: OfficerData;
  reports: Report[];
  warrants: Warrant[];
  onIssueFine: (payload: { passaporte: number; multas: number; texto: string; cnh?: number }) => Promise<void>;
  onIssuePrison: (payload: { passaporte: number; servicos: number; multas: number; texto: string; associacao?: string; material?: string; url?: string; militares?: string }) => Promise<void>;
}) {
  const [fineForm, setFineForm] = useState({ passaporte: "", multas: "", texto: "" });
  const [prisonForm, setPrisonForm] = useState({ passaporte: "", servicos: "", multas: "", texto: "", associacao: "", material: "Não", url: "", militares: "" });

  const recentReports = reports.slice(0, 5);
  const activeWarrants = warrants.slice(0, 5);

  return (
    <div className="p-8 space-y-6">
      <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
        <div className="xl:col-span-1 rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <div className="text-[#8B949E] text-sm mb-2">Oficial autenticado</div>
          <div className="text-2xl font-semibold">{officer.name}</div>
          <div className="mt-3 space-y-1 text-sm text-[#8B949E]">
            <div>Badge: <span className="text-white">{officer.badge}</span></div>
            <div>Patente: <span className="text-white">{officer.rank}</span></div>
            <div>Unidade: <span className="text-white">{officer.unit}</span></div>
            <div>Status: <span className="text-white">{officer.status}</span></div>
          </div>
        </div>

        <div className="xl:col-span-2 grid grid-cols-2 lg:grid-cols-4 gap-4">
          {[
            { label: "Relatórios", value: officer.stats.reports || reports.length, icon: FileText },
            { label: "Mandados", value: officer.stats.warrants || warrants.length, icon: Gavel },
            { label: "Prisões", value: officer.stats.arrests, icon: ShieldAlert },
            { label: "Multas", value: officer.stats.tickets, icon: Landmark },
          ].map((item) => (
            <div key={item.label} className="rounded-xl border border-[#21262D] bg-[#161B22] p-5">
              <item.icon className="w-5 h-5 text-[#58A6FF] mb-3" />
              <div className="text-2xl font-bold">{item.value}</div>
              <div className="text-sm text-[#8B949E]">{item.label}</div>
            </div>
          ))}
        </div>
      </div>

      <div className="grid grid-cols-1 2xl:grid-cols-2 gap-6">
        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4">Aplicar multa</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <input value={fineForm.passaporte} onChange={(e) => setFineForm((old) => ({ ...old, passaporte: e.target.value }))} placeholder="Passaporte" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <input value={fineForm.multas} onChange={(e) => setFineForm((old) => ({ ...old, multas: e.target.value }))} placeholder="Valor da multa" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <textarea value={fineForm.texto} onChange={(e) => setFineForm((old) => ({ ...old, texto: e.target.value }))} placeholder="Motivo da multa" className="md:col-span-2 min-h-28 bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <button onClick={() => void onIssueFine({ passaporte: Number(fineForm.passaporte), multas: Number(fineForm.multas), texto: fineForm.texto })} className="md:col-span-2 bg-[#1F6FEB] hover:bg-[#2f81f7] rounded-lg px-4 py-2">Registrar multa</button>
          </div>
        </div>

        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4">Efetuar prisão</h3>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-3">
            <input value={prisonForm.passaporte} onChange={(e) => setPrisonForm((old) => ({ ...old, passaporte: e.target.value }))} placeholder="Passaporte" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <input value={prisonForm.servicos} onChange={(e) => setPrisonForm((old) => ({ ...old, servicos: e.target.value }))} placeholder="Serviços" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <input value={prisonForm.multas} onChange={(e) => setPrisonForm((old) => ({ ...old, multas: e.target.value }))} placeholder="Multa" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <input value={prisonForm.associacao} onChange={(e) => setPrisonForm((old) => ({ ...old, associacao: e.target.value }))} placeholder="Associação" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <textarea value={prisonForm.texto} onChange={(e) => setPrisonForm((old) => ({ ...old, texto: e.target.value }))} placeholder="Motivo da prisão" className="md:col-span-2 min-h-28 bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
            <button onClick={() => void onIssuePrison({ passaporte: Number(prisonForm.passaporte), servicos: Number(prisonForm.servicos), multas: Number(prisonForm.multas), texto: prisonForm.texto, associacao: prisonForm.associacao, material: prisonForm.material, url: prisonForm.url, militares: prisonForm.militares })} className="md:col-span-2 bg-[#238636] hover:bg-[#2ea043] rounded-lg px-4 py-2">Efetuar prisão</button>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4">Relatórios recentes</h3>
          <div className="space-y-3">
            {recentReports.length ? recentReports.map((report) => (
              <div key={report.id} className="rounded-lg border border-[#21262D] bg-[#0D1117] p-4">
                <div className="flex items-center justify-between gap-3">
                  <div>
                    <div className="font-medium">{report.victim_name || "Sem nome"}</div>
                    <div className="text-sm text-[#8B949E]">Oficial: {report.police_name}</div>
                  </div>
                  <span className={`text-xs px-2 py-1 rounded ${reportSolved(report.solved) ? "bg-[#238636]" : "bg-[#D4AF37] text-[#0D1117]"}`}>{reportSolved(report.solved) ? "Resolvido" : "Pendente"}</span>
                </div>
                <div className="text-sm text-[#8B949E] mt-2">{report.created_at}</div>
              </div>
            )) : <div className="text-[#8B949E]">Nenhum relatório encontrado.</div>}
          </div>
        </div>

        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4">Mandados ativos</h3>
          <div className="space-y-3">
            {activeWarrants.length ? activeWarrants.map((warrant) => (
              <div key={warrant.id} className="rounded-lg border border-[#21262D] bg-[#0D1117] p-4">
                <div className="flex items-center justify-between gap-3">
                  <div>
                    <div className="font-medium">{warrant.identity}</div>
                    <div className="text-sm text-[#8B949E]">Passaporte: {warrant.user_id} • Oficial: {warrant.nidentity}</div>
                  </div>
                  <span className="text-xs px-2 py-1 rounded bg-[#DA3633]">{warrant.status}</span>
                </div>
                <div className="text-sm text-[#8B949E] mt-2 line-clamp-2">{warrant.reason}</div>
              </div>
            )) : <div className="text-[#8B949E]">Nenhum mandado ativo.</div>}
          </div>
        </div>
      </div>
    </div>
  );
}
