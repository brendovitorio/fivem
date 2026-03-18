-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("driverlicense",Creative)
vSERVER = Tunnel.getInterface("driverlicense")
vGARAGE = Tunnel.getInterface("garages")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Blip = nil
local Location = 1
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for k,v in pairs(Locations) do
		exports["creative"]:AddPed({
			Distance = 25,
			Coords = { v.coords[1],v.coords[2],v.coords[3],v.coords[4] or 0.0 },
			Model = "ig_stevehains",
			anim = { "anim@heists@heist_corona@single_team","single_team_loop_boss" }
		})
		exports["target"]:AddCircleZone("Drivingscholl:"..k,vec3(v.coords[1],v.coords[2],v.coords[3]),1.0,{
			name = "Drivingscholl:"..k,
			heading = v.coords[4]
		},{
			shop = k,
			Distance = 0.75,
			options = {
				{
					event = "driverlicense:Open",
					label = "Habilitação",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Finish",function(Data)
	SetNuiFocus(false)
	SendNUIMessage({ Hidemenu = true })
	rEVOLT.removeObjects()
	if Data then
		vSERVER.SetPassedTheory(Data.Index)
		TriggerEvent('Notify',"verde","Você passou no exame teórico",8000,"Auto Escola")
	else
		TriggerEvent('Notify',"vermelho","Você reprovou no exame teórico",8000,"Auto Escola")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:Open")
AddEventHandler("driverlicense:Open",function(Number)
	Location = tonumber(Number)
	local DriverLicense,Documents,Theoretical,Practice = vSERVER.UserData() 
	if DriverLicense then
		local TotalPriceCategories = 0
		for Index,Value in ipairs(Locations[Location]["categories"]) do
			if not DriverLicense["categories"][tostring(Index)] then
				if Documents and Documents[tostring(Index)] then
					if Theoretical and Theoretical[tostring(Index)] then
						exports["dynamic"]:AddButton("Prática Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index]["taxs"].theoretical).."</green> Dólares.","driverlicense:practice",Index,"Atualizar",true)
					else
						exports["dynamic"]:AddButton("Teórico Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index]["taxs"].practice).."</green> Dólares.","driverlicense:theoretical",Index,"Atualizar",true)
					end
				else
					exports["dynamic"]:AddButton("Documentos Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index].price).."</green> Dólares.","driverlicense:documents",Index,"Atualizar",true)
				end
			else
				TotalPriceCategories = TotalPriceCategories + Categories[Index].price + Categories[Index]["taxs"].theoretical + Categories[Index]["taxs"].practice
			end		
		end
		for Index in ipairs(Locations[Location]["categories"]) do
			if not DriverLicense["categories"][tostring(Index)] then
				exports["dynamic"]:SubMenu("Atualizar","Adquira uma nova categoria na carteira.","Atualizar") break
			end
		end
		if DriverLicense["expiration"] then
			exports["dynamic"]:AddButton("Renovação","Reative sua habilitação por <green>$"..parseFormat(parseInt(TotalPriceCategories* 0.1)).."</green> Dólares.","driverlicense:renew",parseInt(TotalPriceCategories* 0.1),false,true)
		else
			exports["dynamic"]:AddButton("Segunda Via","Emita sua habilitação por <green>$"..parseFormat(parseInt(TotalPriceCategories* 0.1)).."</green> Dólares.","driverlicense:issue",parseInt(TotalPriceCategories* 0.1),false,true)
		end
	else
		for Index,Value in ipairs(Locations[Location]["categories"]) do
			if Documents and Documents[tostring(Index)] then
				if Theoretical and Theoretical[tostring(Index)] then
					exports["dynamic"]:AddButton("Prática Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index]["taxs"].theoretical).."</green> Dólares.","driverlicense:practice",Index,false,true)
				else
					exports["dynamic"]:AddButton("Teórico Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index]["taxs"].practice).."</green> Dólares.","driverlicense:theoretical",Index,false,true)
				end
			else
				exports["dynamic"]:AddButton("Documentos Categoria "..Categories[Index].category,"Destinada a "..Categories[Index].description..": <green>$"..parseFormat(Categories[Index].price).."</green> Dólares.","driverlicense:documents",Index,false,true)
			end
		end
	end
	exports["dynamic"]:openMenu()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:theoretical")
AddEventHandler("driverlicense:theoretical",function(Index)
	SetNuiFocus(true,true)
	SendNUIMessage({ Showmenu = true, Index = Index, Questions = Questions(Index) })
	rEVOLT.createObjects("amb@medic@standing@timeofdeath@base","base","p_amb_clipboard_01",15,60309,0.0,-0.15,0.0, -65.0, 0.0, -50.0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:practice")
AddEventHandler("driverlicense:practice",function(Index)
	DoScreenFadeOut(0)
	local Position = 0
	local infractions = 0
	local Ped = PlayerPedId()
	local Info = Locations[Location]["categories"][tonumber(Index)]
	local Model = Info["vehicles"][math.random(#Info["vehicles"])]
	local Spawn = Info["spawn"][Creative.IsNotVehicleNearPoint(Index)] if not Spawn then return end
	local Vehicle = vGARAGE.ServerVehicle(Model,Spawn[1],Spawn[2],Spawn[3]-0.5,Spawn[4],"AUTOESCO",0,nil,1000)
	while not NetworkDoesNetworkIdExist(Vehicle) do
		Wait(0)
	end
	local Network = NetToEnt(Vehicle)
	SetVehicleOnGroundProperly(Network)
	SetPedIntoVehicle(Ped,Network,-1) 
	vSERVER.CreatePed(Info["instructor"],Spawn[1],Spawn[2],Spawn[3],Vehicle)
	while Ped ~= GetPedInVehicleSeat(Network,-1) do
		SetPedIntoVehicle(Ped,Network,-1) 
		Wait(0)
	end

	DoScreenFadeIn(0)

	LocalPlayer["state"]:set("Commands",true,true)
	LocalPlayer["state"]:set("TestDrive",true,false)

	FreezeEntityPosition(GetVehiclePedIsUsing(Ped), true)

	if IsThisModelABike(GetEntityModel(GetVehiclePedIsUsing(Ped))) then
		TriggerEvent("Notify","azul","Sua aula de direção começou, coloque o <b>capacete</b>.",8000,"Auto Escola")
	else
		TriggerEvent("Notify","azul","Sua aula de direção começou, coloque o <b>cinto</b>.",8000,"Auto Escola")
	end

    Wait(8000)
    TriggerEvent("Notify","azul","Siga a rota marcada em seu GPS seguindo as instruções de direção.",8000,"Auto Escola")
    Wait(8000)
    TriggerEvent("Notify","azul","Você está sendo avaliado, suas infrações podem acarretar na falha do seu teste.",8000,"Auto Escola")
    Wait(8000)

	FreezeEntityPosition(GetVehiclePedIsUsing(Ped), false)

	while true do
		local TimeDistance = 999
		if IsPedInAnyVehicle(Ped) and GetEntityHealth(Ped) > 100 then
			
			if not DoesBlipExist(Blip) then
				AddBlip(Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3])
			end

			local Distance = #(GetEntityCoords(Ped) - vec3(Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3]))		
			if Distance <= 100 then
				if Position+1 >= #Info["route"] then
					DrawMarker(4,Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3] + 3.0,0.0,0.0,0.0,0.0,180.0,0.0,4.5,4.5,2.0,65,130,226,100,0,0,0,1)
					DrawMarker(1,Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3]-0.6,0,0,0,0.0,0,0,5.0,5.0,2.0,250, 250, 250 ,50,0,0,0,1)
				else
					drawMarker(Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3],Info["route"][Position+1]["coords"][4]-180.0 or 0.0)
				end			
				TimeDistance = 1
			end

			if Distance <= 5 then
				if Position+1 == #Info["route"] then
					DoScreenFadeOut(0)
					if DoesBlipExist(Blip) then
						RemoveBlip(Blip)
						Blip = nil
					end
					vSERVER.DeletePed()
					TriggerEvent("garages:Delete")
					vSERVER.SetPassedPractice(Index)
					Wait(1000) DoScreenFadeIn(0)
					LocalPlayer["state"]:set("Commands",false,true)
					LocalPlayer["state"]:set("TestDrive",false,false)
					PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
					TriggerEvent("Notify","azul",Info["route"][Position]["text"],8000,"Auto Escola")
					TriggerEvent("Notify","verde","Você foi aprovado em seu teste de direção! ( Total de Infrações:"..infractions.." )",8000,"Auto Escola") break
				else
					Position = Position + 1
					PlaySound(-1, "RACE_PLACED", "HUD_AWARDS", 0, 0, 1)
					TriggerEvent("Notify","azul",Info["route"][Position]["text"],8000,"Auto Escola")
				end
				AddBlip(Info["route"][Position+1]["coords"][1],Info["route"][Position+1]["coords"][2],Info["route"][Position+1]["coords"][3])
			end
			if Position ~= 0 then
				local Speed = math.ceil(GetEntitySpeed(GetVehiclePedIsUsing(Ped)) * 2.236936)
				if Info["route"][Position]["limiteSpeed"] and Speed >= Info["route"][Position]["limiteSpeed"] then
					infractions = infractions + 1
					if infractions == 3 then
						DoScreenFadeOut(0)
						vSERVER.DeletePed()
						TriggerEvent("garages:Delete")
						LocalPlayer["state"]:set("Commands",false,true)
						LocalPlayer["state"]:set("TestDrive",false,false)
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
							Blip = nil
						end
						SetEntityCoords(Ped,Info["route"][#Info["route"]]["coords"][1],Info["route"][#Info["route"]]["coords"][2],Info["route"][#Info["route"]]["coords"][3]-0.50)
						Wait(1000) DoScreenFadeIn(0) 
						TriggerEvent("Notify","vermelho","Você reprovou no teste de direção! Tente novamente em alguns dias. ( Total de Infrações:"..infractions.." )",8000,"Auto Escola")  break
					else
						TriggerEvent("Notify","vermelho","<b>Devagar!</b> Você está exedendo o limite de velocidade. ( Infrações:"..infractions.." )",8000,"Auto Escola")
					end
					Wait(3000)
				end

				if HasEntityCollidedWithAnything(GetVehiclePedIsUsing(Ped)) then
					infractions = infractions + 1
					if infractions == 3 then
						DoScreenFadeOut(0)
						vSERVER.DeletePed()
						TriggerEvent("garages:Delete")
						LocalPlayer["state"]:set("Commands",false,true)
						LocalPlayer["state"]:set("TestDrive",false,false)
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
							Blip = nil
						end
						SetEntityCoords(Ped,Info["route"][#Info["route"]]["coords"][1],Info["route"][#Info["route"]]["coords"][2],Info["route"][#Info["route"]]["coords"][3]-0.50)
						Wait(1000) DoScreenFadeIn(0)
						TriggerEvent("Notify","vermelho","Você reprovou no teste de direção! Tente novamente em alguns dias. ( Total de Infrações:"..infractions.." )",8000,"Auto Escola") break
					else
						TriggerEvent("Notify","vermelho","<b>Cuidado!</b> Essa colisão lhe custará pontos do seu teste. ( Infrações:"..infractions.." )",8000,"Auto Escola")
					end
					Wait(3000)
            	end
		
				if IsThisModelABike(GetEntityModel(GetVehiclePedIsUsing(Ped))) then

				else
					if not exports["hud"]:SeatbeltLock() then
						DoScreenFadeOut(0)
						vSERVER.DeletePed()
						TriggerEvent("garages:Delete")
						LocalPlayer["state"]:set("Commands",false,true)
						LocalPlayer["state"]:set("TestDrive",false,false)
						if DoesBlipExist(Blip) then
							RemoveBlip(Blip)
							Blip = nil
						end
						SetEntityCoords(Ped,Info["route"][#Info["route"]]["coords"][1],Info["route"][#Info["route"]]["coords"][2],Info["route"][#Info["route"]]["coords"][3]-0.50)
						Wait(1000) DoScreenFadeIn(0)
						TriggerEvent("Notify","vermelho","Você reprovou no teste de direção! Tente novamente em alguns dias. ( Infrações: <b>cinto</b> )",8000,"Auto Escola") break
					end
				end
			end
		else
			DoScreenFadeOut(0)
			vSERVER.DeletePed()
			TriggerEvent("garages:Delete")
			LocalPlayer["state"]:set("Commands",false,true)
			LocalPlayer["state"]:set("TestDrive",false,false) 
			SetEntityCoords(Ped,Info["route"][#Info["route"]]["coords"][1],Info["route"][#Info["route"]]["coords"][2],Info["route"][#Info["route"]]["coords"][3]-0.50) 
			Wait(1000) DoScreenFadeIn(0) break
		end

		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.IsNotVehicleNearPoint(Index)
	for Key,Value in ipairs(Locations[Location]["categories"][tonumber(Index)]["spawn"]) do
		if not IsAnyVehicleNearPoint(Value[1],Value[2],Value[3],3.0) then
			return Key
		end
	end 
	TriggerEvent("Notify","vermelho","Todas as vagas estão ocupadas no momento.",8000,"Auto Escola")
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function AddBlip(x,y,z)
	if DoesBlipExist(Blip) then
		RemoveBlip(Blip)
		Blip = nil
	end
	Blip = AddBlipForCoord(x,y,z)
	SetBlipSprite(Blip,1)
	SetBlipColour(Blip,5)
	SetBlipScale(Blip,0.7)
	SetBlipAsShortRange(Blip,false)
	SetBlipRoute(Blip,true)
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