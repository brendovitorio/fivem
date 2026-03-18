-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("bennys",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- EMERGENCY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Emergency(Name)
    local source = source
    local Passport = rEVOLT.Passport(source)
    if Passport then
        local restrictedVehicles = {
            "ambulance2",
            "B412",
			"maverick2",
			"bmwm3",
			"m4cs",
			"bmwm5",
			"e63",
			"fpace",
			"jettagli",
			"tiger900",
			"tundra"
        }
        for _, vehicle in ipairs(restrictedVehicles) do
            if Name == vehicle then
                TriggerClientEvent("Notify",source,"amarelo","Esse veículo não é permitido.",10000)
                return false
            end
        end
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKPERMISSIONS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPermission(hasPerm)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if exports["hud"]:Wanted(Passport,source) then
			return false
		end
		if not hasPerm then
			return true
		else
			if rEVOLT.HasService(Passport,hasPerm) then
				return true
			end
		end
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bennys:attemptPurchase")
AddEventHandler("bennys:attemptPurchase",function(type,mod)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if type == "engines" or type == "brakes" or type == "transmission" or type == "suspension" or type == "shield" then
			local Price = vehicleCustomisationPrices[type][mod]
			if rEVOLT.PaymentFull(Passport,Price,"Mecânica") then
				TriggerClientEvent("bennys:purchaseSuccessful",source)
			else
				TriggerClientEvent("bennys:purchaseFailed",source)
			end
		else
			if rEVOLT.PaymentFull(Passport,vehicleCustomisationPrices[type],"Mecânica") then
				TriggerClientEvent("bennys:purchaseSuccessful",source)
			else
				TriggerClientEvent("bennys:purchaseFailed",source)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("bennys:updateVehicle")
AddEventHandler("bennys:updateVehicle",function(Mods,Plate,vehName)
	local Passport = rEVOLT.PassportPlate(Plate)
	if Passport then
		rEVOLT.Query("entitydata/SetData",{ dkey = "Mods:"..Passport["Passport"]..":"..vehName, dvalue = json.encode(Mods) })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
local inVehicle = {}
RegisterServerEvent("bennys:inVehicle")
AddEventHandler("bennys:inVehicle",function(Network,Plate)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if not Network then
			if inVehicle[Passport] then
				inVehicle[Passport] = nil
			end
		else
			inVehicle[Passport] = { Network,Plate }
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if inVehicle[Passport] then
		Wait(1000)
		TriggerEvent("garages:deleteVehicle",inVehicle[Passport][1],inVehicle[Passport][2])
		inVehicle[Passport] = nil
	end
end)