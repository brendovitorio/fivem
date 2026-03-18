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
Tunnel.bindInterface("tractor",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Experience = rEVOLT.GetExperience(Passport,"Tractor")
		local Level = ClassCategory(Experience)
		local Valuation = 800

		if Level == 2 or Level == 3 or Level == 5 then
			Valuation = Valuation + 10
		elseif Level == 6 or Level == 7 or Level == 8 then
			Valuation = Valuation + 15
		elseif Level == 9 or Level == 10 then
			Valuation = Valuation + 20
		end

		if Buffs["Dexterity"][Passport] then
			if Buffs["Dexterity"][Passport] > os.time() then
				Valuation = Valuation + (Valuation * 0.1)
			end
		end

		rEVOLT.PutExperience(Passport,"Taxi",1)
		rEVOLT.GenerateItem(Passport,"dollars",Valuation,true)
		TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",Valuation)
	end
end