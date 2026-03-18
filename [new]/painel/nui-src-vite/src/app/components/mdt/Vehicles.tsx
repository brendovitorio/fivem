import { Search, Car } from "lucide-react";
import { useState } from "react";

interface Vehicle {
  id: string;
  plate: string;
  model: string;
  color: string;
  owner: string;
  status: "Regular" | "Roubado" | "Procurado";
  registrationExpiry: string;
}

export function Vehicles() {
  const [searchTerm, setSearchTerm] = useState("");

  const vehicles: Vehicle[] = [
    {
      id: "VEH-5001",
      plate: "ABC123",
      model: "Dodge Charger",
      color: "Preto",
      owner: "Michael Anderson",
      status: "Regular",
      registrationExpiry: "15/06/2026",
    },
    {
      id: "VEH-5002",
      plate: "XYZ789",
      model: "Sultan RS",
      color: "Azul",
      owner: "Jessica Martinez",
      status: "Regular",
      registrationExpiry: "20/08/2026",
    },
    {
      id: "VEH-5003",
      plate: "DEF456",
      model: "Baller",
      color: "Branco",
      owner: "Desconhecido",
      status: "Roubado",
      registrationExpiry: "N/A",
    },
    {
      id: "VEH-5004",
      plate: "GHI789",
      model: "Elegy RH8",
      color: "Vermelho",
      owner: "David Thompson",
      status: "Procurado",
      registrationExpiry: "10/05/2026",
    },
  ];

  const filteredVehicles = vehicles.filter(
    (vehicle) =>
      vehicle.plate.toLowerCase().includes(searchTerm.toLowerCase()) ||
      vehicle.model.toLowerCase().includes(searchTerm.toLowerCase()) ||
      vehicle.owner.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const getStatusColor = (status: string) => {
    switch (status) {
      case "Regular":
        return "bg-[#238636] text-white";
      case "Roubado":
        return "bg-[#DA3633] text-white";
      case "Procurado":
        return "bg-[#D4AF37] text-[#0D1117]";
      default:
        return "bg-[#8B949E] text-white";
    }
  };

  return (
    <div className="p-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h2 className="text-white font-semibold text-2xl flex items-center gap-2">
            <Car className="w-6 h-6" />
            Veículos
          </h2>
          <p className="text-[#8B949E] text-sm mt-1">Banco de dados de veículos registrados</p>
        </div>
      </div>

      {/* Search */}
      <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 mb-6">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-[#8B949E]" />
          <input
            type="text"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
            placeholder="Buscar por placa, modelo ou proprietário..."
            className="w-full bg-[#0D1117] border border-[#21262D] rounded-lg pl-11 pr-4 py-3 text-white placeholder:text-[#8B949E] focus:outline-none focus:border-[#1F6FEB]"
          />
        </div>
      </div>

      {/* Results Table */}
      <div className="bg-[#161B22] rounded-lg border border-[#21262D] overflow-hidden">
        <table className="w-full">
          <thead>
            <tr className="bg-[#0D1117] border-b border-[#21262D]">
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">ID</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Placa</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Modelo</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Cor</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Proprietário</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Status</th>
              <th className="text-left text-[#8B949E] text-xs font-semibold p-4">Registro Expira</th>
            </tr>
          </thead>
          <tbody>
            {filteredVehicles.map((vehicle) => (
              <tr
                key={vehicle.id}
                className="border-b border-[#21262D] hover:bg-[#1C2128] cursor-pointer"
              >
                <td className="text-[#1F6FEB] font-semibold text-sm p-4">{vehicle.id}</td>
                <td className="text-white text-sm p-4">
                  <div className="flex items-center gap-2">
                    <div className="w-12 h-8 bg-[#D4AF37] rounded flex items-center justify-center text-[#0D1117] font-bold text-xs">
                      {vehicle.plate}
                    </div>
                  </div>
                </td>
                <td className="text-white text-sm p-4">{vehicle.model}</td>
                <td className="text-white text-sm p-4">{vehicle.color}</td>
                <td className="text-white text-sm p-4">{vehicle.owner}</td>
                <td className="p-4">
                  <span className={`text-xs px-3 py-1 rounded ${getStatusColor(vehicle.status)}`}>
                    {vehicle.status}
                  </span>
                </td>
                <td className="text-[#8B949E] text-sm p-4">{vehicle.registrationExpiry}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>

      {/* Quick Stats */}
      <div className="mt-6 grid grid-cols-4 gap-4">
        <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 text-center">
          <div className="text-2xl font-bold text-white">{vehicles.length}</div>
          <div className="text-xs text-[#8B949E]">Total de Veículos</div>
        </div>
        <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 text-center">
          <div className="text-2xl font-bold text-[#238636]">
            {vehicles.filter((v) => v.status === "Regular").length}
          </div>
          <div className="text-xs text-[#8B949E]">Regular</div>
        </div>
        <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 text-center">
          <div className="text-2xl font-bold text-[#DA3633]">
            {vehicles.filter((v) => v.status === "Roubado").length}
          </div>
          <div className="text-xs text-[#8B949E]">Roubados</div>
        </div>
        <div className="bg-[#161B22] rounded-lg border border-[#21262D] p-4 text-center">
          <div className="text-2xl font-bold text-[#D4AF37]">
            {vehicles.filter((v) => v.status === "Procurado").length}
          </div>
          <div className="text-xs text-[#8B949E]">Procurados</div>
        </div>
      </div>
    </div>
  );
}
