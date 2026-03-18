import type React from "react";
import { LayoutDashboard, Users, Car, FileText, AlertTriangle, Gavel, BookOpen, Building2, Shield } from "lucide-react";

interface SidebarItem { id: string; label: string; icon: React.ReactNode; superiorOnly?: boolean; }
interface SidebarProps { activeItem: string; onItemClick: (id: string) => void; isSuperior: boolean; }

const menuItems: SidebarItem[] = [
  { id: "dashboard", label: "Dashboard", icon: <LayoutDashboard className="w-5 h-5" /> },
  { id: "civis", label: "Civis", icon: <Users className="w-5 h-5" /> },
  { id: "veiculos", label: "Veículos", icon: <Car className="w-5 h-5" /> },
  { id: "relatorios", label: "Relatórios", icon: <FileText className="w-5 h-5" /> },
  { id: "bolo", label: "BOLO", icon: <AlertTriangle className="w-5 h-5" /> },
  { id: "warrants", label: "Warrants", icon: <Gavel className="w-5 h-5" /> },
  { id: "codigo-penal", label: "Código Penal", icon: <BookOpen className="w-5 h-5" /> },
  { id: "departamento", label: "Departamento", icon: <Building2 className="w-5 h-5" /> },
  { id: "administracao", label: "Administração", icon: <Shield className="w-5 h-5" />, superiorOnly: true },
];

export function Sidebar({ activeItem, onItemClick, isSuperior }: SidebarProps) {
  return (
    <aside className="w-[280px] bg-[#0D1117] border-r border-[#21262D] h-full flex flex-col">
      <nav className="flex-1 py-6">
        {menuItems.map((item) => {
          if (item.superiorOnly && !isSuperior) return null;
          const isActive = activeItem === item.id;
          return (
            <button key={item.id} onClick={() => onItemClick(item.id)} className={`w-full flex items-center gap-3 px-6 py-3 transition-all ${isActive ? "bg-[#161B22] text-white border-l-4 border-[#1F6FEB]" : "text-[#8B949E] hover:bg-[#1C2128] hover:text-white border-l-4 border-transparent"} ${item.superiorOnly && isSuperior ? "shadow-[0_0_10px_rgba(212,175,55,0.2)]" : ""}`}>
              {item.icon}<span className="font-medium text-sm">{item.label}</span>
            </button>
          );
        })}
      </nav>
      <div className="p-6 border-t border-[#21262D]"><p className="text-[#8B949E] text-xs text-center">Revolt MDT<br />NUI Vite integrada ao FiveM</p></div>
    </aside>
  );
}
