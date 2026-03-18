-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt", "lib/Tunnel")
local Proxy = module("revolt", "lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Imperio = {}
Tunnel.bindInterface("skinshop", Imperio)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK
-----------------------------------------------------------------------------------------------------------------------------------------
function Imperio.Check()
	local source = source
	local Passport = rEVOLT.getUserId(source)
	if Passport and not exports["hud"]:Reposed(Passport) and not exports["hud"]:Wanted(Passport, source) then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Imperio.Update(Clothes,Spawn)
	local source = source
	local Passport = rEVOLT.getUserId(source)
	if Passport then
		rEVOLT.Query("playerdata/SetData",{ Passport = Passport, dkey = "Clothings", dvalue = json.encode(Clothes) })
		if Spawn then
			rEVOLT.Query("playerdata/SetData", { Passport = Passport, dkey = "Creator", dvalue = json.encode(1) })
			TriggerEvent("rEVOLT:BucketServer", source, "Exit")
			TriggerClientEvent("sounds:Private",source,"shop",1.0)
			Wait(1000)
			local Bags = { "prop_luggage_01a", "prop_luggage_02a", "prop_luggage_03a", "prop_luggage_04a", "prop_luggage_05a", "prop_luggage_06a", "prop_luggage_07a", "prop_luggage_08a", "prop_big_bag_01", "xm_prop_x17_bag_01d" }
			rEVOLTC.createObjects(source,"move_weapon@jerrycan@generic","idle",Bags[math.random(#Bags)],50,57005,0.425,0.0,0.025, 0, 260.0,  60.0)

		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOP:REMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("skinshop:Remove")
AddEventHandler("skinshop:Remove", function(Mode)
	local source = source
	local Passport = rEVOLT.getUserId(source)
	if Passport then
		local ClosestPed = rEVOLTC.ClosestPed(source, 3)
		if ClosestPed then
			if rEVOLT.HasService(Passport, "Policia") then
				TriggerClientEvent("skinshop:set" .. Mode, ClosestPed)
			end
		end
	end
end)