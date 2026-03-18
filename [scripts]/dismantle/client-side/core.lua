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
Tunnel.bindInterface("dismantle",Creative)
vSERVER = Tunnel.getInterface("dismantle")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local segundos = 0
local roubando = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISMANTLE  
-----------------------------------------------------------------------------------------------------------------------------------------
local Dismantle = {  
	[1] = { ['Coords'] = vector3(1563.34,-2170.98,77.54), ['Perm'] = 'Desmanche' },
	[2] = { ['Coords'] = vector3( -556.41,-1798.94,22.58), ['Perm'] = 'Desmanche' },
}  
-----------------------------------------------------------------------------------------------------------------------------------------
-- DESMANCHE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local TimeDistance = 999
		local Ped = PlayerPedId()
		if not roubando then
			for _,v in pairs(Dismantle) do
				local Coords = GetEntityCoords(Ped)
				local Vehicle = GetVehiclePedIsUsing(Ped)
				local Distance = #(Coords - v.Coords) 
				if Distance <= 15 and GetPedInVehicleSeat(Vehicle,-1) == Ped then
					TimeDistance = 1
					DrawMarker(23,v.Coords.x,v.Coords.y,v.Coords.z-0.96,0,0,0,0,0,0,5.0,5.0,0.5,65,130,226,100,0,0,0,0)
					if Distance <= 3.1 then
						if IsControlJustPressed(0,38) and vSERVER.checkPermission(v.Perm) then
							if vSERVER.checkVehicle(GetVehicleNumberPlateText(Vehicle)) then
								roubando = true
								startDismantle()
								FreezeEntityPosition(Vehicle,true)
								if IsThisModelABicycle(GetEntityModel(Vehicle)) then
									segundos = 30
								else
									segundos = 60
								end
								repeat
									Wait(10)
								until segundos == 0
								vSERVER.checkPayment(GetVehicleNumberPlateText(Vehicle))
								roubando = false
							end
						end
					end
				end
			end
		end
		Wait(TimeDistance)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
