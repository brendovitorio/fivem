import type React from "react";
import { ShieldCheck, Users, FileText, Gavel } from "lucide-react";
import type { OfficerData } from "../../types/mdt";

export function Administration({ officer, stats }: { officer: OfficerData; stats: { totalReports: number; solvedReports: number; totalWarrants: number } }) {
  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-white font-semibold text-2xl flex items-center gap-2"><ShieldCheck className="w-6 h-6" /> Administração</h2>
        <p className="text-[#8B949E] text-sm mt-1">Painel resumido para superiores. Sem teatro corporativo, só o que importa.</p>
      </div>
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4">
        <Card title="Oficial" value={officer.name} />
        <Card title="Patente" value={officer.rank} />
        <Card title="Relatórios" value={String(stats.totalReports)} icon={<FileText className="w-5 h-5 text-[#58A6FF]" />} />
        <Card title="Mandados" value={String(stats.totalWarrants)} icon={<Gavel className="w-5 h-5 text-[#58A6FF]" />} />
      </div>
      <div className="grid grid-cols-1 xl:grid-cols-2 gap-6">
        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4 flex items-center gap-2"><Users className="w-5 h-5 text-[#58A6FF]" /> Hierarquia usada na NUI</h3>
          <div className="space-y-3 text-sm text-[#8B949E]">
            <p>• Superior: acesso à aba Administração.</p>
            <p>• Operacional: acesso a civis, relatórios, multas, prisões e mandados.</p>
            <p>• A permissão real continua no servidor/core. Front bonito sem backend é só maquiagem cara.</p>
          </div>
        </div>
        <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-6">
          <h3 className="text-lg font-semibold mb-4">Eficiência operacional</h3>
          <div className="space-y-3 text-sm text-[#8B949E]">
            <p>Relatórios resolvidos: <span className="text-white">{stats.solvedReports}</span></p>
            <p>Relatórios pendentes: <span className="text-white">{stats.totalReports - stats.solvedReports}</span></p>
            <p>Mandados ativos: <span className="text-white">{stats.totalWarrants}</span></p>
          </div>
        </div>
      </div>
    </div>
  );
}

function Card({ title, value, icon }: { title: string; value: string; icon?: React.ReactNode }) {
  return <div className="rounded-xl border border-[#21262D] bg-[#161B22] p-5">{icon}<div className="text-[#8B949E] text-sm mt-2">{title}</div><div className="text-xl font-semibold mt-1">{value}</div></div>;
}
