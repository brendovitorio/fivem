-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTS = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("bus",Creative)
vSERVER = Tunnel.getInterface("bus")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Npcs = {}
local Blip = nil
local Locate = 1
local Position = 1
local GetLastVehicleIsPed = {}
local insuranceUnemploymentAmount = 0
local initService = {
	{ 452.97,-607.75,28.59 },
	{ -200.3,6234.62,31.49 },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOPVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local stopVehicle = {
	[1] = {
		{ 309.95, -760.52, 30.09 },
		{ 69.59, -974.80, 30.14 },
		{ 95.00, -634.89, 45.02 },
		{ 58.27, -283.32, 48.20 },
		{ 47.74, -160.44, 56.03 },
		{ 323.93, -267.58, 54.71 },
		{ 443.75, 119.16, 100.41 },
		{ 125.62, -4.42, 68.48 },
		{ -524.08, 133.59, 63.91 },
		{ -586.64, 268.39, 83.24 },
		{ -640.38, -163.16, 38.49 },
		{ -597.89, -361.27, 35.77 },
		{ -646.06, -804.09, 25.78 },
		{ -932.63, -1199.67, 5.91 },
		{ -1234.65, -1080.87, 9.12 },
		{ -1373.99, -793.23, 20.09 },
		{ -2011.25, -160.04, 29.40 },
		{ -2981.70, 404.50, 15.75 },
		{ -3101.58, 1112.65, 21.28 },
		{ -2556.10, 2322.01, 33.89 },
		{ -1094.86, 2675.87, 20.08 },
		{ -72.63, 2813.83, 54.60 },
		{ 540.55, 2685.25, 43.20 },
		{ 1119.93, 2682.04, 39.31 },
		{ 1470.51, 2725.47, 38.48 },
		{ 2002.62, 2603.65, 55.07 },
		{ 379.58, -599.20, 29.58 },
	},
	[2] = {
		{ -153.29, 6212.22, 32.04 }, 
		{ -18.38, 6507.26, 32.11 }, 
		{ 750.1, 6492.87, 26.96 }, 
		{ 1605.67, 6382.96, 28.04 }, 
		{ 2523.1, 5397.13, 43.79 }, 
		{ 2417.2, 5146.35, 46.22 }, 
		{ 2483.1, 4447.83, 34.72 }, 
		{ 2009.0, 3754.48, 31.68 },
		{ 1784.69, 3784.43, 34.56 }, 
		{ 1645.95, 3594.46, 34.77 }, 
		{ 2028.34, 3086.08, 46.26 }, 
		{ 1243.86, 2685.01, 36.89 }, 
		{ 301.27, 2643.21, 43.81 }, 
		{ -457.07, 2854.16, 34.26 }, 
		{ -1117.01, 2668.0, 17.46 }, 
		{ -2220.02, 2304.25, 32.1 }, 
		{ -2697.39, 2289.02, 18.42 }, 
		{ -2542.61, 3416.97, 12.56 }, 
		{ -2208.02, 4298.45, 47.47 }, 
		{ -1530.62, 4954.68, 61.37 }, 
		{ -1050.17, 5333.97, 44.0 }, 
		{ -790.13, 5551.25, 32.34 }, 
		{ -453.36, 6069.5, 30.66 }, 
		{ -333.46, 6331.06, 29.42 }, 
		{ -51.08, 6602.36, 29.08 }, 
		{ -64.9, 6472.86, 30.68 }, 
		{ -292.38, 6246.41, 30.71 }, 
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNMODELS
-----------------------------------------------------------------------------------------------------------------------------------------
local spawnModels = {
	"ig_abigail","a_m_m_afriamer_01","ig_mp_agent14","csb_agent","ig_amandatownley","s_m_y_ammucity_01","u_m_y_antonb","g_m_m_armboss_01",
	"g_m_m_armgoon_01","g_m_m_armlieut_01","ig_ashley","s_m_m_autoshop_01","ig_money","g_m_y_ballaeast_01","g_f_y_ballas_01","g_m_y_ballasout_01",
	"s_m_y_barman_01","u_m_y_baygor","a_m_o_beach_01","ig_bestmen","a_f_y_bevhills_01","a_m_m_bevhills_02","u_m_m_bikehire_01","u_f_y_bikerchic",
	"mp_f_boatstaff_01","s_m_m_bouncer_01","ig_brad","ig_bride","u_m_y_burgerdrug_01","a_m_m_business_01","a_m_y_business_02","s_m_o_busker_01",
	"ig_car3guy2","cs_carbuyer","g_m_m_chiboss_01","g_m_m_chigoon_01","g_m_m_chigoon_02","u_f_y_comjane","ig_dale","ig_davenorton","s_m_y_dealer_01",
	"ig_denise","ig_devin","a_m_y_dhill_01","ig_dom","a_m_y_downtown_01","ig_dreyfuss"
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(initService) do
		exports["target"]:AddCircleZone("Driver:"..k,vec3(v[1],v[2],v[3]),1.0,{
			name = "Driver:"..k,
			heading = 3374176
		},{
			shop = k,
			Distance = 0.75,
			options = {
				{
					event = "Driver:initService",
					label = "Entrar em Serviço",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVICE:INIT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Driver:initService")
AddEventHandler("Driver:initService",function(Service)
	if LocalPlayer["state"]["Route"] < 900000 then
		if LocalPlayer["state"]["Bus"] then	
			if DoesBlipExist(Blip) then
				RemoveBlip(Blip)
				Blip = nil
			end
			Npc = nil
			LocalPlayer["state"]:set("Bus",false)
			vSERVER.insuranceUnemployment(insuranceUnemploymentAmount) 
			exports["target"]:LabelText("Driver:"..Service,"Entrar em Serviço","Motorista")
			TriggerEvent("Notify","verde","Trabalho finalizado.",5000,"Sucesso")
		else
			LocalPlayer["state"]:set("Bus",true)
			routeStart()
			Salary()
			Position = 1
			Locate = tonumber(Service)
			insuranceUnemploymentAmount = 0
			exports["target"]:LabelText("Driver:"..Service,"Sair de Serviço","Motorista")
			TriggerEvent("Notify","verde","Trabalho iniciado.",5000,"Sucesso")
			TriggerEvent("Notify","amarelo","1° Pare onde estive movimentado.<br>2° Espere as pessoas entrarem.<br>3° Siga ate o destino na rota.",10000,"<b>Guia de Trabalho</b>")
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function routeStart()
	CreateThread(function()
    	while LocalPlayer["state"]["Bus"] do
			local TimeDistance = 999
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped) and GetEntityHealth(Ped) > 100 then
				if GetEntityModel(GetVehiclePedIsUsing(Ped)) == GetHashKey("bus") or GetHashKey("airbus") then

					if not DoesBlipExist(Blip) then
						blipPassengers(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3])
					end

					if #(GetEntityCoords(Ped) - vec3(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3])) <= 30 then
						TimeDistance = 1
						DrawMarker(22,stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3] + 3.0,0.0,0.0,0.0,0.0,180.0,0.0,7.5,7.5,5.0,65,130,226,100,0,0,0,1)
						DrawMarker(1,stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3] - 3.0,0,0,0,0.0,0,0,5.0,5.0,2.0,250, 250, 250 ,50,0,0,0,1)
					end

					if GetEntitySpeed(GetVehiclePedIsUsing(Ped)) <= 4 and IsPedInAnyVehicle(Ped)  and GetEntityHealth(Ped) > 100 then
						if #(GetEntityCoords(Ped) - vec3(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3])) <= 5 then
							FreezeEntityPosition(GetVehiclePedIsUsing(Ped),true)

							if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) == 0 or 1 or 2 or 3 then
								SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 0, false, false) 
								SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 1, false, false) 
								SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 2, false, false) 
								SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 3, false, false) 
							end

							if GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped)) ~= 0 then
								local Vehicle = GetVehiclePedIsUsing(Ped)
								for Seat = 0,GetVehicleNumberOfPassengers(Vehicle) do
									local Npc = GetPedInVehicleSeat(Vehicle, Seat)
									if Npc ~= 0 then
										vSERVER.Payment(GetLastVehicleIsPed[Npc])
										local coord1 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_dside_f"))
										local coord2 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_pside_f"))
										local coord3 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_dside_r"))
										local coord4 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_pside_r"))
										local EnterOne = vector3((coord1.x + coord2.x) / 2, (coord1.y + coord2.y) / 2, (coord1.z + coord2.z) / 2)
										local EnterTwo = vector3((coord3.x + coord4.x) / 2, (coord3.y + coord4.y) / 2, (coord3.z + coord4.z) / 2)
										local Coords = nil
									
										if (Seat%2~=0)--[[ Seat <= 6 ]] then
											Coords = EnterOne
										else
											Coords = EnterTwo
										end
									
										local Heading = GetEntityHeading(Vehicle)
										local x = Coords.x + math.cos(math.rad(Heading)) * 1.0
										local y = Coords.y + math.sin(math.rad(Heading)) * 1.0
										SetEntityCoords(Npc, x, y, Coords.z-1.0, 1, 0, 0, 1)
										TaskWanderStandard(Npc,10.0,10)
										while #(GetEntityCoords(Npc) - Coords) < 2 do
											Wait(0)
										end
									end
								end
							end

							if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) ~= 0 or 1 or 2 or 3 then
								SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 0, false, false)	
								SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 1, false, false)	
								SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 2, false, false)	
								SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 3, false, false)	
							end

							FreezeEntityPosition(GetVehiclePedIsUsing(Ped),false)

							if Position >= #stopVehicle[Locate] then
								Position = 1
							else
								Position = Position + 1
							end

							insuranceUnemploymentAmount = insuranceUnemploymentAmount + 1

							blipPassengers(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3])
						end
					end

					if GetEntitySpeed(GetVehiclePedIsUsing(Ped)) <= 0 and GetVehicleMaxNumberOfPassengers(GetVehiclePedIsUsing(Ped)) > GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped)) then


						if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) == 0 or 1 or 2 or 3 then
							SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 0, false, false) 
							SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 1, false, false) 
							SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 2, false, false) 
							SetVehicleDoorOpen(GetVehiclePedIsUsing(Ped), 3, false, false) 
						end

						for Index,Npc in ipairs(GetGamePool("CPed")) do
							if not GetLastVehicleIsPed[Npc] and Npc ~= Ped and IsPedInAnyVehicle(Npc) ~= 1 and IsEntityPositionFrozen(Npc) ~= 1 and IsEntityDead(Npc) ~= 1 and GetEntityCoords(Ped).z+1 >= GetEntityCoords(Npc).z then
								if #(GetEntityCoords(Ped) - GetEntityCoords(Npc)) <= 15 and GetVehicleMaxNumberOfPassengers(GetVehiclePedIsUsing(Ped)) > GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped)) then
									if math.random(100) <= 70 and IsVehicleSeatFree(GetVehiclePedIsUsing(Ped),GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped))) then
										ClearPedTasks(Npc)
										ClearPedSecondaryTask(Npc)
										SetPedConfigFlag(Npc, 32, true) -- Ativa a flag DisablePedAvoidance para o NPC
										SetPedConfigFlag(Npc, 229, true) -- DisablePanicInVehicle
										local coord1 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_dside_f"))
										local coord2 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_pside_f"))
										local coord3 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_dside_r"))
										local coord4 = GetWorldPositionOfEntityBone(GetVehiclePedIsUsing(Ped), GetEntityBoneIndexByName(GetVehiclePedIsUsing(Ped), "door_pside_r"))
										local EnterOne = vector3((coord1.x + coord2.x) / 2, (coord1.y + coord2.y) / 2, (coord1.z + coord2.z) / 2)
										local EnterTwo = vector3((coord3.x + coord4.x) / 2, (coord3.y + coord4.y) / 2, (coord3.z + coord4.z) / 2)
										local Coords = nil
										
										if #(GetEntityCoords(Npc) - EnterOne) < #(GetEntityCoords(Npc) - EnterTwo) then
											Coords = EnterOne
										else
											Coords = EnterTwo
										end
									
										local Heading = GetEntityHeading(GetVehiclePedIsUsing(Ped))
										local x = Coords.x + math.cos(math.rad(Heading)) * 1.0
										local y = Coords.y + math.sin(math.rad(Heading)) * 1.0
										TaskGoStraightToCoord(Npc, x, y, Coords.z, 1.0, -1, 1.0, 0.0, 0.0)
										while true do
											if IsEntityDead(Npc) == 1 then
												break
											end
											if GetEntitySpeed(GetVehiclePedIsUsing(Ped)) >= 4 then
												if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) ~= 0 or 1 or 2 or 3 then
													SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 0, false, false)	
													SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 1, false, false)	
													SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 2, false, false)	
													SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 3, false, false)	
												end
												break
											end
											if #(GetEntityCoords(Npc) - Coords) < 2 then
												SetPedIntoVehicle(Npc,GetVehiclePedIsUsing(Ped),GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped)))
												GetLastVehicleIsPed[Npc] = #(GetEntityCoords(Npc) - vec3(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3]))
												break
											end
											Wait(1000)
										end

									end
								end
							end
						end
						if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) ~= 0 or 1 or 2 or 3 then
							SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 0, false, false)	
							SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 1, false, false)	
							SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 2, false, false)	
							SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 3, false, false)	
						end
					end

				elseif GetEntityModel(GetVehiclePedIsUsing(Ped)) == GetHashKey("coach") then


				end
			end	
			Citizen.Wait(TimeDistance)
    	end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Bus:SetPedIntoVehicle",function(Coords,Ped,Npc)
	while true do							
		if IsEntityDead(Npc) == 1 then
			break
		end
		if GetEntitySpeed(GetVehiclePedIsUsing(Ped)) >= 4 then
			if GetVehicleDoorAngleRatio(GetVehiclePedIsUsing(Ped), 2) ~= 0 or 1 or 2 or 3 then
				SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 0, false, false)	
				SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 1, false, false)	
				SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 2, false, false)	
				SetVehicleDoorShut(GetVehiclePedIsUsing(Ped), 3, false, false)	
			end
			break
		end
		if #(GetEntityCoords(Npc) - Coords) < 2 then
			SetPedIntoVehicle(Npc,GetVehiclePedIsUsing(Ped),GetVehicleNumberOfPassengers(GetVehiclePedIsUsing(Ped)))
			GetLastVehicleIsPed[Npc] = #(GetEntityCoords(Npc) - vec3(stopVehicle[Locate][Position][1],stopVehicle[Locate][Position][2],stopVehicle[Locate][Position][3]))
			break
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function LoadAnimDict(dict)
    while (not HasAnimDictLoaded(dict)) do
        RequestAnimDict(dict)
        Citizen.Wait(5)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAKEBLIPMARKED
-----------------------------------------------------------------------------------------------------------------------------------------
function blipPassengers(x,y,z)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end
	Blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(Blip,1)
	SetBlipDisplay(Blip,4)
	SetBlipAsShortRange(Blip,true)
	SetBlipColour(Blip,77)
	SetBlipScale(Blip,0.75)
	SetBlipRoute(Blip,true)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString("Motorista")
	EndTextCommandSetBlipName(Blip)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Salary()
	local LastPosition = Position
	CreateThread(function()
		while LocalPlayer["state"]["Bus"] do
			Wait(600000)
			local Ped = PlayerPedId()
			if IsPedInAnyVehicle(Ped)  and GetEntityHealth(Ped) > 100 then
				if GetEntityModel(GetVehiclePedIsUsing(Ped)) == GetHashKey("bus") or GetHashKey("airbus") then
					if LocalPlayer["state"]["Bus"] then
						if LastPosition ~= Position then
							LastPosition = Position
							vSERVER.Salary()
						end
					end
				end
			end
		end
	end)
end