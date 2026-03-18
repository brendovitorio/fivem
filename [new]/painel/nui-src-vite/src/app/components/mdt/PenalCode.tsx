import { BookOpen, Search } from "lucide-react";
import { useState } from "react";

interface PenalCodeEntry {
  code: string;
  title: string;
  category: "Violento" | "Propriedade" | "Tráfego" | "Drogas" | "Armas" | "Outro";
  jailTime: string;
  fine: string;
  description: string;
}

export function PenalCode() {
  const [searchTerm, setSearchTerm] = useState("");
  const [selectedCategory, setSelectedCategory] = useState<string>("Todos");

  const penalCodes: PenalCodeEntry[] = [
    {
      code: "PC 187",
      title: "Homicídio",
      category: "Violento",
      jailTime: "120 meses",
      fine: "$50,000",
      description: "Matar intencionalmente outra pessoa",
    },
    {
      code: "PC 211",
      title: "Roubo",
      category: "Violento",
      jailTime: "60 meses",
      fine: "$20,000",
      description: "Tomar propriedade de outra pessoa usando força ou medo",
    },
    {
      code: "PC 459",
      title: "Invasão de Propriedade",
      category: "Propriedade",
      jailTime: "40 meses",
      fine: "$10,000",
      description: "Entrar em propriedade com intenção de cometer crime",
    },
    {
      code: "PC 487",
      title: "Grande Furto",
      category: "Propriedade",
      jailTime: "30 meses",
      fine: "$8,000",
      description: "Roubo de propriedade com valor superior a $950",
    },
    {
      code: "VC 23152",
      title: "DUI - Dirigir sob Influência",
      category: "Tráfego",
      jailTime: "20 meses",
      fine: "$5,000",
      description: "Operar veículo sob influência de álcool ou drogas",
    },
    {
      code: "HS 11350",
      title: "Posse de Substância Controlada",
      category: "Drogas",
      jailTime: "25 meses",
      fine: "$7,000",
      description: "Posse de drogas ilegais para uso pessoal",
    },
    {
      code: "HS 11351",
      title: "Posse para Venda de Drogas",
      category: "Drogas",
      jailTime: "80 meses",
      fine: "$30,000",
      description: "Posse de drogas com intenção de distribuição",
    },
    {
      code: "PC 25400",
      title: "Porte Ilegal de Arma",
      category: "Armas",
      jailTime: "35 meses",
      fine: "$12,000",
      description: "Carregar arma oculta sem licença",
    },
  ];

  const categories = ["Todos", "Violento", "Propriedade", "Tráfego", "Drogas", "Armas", "Outro"];

  const filteredCodes = penalCodes.filter((code) => {
    const matchesSearch =
      code.code.toLowerCase().includes(searchTerm.toLowerCase()) ||
      code.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
      code.description.toLowerCase().includes(searchTerm.toLowerCase());

    const matchesCategory = selectedCategory === "Todos" || code.category === selectedCategory;

    return matchesSearch && matchesCategory;
  });

  const getCategoryColor = (category: string) => {
    switch (category) {
      case "Violento":
        return "bg-[#DA3633] text-white";
      case "Propriedade":
        return "bg-[#D4AF37] text-[#0D1117]";
      case "Tráfego":
        return "bg-[#1F6FEB] text-white";
      case "Drogas":
        return "bg-[#8B3FF5] text-white";
      case "Armas":
        return "bg-[#DA7633] text-white";
      default:
        return "bg-[#8B949E] text-white";
    }
  };

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-white font-semibold text-2xl flex items-center gap-2">
            <BookOpen className="w-6 h-6" />
            Código Penal
          </h2>
          <p className="text-[#8B949E] text-sm mt-1">Referência completa de leis e penalidades</p>
        </div>
      </div>

      {/* Search and Filters */}
      <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 mb-6">
        <div className="flex gap-4">
          <div className="flex-1 relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-[#8B949E]" />
            <input
              type="text"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              placeholder="Buscar código, título ou descrição..."
              className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg pl-11 pr-4 py-2 text-white placeholder:text-[#8B949E] focus:outline-none focus:border-[#1F6FEB]"
            />
          </div>
          <div className="flex gap-2">
            {categories.map((cat) => (
              <button
                key={cat}
                onClick={() => setSelectedCategory(cat)}
                className={`px-4 py-2 rounded text-sm transition-colors ${
                  selectedCategory === cat
                    ? "bg-[#1F6FEB] text-white"
                    : "bg-[#0D1117] text-[#8B949E] hover:text-white"
                }`}
              >
                {cat}
              </button>
            ))}
          </div>
        </div>
      </div>

      {/* Penal Codes Grid */}
      <div className="grid grid-cols-1 gap-4">
        {filteredCodes.map((code) => (
          <div
            key={code.code}
            className="bg-[#161B22] rounded-lg border border-[#21262D] p-5 hover:bg-[#1C2128] transition-colors"
          >
            <div className="flex items-start justify-between mb-3">
              <div className="flex-1">
                <div className="flex items-center gap-3 mb-2">
                  <span className="text-[#1F6FEB] font-bold text-lg">{code.code}</span>
                  <span className={`text-xs px-3 py-1 rounded ${getCategoryColor(code.category)}`}>
                    {code.category}
                  </span>
                </div>
                <h3 className="text-white font-semibold text-xl mb-2">{code.title}</h3>
                <p className="text-[#8B949E] text-sm">{code.description}</p>
              </div>
            </div>

            <div className="flex gap-6 mt-4 pt-4 border-t border-[#21262D]">
              <div>
                <p className="text-[#8B949E] text-xs mb-1">Tempo de Prisão</p>
                <p className="text-white font-semibold">{code.jailTime}</p>
              </div>
              <div>
                <p className="text-[#8B949E] text-xs mb-1">Multa</p>
                <p className="text-[#D4AF37] font-semibold">{code.fine}</p>
              </div>
            </div>
          </div>
        ))}
      </div>

      {filteredCodes.length === 0 && (
        <div className="text-center py-12">
          <BookOpen className="w-16 h-16 text-[#8B949E] mx-auto mb-4" />
          <p className="text-[#8B949E] text-lg">Nenhum código encontrado</p>
        </div>
      )}
    </div>
  );
}
