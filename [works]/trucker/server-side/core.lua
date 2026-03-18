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
Tunnel.bindInterface("trucker",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Active = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not Active[Passport] then
		Active[Passport] = true

		local Experience = rEVOLT.GetExperience(Passport,"Trucker")
		local Level = ClassCategory(Experience)
		local Valuation = math.random(1225,1525)
		if Level == 2 then
			Valuation = Valuation + 100
		elseif Level == 3 then
			Valuation = Valuation + 125
		elseif Level == 4 then
			Valuation = Valuation + 150
		elseif Level == 5 then
			Valuation = Valuation + 175
		elseif Level == 6 then
			Valuation = Valuation + 200
		elseif Level == 7 then
			Valuation = Valuation + 225
		elseif Level == 8 then
			Valuation = Valuation + 250
		elseif Level == 9 then
			Valuation = Valuation + 275
		elseif Level == 10 then
			Valuation = Valuation + 300
		end
		local Buffs = exports["inventory"]:Buffs("Dexterity",Passport)
		if Buffs and Buffs > os.time() then
			Valuation = Valuation + (Valuation * 0.1)
		end
		rEVOLT.PutExperience(Passport,"Trucker",3)
		rEVOLT.GenerateItem(Passport,"dollars",Valuation,true)
		Active[Passport] = nil
	end
end