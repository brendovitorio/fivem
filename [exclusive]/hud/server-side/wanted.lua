-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Call = {}
local Wanted = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Wanted",function(source,Passport,Seconds)
	if Wanted[Passport] then
		if os.time() > Wanted[Passport] then
			Wanted[Passport] = os.time() + Seconds
		else
			Wanted[Passport] = Wanted[Passport] + Seconds
		end
	else
		Wanted[Passport] = os.time() + Seconds
	end

	TriggerClientEvent("hud:Wanted",source,Wanted[Passport] - os.time())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Wanted:Remove",function(source,Passport)
	if Wanted[Passport] then
		Wanted[Passport] = nil
	end

	TriggerClientEvent("hud:Wanted",source,0)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function(Passport,source)
	local source = parseInt(source)
	local Passport = parseInt(Passport)

	if Wanted[Passport] then
		if Wanted[Passport] > os.time() then
			if not Call[Passport] then
				Call[Passport] = os.time()
			end

			if Call[Passport] <= os.time() and source > 0 then
				Call[Passport] = os.time() + 60

				TriggerClientEvent("Notify",source,"amarelo","Você foi denunciado, parece que suas digitais<br>estão no banco de dados do governo como procurado.",false,5000)

				local Ped = GetPlayerPed(source)
				local Coords = GetEntityCoords(Ped)
				local Service = rEVOLT.NumPermission("Police")
				for Passports,Sources in pairs(Service) do
					async(function()
						TriggerClientEvent("NotifyPush",Sources,{ code = "QRU", title = "Digitais Encontradas", x = Coords["x"], y = Coords["y"], z = Coords["z"], criminal = "Alerta de procurado", time = "Recebido às "..os.date("%H:%M"), blipColor = 16 })
					end)
				end
			end
			
			return true
		end
	end

	return false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	if Wanted[Passport] then
		if Wanted[Passport] > os.time() then
			TriggerClientEvent("hud:Wanted",source,Wanted[Passport] - os.time())
		end
	end
end)