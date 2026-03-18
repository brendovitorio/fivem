-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("bus",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PED
-----------------------------------------------------------------------------------------------------------------------------------------
local Entity = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PAYMENT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Payment(Distance)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Experience = rEVOLT.GetExperience(Passport,"Bus")
		local Level = ClassCategory(Experience)
		local Valuation = Distance and parseInt(Distance * 0.05) or 100

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

		rEVOLT.PutExperience(Passport,"Bus",1)
		rEVOLT.GenerateItem(Passport,"dollars",Valuation,true)
		TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",Valuation)
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SALARY
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Salary()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Experience = rEVOLT.GetExperience(Passport,"Bus")
		local Level = ClassCategory(Experience)
		local Valuation = 1000

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

		rEVOLT.GiveBank(Passport, Valuation)
		rEVOLT.PutExperience(Passport,"Bus",1)
		TriggerClientEvent("sounds:Private",source,"coins",0.25)
		TriggerEvent("inventory:BuffServer",source,Passport,"Dexterity",Valuation)
		TriggerClientEvent("Notify",source,"verde","Recebeu <b>$"..parseFormat(1200).."</b> em sua conta bancária.",5000,"Salário Motorista")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.insuranceUnemployment(Amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Amount >= 30 then
			local Experience = rEVOLT.GetExperience(Passport,"Bus")
			local Level = ClassCategory(Experience)
			local Valuation = 500*Amount
	
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
	
			rEVOLT.GiveBank(Passport, Valuation)
			TriggerClientEvent("sounds:Private",source,"coins",0.25)
			TriggerClientEvent("Notify",source,"verde","Recebeu <b>$"..parseFormat(1200).."</b> em sua conta bancária.",5000,"Seguro-Desemprego")
		end
	end
end