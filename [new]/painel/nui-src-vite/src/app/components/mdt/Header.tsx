import { Bell, RefreshCw, Search, Shield, X } from "lucide-react";
import type { OfficerData } from "../../types/mdt";

export function Header({ officer, notifications, onClose, onRefresh }: { officer: OfficerData; notifications: number; onClose: () => void; onRefresh: () => void; }) {
  return (
    <header className="h-20 border-b border-[#21262D] bg-[#161B22] px-6 flex items-center justify-between">
      <div className="flex items-center gap-4 min-w-0">
        <div className="w-12 h-12 rounded-xl bg-[#1F6FEB]/15 border border-[#1F6FEB]/30 flex items-center justify-center">
          <Shield className="w-6 h-6 text-[#58A6FF]" />
        </div>
        <div className="min-w-0">
          <div className="text-white font-semibold truncate">Revolt Police MDT</div>
          <div className="text-[#8B949E] text-sm truncate">{officer.name} • Badge {officer.badge} • {officer.rank}</div>
        </div>
      </div>

      <div className="flex items-center gap-3">
        <div className="hidden md:flex items-center bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2 min-w-[280px]">
          <Search className="w-4 h-4 text-[#8B949E] mr-2" />
          <input readOnly value="Busca rápida disponível nas abas" className="w-full bg-transparent text-sm text-[#8B949E] outline-none" />
        </div>
        <button onClick={onRefresh} className="p-2 rounded-lg bg-[#0D1117] border border-[#21262D] hover:border-[#1F6FEB] transition-colors" title="Atualizar">
          <RefreshCw className="w-4 h-4" />
        </button>
        <div className="relative p-2 rounded-lg bg-[#0D1117] border border-[#21262D]">
          <Bell className="w-4 h-4" />
          <span className="absolute -top-1 -right-1 min-w-5 h-5 px-1 rounded-full bg-[#DA3633] text-[10px] flex items-center justify-center">{notifications}</span>
        </div>
        <button onClick={onClose} className="p-2 rounded-lg bg-[#0D1117] border border-[#21262D] hover:border-[#DA3633] transition-colors" title="Fechar MDT">
          <X className="w-4 h-4" />
        </button>
      </div>
    </header>
  );
}
