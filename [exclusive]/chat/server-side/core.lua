-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHAT:SERVERMESSAGE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("chat:ServerMessage")
AddEventHandler("chat:ServerMessage",function(Message,Mode)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Identity = rEVOLT.Identities(Passport)
		local Messages = Message:gsub("[<>]","")
		TriggerClientEvent("chat:ClientMessage",source,Identity["name"].." "..Identity["name2"],Mode,Messages)

		local Players = rEVOLTC.ClosestPeds(source,10)
		for _,v in pairs(Players) do
			async(function()
				TriggerClientEvent("chat:ClientMessage",Identity["name"].." "..Identity["name2"],Mode,Messages)
			end)
		end
	end
end)