----------------------------------------------------------------------------------------------------------------------------------------
function startDismantle()
	CreateThread(function()
		while roubando do
			Wait(1000)
			if segundos > 0 then
				segundos = segundos - 1
			end
		end
	end)
	CreateThread(function()
		while roubando do
			local veh = GetVehiclePedIsIn(GetPlayerPed(-1), false)
			local classe = GetVehicleClass(veh)
			if segundos >= 50 then
				DisableControlAction(0,75)	
			elseif segundos > 19 and segundos < 50 then
				TriggerEvent("Notify","amarelo","Abrindo a Porta da Frente Esquerda")
				SetVehicleDoorOpen(veh,0,0,0)
				Wait(2000)
				TriggerEvent("Notify","amarelo","Abrindo a Porta da Frente Direita")	
				SetVehicleDoorOpen(veh,1,0,0)
				Wait(2000)
				TriggerEvent("Notify","amarelo","Verificando as rodas")	
				Wait(2000)
				TriggerEvent("Notify","amarelo","Abrindo o Capo para verificar o motor")	
				SetVehicleDoorOpen(veh,4,0,0)
				Wait(2000)
				TriggerEvent("Notify","amarelo","Verificando os discos de freio")	
				Wait(2000)
				TriggerEvent("Notify","amarelo","Verificando a qualidade do parachoque do veículo")	
				Wait(5000)
			elseif segundos <= 16 and segundos >= 4 then
				Wait(2000)
				TriggerEvent("Notify","verde","Removido a Porta da Frente Esquerda")
				SetVehicleDoorBroken(veh, 0	, false)
				Wait(2000)
				TriggerEvent("Notify","verde","Removido a Porta da Frente Direita")	
				Wait(1000)
				TriggerEvent("Notify","aviso","Portas traseiras não puderam ser aproveitadas")	
				SetVehicleDoorBroken(veh, 1	, false)
				Wait(2000)
				TriggerEvent("Notify","verde","Removendo as rodas")	
				if classe ~= 8 then
					SetVehicleTyreBurst(veh, 0, true, 1000)
					SetVehicleTyreBurst(veh, 1, true, 1000)
					SetVehicleTyreBurst(veh, 4, true, 1000)
					SetVehicleTyreBurst(veh, 5, true, 1000)
				else
					SetVehicleTyreBurst(veh, 0, true, 1000)
					SetVehicleTyreBurst(veh, 4, true, 1000)
				end
				Wait(1000)
				TriggerEvent("Notify","verde","Veiculo desmontado")
			end
			Wait(5)
		end
	end)
	CreateThread(function()
		while roubando do
			if IsPedInAnyVehicle(PlayerPedId(), false) then
				if segundos >= 33 then
					drawTxt("AGUARDE ~g~"..segundos.." SEGUNDOS~w~, ESTAMOS DESATIVANDO O ~y~RASTREADOR ~w~DO VEÍCULO",4,0.50,0.87,0.50,255,255,255,180)
				elseif segundos > 19 and segundos < 33 then
					drawTxt("AGUARDE ~g~"..segundos.." SEGUNDOS~w~, ESTAMOS CALCULANDO PEÇAS",4,0.50,0.87,0.50,255,255,255,180)
				elseif segundos < 19 and segundos > 16 then
					drawTxt("AGUARDE ~g~"..segundos.." SEGUNDOS~w~, PEÇAS CALCULADAS",4,0.50,0.87,0.50,255,255,255,180)
				elseif segundos <= 16 and segundos >= 4 then
					drawTxt("AGUARDE ~g~"..segundos.." SEGUNDOS~w~, DESMANCHANDO ",4,0.50,0.87,0.50,255,255,255,180)
				elseif segundos < 4 then
					drawTxt("AGUARDE ~g~"..segundos.." SEGUNDOS~w~, FINALIZANDO DESMANCHE ",4,0.50,0.87,0.50,255,255,255,180)
				end
			else
				segundos = 0
				roubando = false
				break
			end
			Wait(0)
		end
	end)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local idle = 1000
		if roubando then
			idle = 5
			BlockWeaponWheelThisFrame()
			DisableControlAction(0,21,true)
			DisableControlAction(0,22,true)
			DisableControlAction(0,24,true)
			DisableControlAction(0,25,true)
			DisableControlAction(0,29,true)
			DisableControlAction(0,32,true)
			DisableControlAction(0,33,true)
			DisableControlAction(0,34,true)
			DisableControlAction(0,35,true)
			DisableControlAction(0,56,true)
			DisableControlAction(0,58,true)
			DisableControlAction(0,73,true)
			DisableControlAction(0,75,true)
			DisableControlAction(0,140,true)
			DisableControlAction(0,141,true)
			DisableControlAction(0,142,true)
			DisableControlAction(0,143,true)
			DisableControlAction(0,166,true)
			DisableControlAction(0,167,true)
			DisableControlAction(0,170,true)
			DisableControlAction(0,177,true)
			DisableControlAction(0,182,true)
			DisableControlAction(0,187,true)
			DisableControlAction(0,188,true)
			DisableControlAction(0,189,true)
			DisableControlAction(0,190,true)
			DisableControlAction(0,243,true)
			DisableControlAction(0,245,true)
			DisableControlAction(0,246,true)
			DisableControlAction(0,257,true)
			DisableControlAction(0,263,true)
			DisableControlAction(0,264,true)
			DisableControlAction(0,268,true)
			DisableControlAction(0,269,true)
			DisableControlAction(0,270,true)
			DisableControlAction(0,271,true)
			DisableControlAction(0,288,true)
			DisableControlAction(0,289,true)
			DisableControlAction(0,303,true)
			DisableControlAction(0,311,true)
			DisableControlAction(0,344,true)
		end
		Wait(idle)
	end
end)