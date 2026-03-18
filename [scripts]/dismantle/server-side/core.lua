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
Tunnel.bindInterface("dismantle",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkVehicle(Plate)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Vehicle = rEVOLT.PassportPlate(Plate)
		if Vehicle then
			if Vehicle["Passport"] ~= Passport then
				if Vehicle["arrest"] >= os.time() then
					TriggerClientEvent("Notify",source, "vermelho","Veículo encontra-se apreendido na seguradora.")	
				else
					return VehicleMode(Vehicle["vehicle"]) ~= "work"
				end
			end
		else
			TriggerClientEvent("Notify",source, "vermelho","Veículo não encontrado na lista de proprietário.")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPermission(Perm)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if rEVOLT.HasGroup(Passport,Perm,1) then
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.checkPayment(Plate)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if not Active[Passport] or Active[Passport] <= os.time() then
		Active[Passport] = os.time() + 2
		local Vehicle = rEVOLT.PassportPlate(Plate)
		if Vehicle then
			local Price = VehiclePrice(Vehicle["vehicle"])
			local Valuation = (VehicleMode(Vehicle["vehicle"]) == "Rental" and 20000) or (Price <= 0 and 10000) or parseInt(Price*0.1)
			if Vehicle["Passport"] ~= Passport then
				rEVOLT.Query("vehicles/arrestVehicles",{ Passport = Vehicle["Passport"], vehicle = Vehicle["vehicle"] })
				TriggerClientEvent("garages:Delete",source)
				rEVOLT.GenerateItem(Passport,"dollars2",Valuation,true)
				if math.random(100) >= 75 then
					rEVOLT.GenerateItem(Passport,"plate",1,true)
				end
			end
		end	
	end
end