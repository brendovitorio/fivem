import { Search, User, Scale, Shield } from "lucide-react";
import { useState } from "react";
import type { CivilianSearchResult } from "../../types/mdt";

export function Civilians({ onSearch, result, onIssueFine, onIssuePrison }: {
  onSearch: (passport: string | number) => Promise<CivilianSearchResult | null>;
  result: CivilianSearchResult | null;
  onIssueFine: (payload: { passaporte: number; multas: number; texto: string; cnh?: number }) => Promise<void>;
  onIssuePrison: (payload: { passaporte: number; servicos: number; multas: number; texto: string; associacao?: string; material?: string; url?: string; militares?: string }) => Promise<void>;
}) {
  const [searchTerm, setSearchTerm] = useState("");
  const [fine, setFine] = useState({ multas: "", texto: "" });
  const [prison, setPrison] = useState({ servicos: "", multas: "", texto: "" });

  return (
    <div className="p-8 space-y-6">
      <div>
        <h2 className="text-white font-semibold text-2xl flex items-center gap-2">
          <User className="w-6 h-6" /> Civis
        </h2>
        <p className="text-[#8B949E] text-sm mt-1">Consulta por passaporte com histórico criminal e ações rápidas.</p>
      </div>

      <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4">
        <div className="flex gap-3">
          <div className="relative flex-1">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-[#8B949E]" />
            <input value={searchTerm} onChange={(e) => setSearchTerm(e.target.value)} placeholder="Digite o passaporte..." className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg pl-11 pr-4 py-3 text-white placeholder:text-[#8B949E] focus:outline-none focus:border-[#1F6FEB]" />
          </div>
          <button onClick={() => void onSearch(searchTerm)} className="px-5 py-3 bg-[#1F6FEB] hover:bg-[#2f81f7] rounded-lg">Buscar</button>
        </div>
      </div>

      {result ? (
        result.found ? (
          <div className="grid grid-cols-1 xl:grid-cols-3 gap-6">
            <div className="xl:col-span-2 space-y-6">
              <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6">
                <div className="flex items-start justify-between gap-4">
                  <div>
                    <h3 className="text-xl font-semibold">{result.name}</h3>
                    <p className="text-[#8B949E] mt-1">Passaporte {result.passport} • Telefone {result.phone}</p>
                  </div>
                  <div className="grid grid-cols-2 gap-3 text-center">
                    <div className="rounded-lg bg-[#0D1117] border border-[#21262D] p-3"><div className="text-xl font-bold">{result.fines}</div><div className="text-xs text-[#8B949E]">Multas</div></div>
                    <div className="rounded-lg bg-[#0D1117] border border-[#21262D] p-3"><div className="text-xl font-bold">{result.warrants}</div><div className="text-xs text-[#8B949E]">Mandados</div></div>
                    <div className="rounded-lg bg-[#0D1117] border border-[#21262D] p-3"><div className="text-xl font-bold">{result.records.length}</div><div className="text-xs text-[#8B949E]">Prisões</div></div>
                    <div className="rounded-lg bg-[#0D1117] border border-[#21262D] p-3"><div className="text-xl font-bold">{result.ports.length}</div><div className="text-xs text-[#8B949E]">Portes</div></div>
                  </div>
                </div>
              </div>

              <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6">
                <h4 className="font-semibold mb-4 flex items-center gap-2"><Scale className="w-5 h-5 text-[#58A6FF]" /> Histórico de prisões</h4>
                <div className="space-y-3">
                  {result.records.length ? result.records.map((record) => (
                    <div key={record.id} className="rounded-lg bg-[#0D1117] border border-[#21262D] p-4">
                      <div className="flex justify-between gap-4 mb-2 text-sm">
                        <span>Policial: <span className="text-white">{record.police}</span></span>
                        <span>{record.date}</span>
                      </div>
                      <div className="text-sm text-[#8B949E]">Serviços: {record.services} • Multa: ${record.fines}</div>
                      <div className="text-sm mt-2">{record.text}</div>
                    </div>
                  )) : <div className="text-[#8B949E]">Nenhum registro encontrado.</div>}
                </div>
              </div>
            </div>

            <div className="space-y-6">
              <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6">
                <h4 className="font-semibold mb-4">Aplicar multa rápida</h4>
                <div className="space-y-3">
                  <input value={fine.multas} onChange={(e) => setFine((old) => ({ ...old, multas: e.target.value }))} placeholder="Valor" className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
                  <textarea value={fine.texto} onChange={(e) => setFine((old) => ({ ...old, texto: e.target.value }))} placeholder="Motivo" className="w-full min-h-28 bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
                  <button onClick={() => void onIssueFine({ passaporte: result.passport, multas: Number(fine.multas), texto: fine.texto })} className="w-full bg-[#1F6FEB] hover:bg-[#2f81f7] rounded-lg px-4 py-2">Multar cidadão</button>
                </div>
              </div>

              <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6">
                <h4 className="font-semibold mb-4 flex items-center gap-2"><Shield className="w-5 h-5 text-[#58A6FF]" /> Prender cidadão</h4>
                <div className="space-y-3">
                  <input value={prison.servicos} onChange={(e) => setPrison((old) => ({ ...old, servicos: e.target.value }))} placeholder="Serviços" className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
                  <input value={prison.multas} onChange={(e) => setPrison((old) => ({ ...old, multas: e.target.value }))} placeholder="Multa" className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
                  <textarea value={prison.texto} onChange={(e) => setPrison((old) => ({ ...old, texto: e.target.value }))} placeholder="Motivo" className="w-full min-h-28 bg-[#0D1117] border border-[#21262D] rounded-lg px-3 py-2" />
                  <button onClick={() => void onIssuePrison({ passaporte: result.passport, servicos: Number(prison.servicos), multas: Number(prison.multas), texto: prison.texto })} className="w-full bg-[#238636] hover:bg-[#2ea043] rounded-lg px-4 py-2">Efetuar prisão</button>
                </div>
              </div>
            </div>
          </div>
        ) : (
          <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-6 text-[#8B949E]">Nenhum cidadão encontrado para o passaporte {result.passport}.</div>
        )
      ) : null}
    </div>
  );
}
