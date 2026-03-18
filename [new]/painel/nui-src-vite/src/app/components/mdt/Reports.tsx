import { useState } from "react";
import { Plus, Check, Trash2, X } from "lucide-react";
import type { Report } from "../../types/mdt";
import { reportSolved } from "../../hooks/useMdt";

export function Reports({ reports, onCreate, onSolve, onRemove }: {
  reports: Report[];
  onCreate: (payload: { victim_id: string; victim_name: string; victim_report: string }) => Promise<void>;
  onSolve: (id: number) => Promise<void>;
  onRemove: (id: number) => Promise<void>;
}) {
  const [showCreateModal, setShowCreateModal] = useState(false);
  const [form, setForm] = useState({ victim_id: "", victim_name: "", victim_report: "" });

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <h2 className="text-white font-semibold text-2xl">Relatórios</h2>
        <button onClick={() => setShowCreateModal(true)} className="flex items-center gap-2 px-4 py-2 bg-[#1F6FEB] hover:bg-[#2f81f7] text-white rounded-lg transition-colors">
          <Plus className="w-4 h-4" /> Criar Relatório
        </button>
      </div>

      <div className="bg-[#161B22] rounded-lg border border-[#21262D] overflow-hidden">
        <table className="w-full">
          <thead>
            <tr className="bg-[#0D1117] border-b border-[#21262D]">
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">ID</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Vítima</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Oficial</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Status</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Data</th>
              <th className="text-right text-[#8B949E] text-xs font-semibold p-4">Ações</th>
            </tr>
          </thead>
          <tbody>
            {reports.map((report) => (
              <tr key={report.id} className="border-b border-[#21262D] hover:bg-[#1C2128] align-top">
                <td className="text-[#1F6FEB] font-semibold text-sm p-4">#{report.id}</td>
                <td className="text-white text-sm p-4">
                  <div>{report.victim_name}</div>
                  <div className="text-[#8B949E] text-xs mt-1">Passaporte: {report.victim_id}</div>
                  <div className="text-[#8B949E] text-xs mt-2 max-w-[420px] whitespace-pre-wrap">{report.victim_report}</div>
                </td>
                <td className="text-white text-sm p-4">{report.police_name}</td>
                <td className="p-4"><span className={`text-xs px-3 py-1 rounded ${reportSolved(report.solved) ? "bg-[#238636] text-white" : "bg-[#D4AF37] text-[#0D1117]"}`}>{reportSolved(report.solved) ? "Resolvido" : "Pendente"}</span></td>
                <td className="text-[#8B949E] text-sm p-4">{report.created_at}</td>
                <td className="p-4">
                  <div className="flex justify-end gap-2">
                    {!reportSolved(report.solved) ? <button onClick={() => void onSolve(report.id)} className="p-2 rounded bg-[#238636] hover:bg-[#2ea043]"><Check className="w-4 h-4" /></button> : null}
                    <button onClick={() => void onRemove(report.id)} className="p-2 rounded bg-[#DA3633] hover:bg-[#e34c47]"><Trash2 className="w-4 h-4" /></button>
                  </div>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {showCreateModal && (
        <div className="fixed inset-0 bg-black/80 flex items-center justify-center z-50">
          <div className="bg-[#161B22] rounded-lg border border-[#21262D] w-[720px] max-w-[95vw]">
            <div className="flex items-center justify-between p-6 border-b border-[#21262D]">
              <h3 className="text-white font-semibold text-xl">Criar novo relatório</h3>
              <button onClick={() => setShowCreateModal(false)} className="text-[#8B949E] hover:text-white"><X className="w-6 h-6" /></button>
            </div>
            <div className="p-6 space-y-4">
              <input value={form.victim_id} onChange={(e) => setForm((old) => ({ ...old, victim_id: e.target.value }))} placeholder="Passaporte da vítima" className="w-full bg-[#0D1117] border border-[#21262D] rounded px-3 py-2" />
              <input value={form.victim_name} onChange={(e) => setForm((old) => ({ ...old, victim_name: e.target.value }))} placeholder="Nome da vítima" className="w-full bg-[#0D1117] border border-[#21262D] rounded px-3 py-2" />
              <textarea value={form.victim_report} onChange={(e) => setForm((old) => ({ ...old, victim_report: e.target.value }))} placeholder="Descreva o ocorrido" className="w-full min-h-48 bg-[#0D1117] border border-[#21262D] rounded px-3 py-2" />
              <button onClick={async () => { await onCreate(form); setShowCreateModal(false); setForm({ victim_id: "", victim_name: "", victim_report: "" }); }} className="w-full bg-[#1F6FEB] hover:bg-[#2f81f7] rounded-lg px-4 py-3">Salvar relatório</button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
