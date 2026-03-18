-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
vSERVER = Tunnel.getInterface("tractor")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Locate = 1
local Position = 1
local Locations = {
	[1] = { 
		["Service"] = {2251.68,5155.38,57.88,232.45},
		["Route"] = {
			{2264.91,5137.39,54.34,221.11},
			{2312.91,5086.09,46.74,308.98},
			{2326.41,5093.75,46.67,45.36},
			{2272.55,5145.59,55.15,320.32},
			{2282.64,5154.91,56.16,226.78},
			{2337.93,5099.45,47.21,314.65},
			{2346.28,5109.66,48.17,45.36},
			{2289.2,5163.1,57.66,314.65},
			{2295.87,5168.62,58.52,226.78},
			{2351.42,5113.96,48.44,133.23},
			{2341.38,5104.51,47.7,45.36},
			{2285.36,5160.08,57.2,136.07},
			{2277.78,5149.18,55.39,226.78},
			{2334.19,5094.94,46.78,138.9},
			{2322.64,5089.69,46.66,42.52},
			{2269.68,5141.15,54.54,42.52},
		},
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(Locations) do
		exports["creative"]:AddPed({
			Distance = 25,
			Coords = { v["Service"][1],v["Service"][2],v["Service"][3],v["Service"][4] },
			Model = "a_m_m_farmer_01",
			anim = { "misscarstealfinale","packer_idle_1_trevor" }
		})
		exports["target"]:AddCircleZone("Tractor:Service"..k,vec3(v["Service"][1],v["Service"][2],v["Service"][3]),1.0,{
			name = "Tractor:Service"..k,
			heading = v["Service"][4]
		},{
			shop = k,
			Distance = 0.75,
			options = {
				{
					event = "Tractor:Service",
					label = "Entrar em Serviço",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Tractor:Service")
AddEventHandler("Tractor:Service",function(Service)
	if LocalPlayer["state"]["Route"] < 900000 then
		if LocalPlayer["state"]["Tractor"] then	
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
				Blip = nil
			end
			LocalPlayer["state"]:set("Tractor",false)
			exports["target"]:LabelText("Tractor:Service"..Service,"Entrar em Serviço","Tratorista")
			TriggerEvent("Notify","verde","Trabalho finalizado.",5000,"Sucesso")
		else
			Position = 1
			Locate = tonumber(Service)
			LocalPlayer["state"]:set("Tractor",true)
			routeStart()
			exports["target"]:LabelText("Tractor:Service"..Service,"Sair de Serviço","Tratorista")
			TriggerEvent("Notify","verde","Trabalho iniciado.",5000,"Sucesso")
			TriggerEvent("Notify","amarelo","1° Siga os pontos no gps.<br>2° dirija-se à garagem e selecione um arado ou uma carroça para acoplar ao trator.",10000,"<b>Guia de Trabalho</b>")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function routeStart()
	CreateThread(function()
    	while LocalPlayer["state"]["Tractor"] do
			local TimeDistance = 999
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) and GetEntityHealth(Ped) > 100 then
				if GetEntityModel(GetVehiclePedIsUsing(Ped)) == GetHashKey("tractor2") then
					local hasTrailer,trailer = GetVehicleTrailerVehicle(GetVehiclePedIsUsing(Ped))
					if hasTrailer and GetEntityModel(trailer) == GetHashKey("raketrailer") then
						if not DoesBlipExist(Blip) then
							makeBlipMarked(Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3])
						end
						if #(GetEntityCoords(Ped) - vec3(Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3])) <= 100 then
							TimeDistance = 1
							if Position >= #Locations[Locate]["Route"] then
								DrawMarker(4,Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3] + 3.0,0.0,0.0,0.0,0.0,180.0,0.0,4.5,4.5,2.0,65,130,226,100,0,0,0,1)
								DrawMarker(1,Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3]-0.6,0,0,0,0.0,0,0,5.0,5.0,2.0,250, 250, 250 ,50,0,0,0,1)
							else
								drawMarker(Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3],Locations[Locate]["Route"][Position][4]-180.0 or 0.0)
							end	
						end
						if #(GetEntityCoords(Ped) - vec3(Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3])) <= 5 then
							if Position >= #Locations[Locate]["Route"] then
								Position = 1
								vSERVER.Payment()
							else
								Position = Position + 1
							end
							PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
							makeBlipMarked(Locations[Locate]["Route"][Position][1],Locations[Locate]["Route"][Position][2],Locations[Locate]["Route"][Position][3])
						end
					elseif hasTrailer and GetEntityModel(trailer) == GetHashKey("graintrailer") then

					end
				end
			end	
			Citizen.Wait(TimeDistance)
    	end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function makeBlipMarked(x,y,z)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end
	Blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(Blip,1)
	SetBlipColour(Blip,5)
	SetBlipScale(Blip,0.7)
	SetBlipAsShortRange(Blip,false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("CheckPoint")
	EndTextCommandSetBlipName(Blip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
local nextSwitchTime = 0
local state = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function drawMarker(x,y,z,h)
	local currentTime = GetGameTimer()
	if currentTime >= nextSwitchTime then
		state = state % 4 + 1 
		nextSwitchTime = currentTime + 500 
	end
	local offset = 1.0
	-- Converte o ângulo em graus para radianos
	local angle_rad = math.rad(h)
    -- Calcula o offset para x e y baseado no ângulo
    local offsetX = math.sin(angle_rad) * offset
    local offsetY = math.cos(angle_rad) * offset
    -- Coordenadas para o marcador à frente
    local frontX = x - offsetX
    local frontY = y + offsetY
    -- Coordenadas para o marcador atrás
    local backX = x + offsetX
    local backY = y - offsetY
	if state == 1 then
		DrawMarker(20, frontX, frontY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 250, 250, 250, 50, 0, 0, 0, 0)
		DrawMarker(20, x, y, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0,250, 250, 250 ,50, 0, 0, 0, 0)
		DrawMarker(20, backX, backY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 250, 250, 250 ,50, 0, 0, 0, 0)
	elseif state == 2 then 
		DrawMarker(20, frontX, frontY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
		DrawMarker(20, x, y, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0,250, 250, 250 ,50, 0, 0, 0, 0)
		DrawMarker(20, backX, backY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 250, 250, 250 ,50, 0, 0, 0, 0)
	elseif state == 3 then 
		DrawMarker(20, frontX, frontY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
		DrawMarker(20, x, y, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
		DrawMarker(20, backX, backY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 250, 250, 250 ,50, 0, 0, 0, 0)
	elseif state == 4 then
		DrawMarker(20, frontX, frontY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
		DrawMarker(20, x, y, z + 3.0, 0.0, 0.0, 0.0, 90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
		DrawMarker(20, backX, backY, z + 3.0, 0.0, 0.0, 0.0,90.0, h, 90.0, 4.5, 4.5, 2.0, 65, 130, 226, 100, 0, 0, 0, 0)
	end
	DrawMarker(1,x,y,z-1.0,0,0,0,0.0,0,0,5.0,5.0,2.0,250, 250, 250 ,50,0,0,0,1)
end