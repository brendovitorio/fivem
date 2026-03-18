import { Gavel, Plus, Trash2 } from "lucide-react";
import { useState } from "react";
import type { Warrant } from "../../types/mdt";

export function Warrants({ warrants, onCreate, onRemove }: {
  warrants: Warrant[];
  onCreate: (payload: { passaporte: number; nome: string; texto: string }) => Promise<void>;
  onRemove: (id: number) => Promise<void>;
}) {
  const [form, setForm] = useState({ passaporte: "", nome: "", texto: "" });

  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-white font-semibold text-2xl flex items-center gap-2"><Gavel className="w-6 h-6" /> Warrants</h2>
        <p className="text-[#8B949E] text-sm mt-1">Mandados ativos registrados no MDT.</p>
      </div>

      <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-3 mb-3">
          <input value={form.passaporte} onChange={(e) => setForm((old) => ({ ...old, passaporte: e.target.value }))} placeholder="Passaporte" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
          <input value={form.nome} onChange={(e) => setForm((old) => ({ ...old, nome: e.target.value }))} placeholder="Nome" className="bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
          <button onClick={() => void onCreate({ passaporte: Number(form.passaporte), nome: form.nome, texto: form.texto })} className="flex items-center justify-center gap-2 bg-[#1F6FEB] hover:bg-[#2f81f7] rounded-lg px-4 py-2"><Plus className="w-4 h-4" />Adicionar</button>
        </div>
        <textarea value={form.texto} onChange={(e) => setForm((old) => ({ ...old, texto: e.target.value }))} placeholder="Motivo do mandado" className="w-full min-h-28 bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
      </div>

      <div className="bg-[#161B22] rounded-lg border border-[#21262D] overflow-hidden">
        <table className="w-full">
          <thead>
            <tr className="bg-[#0D1117] border-b border-[#21262D]">
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">ID</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Suspeito</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Oficial</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Status</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Data</th>
              <th className="text-right text-[#8B949E] text-xs font-semibold p-4">Ação</th>
            </tr>
          </thead>
          <tbody>
            {warrants.map((warrant) => (
              <tr key={warrant.id} className="border-b border-[#21262D] hover:bg-[#1C2128]">
                <td className="text-[#1F6FEB] font-semibold text-sm p-4">#{warrant.id}</td>
                <td className="text-white text-sm p-4"><div>{warrant.identity}</div><div className="text-[#8B949E] text-xs mt-1">Passaporte: {warrant.user_id}</div><div className="text-[#8B949E] text-xs mt-2 max-w-[420px]">{warrant.reason}</div></td>
                <td className="text-white text-sm p-4">{warrant.nidentity}</td>
                <td className="p-4"><span className="text-xs px-3 py-1 rounded bg-[#DA3633] text-white">{warrant.status}</span></td>
                <td className="text-[#8B949E] text-sm p-4">{warrant.timeStamp}</td>
                <td className="p-4"><div className="flex justify-end"><button onClick={() => void onRemove(warrant.id)} className="p-2 rounded bg-[#DA3633] hover:bg-[#e34c47]"><Trash2 className="w-4 h-4" /></button></div></td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
