-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("speedcam:Syncleds")
AddEventHandler("speedcam:Syncleds",function(Value,Speed,Players)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("speedcam:Syncleds",v,Value,Speed)
			end)
		end
		if Speed > Value.limit+1 then
			--TriggerClientEvent("Notify",source,"amarelo","Velocidade Excedida a " .. Speed .. " Mp/h.",8000,"Radar")
			TriggerClientEvent("chat:ClientMessage",source,false,"Velocidade Excedida a " .. Speed .. " Mp/h.","Multa")
			TriggerClientEvent("sounds:Private",source,"speedcamera",0.1)
			local Name = rEVOLT.Identities(Passport).name .. " " .. rEVOLT.Identities(Passport).name2
			rEVOLT.Query("fines/Add", {Passport = Passport, Name = Name,Date = os.date("%d/%m/%Y"),Hour = os.date("%H:%M"),Value = Speed*2,Message = "Multa de Velocidade"}) 
		else
			--TriggerClientEvent("Notify",source,"amarelo","Velocidade Registrada a " .. Speed ..  " Mp/h.",8000,"Radar")
			TriggerClientEvent("chat:ClientMessage",source,false,"Velocidade Registrada a " .. Speed ..  " Mp/h.","Radar")
		end
	end
end)