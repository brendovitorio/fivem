-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
local Gymnasium = {
	["Locations"] = {
		{
			["Ped"] = {
				["Price"] = 2000,
				["Model"] = "u_m_y_babyd",
				["Coords"] = {-1195.31,-1577.16,4.6,133.23}, 
				["anim"] = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
			},
			["Positions"] = {
				["Bicicleta"] = {
					vec4(-1209.54, -1563.00, 3.62, 124.9),
					vec4(-1208.34, -1564.86, 3.62, 124.9),
					vec4(-1195.89, -1570.25, 3.62, 304.7),
					vec4(-1194.61, -1572.06, 3.62, 304.7),
					vec4(-1199.14, -1578.77, 3.62, 34.02),
					vec4(-1197.32, -1577.44, 3.62, 39.69),
				},
				["Rosca Direta"] = {
					vec4(-1203.07, -1564.99, 3.62, 223.94),
					vec4(-1210.58, -1561.30, 3.62, 266.46),
					vec4(-1196.69, -1573.31, 3.62, 25.52),
					vec4(-1198.87, -1574.82, 3.62, 25.52),
				},
				["Halters"] = { 
					vec4(-1209.49, -1559.09, 3.62, 48.19),
					--[[ {-1209.97, -1558.41, 3.62, 138.90}, ]]
					vec4(-1203.29, -1573.58, 3.62, 212.60),
					vec4(-1197.57, -1564.58, 3.62, 212.60),
				},
				["Supino"] = {
					vec4(-1207.10, -1560.88, 3.62, 218.00),
					vec4(-1200.58, -1562.07, 3.62, 126.49),
					vec4(-1197.94, -1568.20, 3.62, 303.31),
					vec4(-1201.27, -1575.07, 3.62, 218.75),
				},
				["Barra Fixa"] = {
					vec4(-1204.87, -1564.16, 3.62, 215.44),
					vec4(-1199.82, -1571.30, 3.62, 34.37),
				},
				["Abdominal"] = {
					vec4(-1201.23, -1566.64, 3.62, 218.75),
					vec4(-1203.28, -1567.93, 3.62, 218.75),
					vec4(-1199.18, -1565.14, 3.62, 306.1),
				}
			}
		},	
	},
	["Anim"] = {
		["Bicicleta"] = {"mouse@byc_crunch","byc_crunch_clip"},
		["Rosca Direta"] = {"amb@world_human_muscle_free_weights@male@barbell@base","base","prop_curl_bar_01"},
		["Halters"] = {"amb@world_human_muscle_free_weights@male@barbell@base","base","prop_barbell_01"},
		["Supino"] =  {"amb@prop_human_seat_muscle_bench_press@idle_a","idle_a","prop_barbell_100kg"},
		["Barra Fixa"] = {"amb@prop_human_muscle_chin_ups@male@base","base"},
		["Abdominal"] = {"mouse@situp","situp_clip"},
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,Value in pairs(Gymnasium["Locations"]) do
		if Value["Ped"] then
			exports["creative"]:AddPed({
				["Distance"] = 25,
				["Model"] = Value["Ped"]["Model"],
				["Coords"] = Value["Ped"]["Coords"],
				["anim"] = Value["Ped"]["anim"]
			})
			exports["target"]:AddCircleZone("Gymnasium:"..Index,vec3(Value["Ped"]["Coords"][1],Value["Ped"]["Coords"][2],Value["Ped"]["Coords"][3]),1.0,{
				["name"] = "Gymnasium:"..Index,
			},{
				shop = Index,
				Distance = 0.75,
				options = {
					{
						event = "target:PaymentGym",
						label = "Academia",
						tunnel = "police",
						service = Value["Ped"]["Price"]
					}
				}
			})
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Gymnastics",nil,function(Name,Key,Value)
	local Name = "Gymnasium"..Value.Location..":"..Value.Equipment..""..Value.Position
	local Coords = Gymnasium["Locations"][Value.Location]["Positions"][Value.Equipment][Value.Position]
	if Gymnasium["Locations"][Value.Location]["Active"] then
		if Value.Available == nil then
			exports["target"]:RemBoxZone(Name)
		else
			exports["target"]:AddBoxZone(Name,Coords["xyz"],1.5,1.5,{
				["name"] = Name,
				["heading"] = Coords["h"] or 0.0,
				["minZ"] = Coords["z"],
				["maxZ"] = Coords["z"]+2.2,
			},{
				Distance = 1.5,
				options = {{
				 	event = "target:Gymnasium",
				 	label = Value.Equipment,
				 	tunnel = "server",
				}},
				shop = { 
					Coords = Coords,
					Location = Value.Location, 
					Equipment = Value.Equipment, 
					Position = Value.Position, 
					Anim = Gymnasium["Anim"][Value.Equipment] 
				}
			})
		end
	end	
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("target:Gymnasium")
AddEventHandler("target:Gymnasium",function(Data)
	for Location,Value in pairs(Gymnasium["Locations"]) do
		for Equipment,Value in pairs(Value["Positions"]) do
			for Position,Value in pairs(Value) do
				if not Gymnasium["Locations"][Location]["Ped"] or Data[2][tostring(Location)] then
					Gymnasium["Locations"][Location]["Active"] = true
					if Data[1]["Gymnasium"..Location..":"..Equipment..""..Position] then
						exports["target"]:RemBoxZone("Gymnasium"..Location..":"..Equipment..""..Position)
					else
						exports["target"]:AddBoxZone("Gymnasium"..Location..":"..Equipment..""..Position,Value["xyz"],1.5,1.5,{
							["name"] = "Gymnasium"..Location..":"..Equipment..""..Position,
							["heading"] = Value["h"] or 0.0,
							["minZ"] = Value["z"],
							["maxZ"] = Value["z"]+2.2,
						},{
							Distance = 1.5,
							options = {{
								event = "target:Gymnasium",
								label = Equipment,
								tunnel = "server",
							}},
							shop = { 
								Coords = Value,
								Location = Location, 
								Equipment = Equipment, 
								Position = Position, 
								Anim = Gymnasium["Anim"][Equipment] 
							}
						})
					end
				end
			end
		end
	end
end)