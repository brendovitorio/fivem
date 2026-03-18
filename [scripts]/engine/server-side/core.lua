-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
RevoltC = Tunnel.getInterface("Revolt")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("engine",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicles = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENTFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.paymentFuel(Price,Plate,vehFuel,LastFuel,Network)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Players = RevoltC.Players(source)

		if rEVOLT.PaymentFull(Passport,Price) then
			for _,v in pairs(Players) do
				async(function()
					TriggerClientEvent("engine:syncFuel",v,Plate,vehFuel,Network)
				end)
			end

			return true
		else
			for _,v in ipairs(Players) do
				async(function()
					TriggerClientEvent("engine:syncFuel",v,Plate,LastFuel,Network)
				end)
			end

			TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLEFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.vehicleFuel(Plate)
	if not Vehicles[Plate] and Plate then
		Vehicles[Plate] = 50
	end

	return Vehicles[Plate]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRYFUEL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("engine:tryFuel")
AddEventHandler("engine:tryFuel",function(Plate,vehFuel)
	if Plate ~= nil then
		Vehicles[Plate] = vehFuel
	end
end)