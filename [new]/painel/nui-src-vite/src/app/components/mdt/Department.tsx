import type React from "react";
import { Building2, Shield, Calendar, BadgeInfo } from "lucide-react";
import type { OfficerData } from "../../types/mdt";

export function Department({ officer }: { officer: OfficerData }) {
  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-white font-semibold text-2xl flex items-center gap-2"><Building2 className="w-6 h-6" /> Departamento</h2>
        <p className="text-[#8B949E] text-sm mt-1">Resumo institucional encaixado na tua NUI nova.</p>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Info icon={<Shield className="w-5 h-5 text-[#58A6FF]" />} label="Unidade" value={officer.unit} />
        <Info icon={<BadgeInfo className="w-5 h-5 text-[#58A6FF]" />} label="Badge" value={officer.badge} />
        <Info icon={<Calendar className="w-5 h-5 text-[#58A6FF]" />} label="Ingresso" value={officer.joinDate} />
        <Info icon={<Building2 className="w-5 h-5 text-[#58A6FF]" />} label="Patente" value={officer.rank} />
      </div>
      <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6 text-[#8B949E] leading-relaxed">
        Este painel foi convertido de um MDT antigo em HTML/jQuery para uma NUI em Vite/React. Em outras palavras: tiramos o motor de um fusca teimoso e soldamos num cockpit novo sem deixar o carro explodir.
      </div>
    </div>
  );
}

function Info({ icon, label, value }: { icon: React.ReactNode; label: string; value: string }) {
  return <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-5">{icon}<div className="text-[#8B949E] text-sm mt-2">{label}</div><div className="text-lg font-semibold mt-1">{value}</div></div>;
}
