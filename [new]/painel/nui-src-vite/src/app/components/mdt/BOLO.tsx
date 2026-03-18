import { AlertTriangle, Trash2 } from "lucide-react";
import type { Warrant } from "../../types/mdt";

export function BOLO({ warrants, onRemove }: { warrants: Warrant[]; onRemove: (id: number) => Promise<void>; }) {
  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-white font-semibold text-2xl flex items-center gap-2"><AlertTriangle className="w-6 h-6" /> BOLO</h2>
        <p className="text-[#8B949E] text-sm mt-1">Usei os mandados ativos como feed operacional do BOLO para a nova NUI não ficar ornamental de enfeite.</p>
      </div>
      <div className="space-y-4">
        {warrants.length ? warrants.map((warrant) => (
          <div key={warrant.id} className="bg-[#161B22] rounded-lg border-l-4 border-[#DA3633] p-5">
            <div className="flex items-start justify-between gap-4">
              <div>
                <div className="text-[#1F6FEB] font-semibold text-sm">BOLO #{warrant.id}</div>
                <h3 className="text-white font-semibold text-lg mt-1">{warrant.identity}</h3>
                <p className="text-[#8B949E] text-sm mt-2">{warrant.reason}</p>
                <div className="text-xs text-[#8B949E] mt-3">Passaporte: {warrant.user_id} • Oficial: {warrant.nidentity} • {warrant.timeStamp}</div>
              </div>
              <button onClick={() => void onRemove(warrant.id)} className="p-2 rounded bg-[#DA3633] hover:bg-[#e34c47]"><Trash2 className="w-4 h-4" /></button>
            </div>
          </div>
        )) : <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6 text-[#8B949E]">Nenhum BOLO ativo.</div>}
      </div>
    </div>
  );
}
