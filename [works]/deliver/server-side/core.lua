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
Tunnel.bindInterface("deliver",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INITLIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	["BurgerShot"] = { 
		["bsmoneyshot"] = { ["min"] = 1, ["max"] = 3},
		["bsbleederburger"] = { ["min"] = 1, ["max"] = 3},
		["bsheartstopper"] = { ["min"] = 1, ["max"] = 3},
		["bsnuggets"] = { ["min"] = 1, ["max"] = 3},
		["bsfries"] = { ["min"] = 1, ["max"] = 3},
		["bsrings"] = { ["min"] = 1, ["max"] = 3},
		["bsdrink"] = { ["min"] = 1, ["max"] = 3},
		["softdrink"] = { ["min"] = 1, ["max"] = 3},
		["bscoffee"] = { ["min"] = 1, ["max"] = 3},
	},
	["CluckinBell"] = { 
		["chickenfries"] = { ["min"] = 1, ["max"] = 3},
		["cbfowl"] = { ["min"] = 1, ["max"] = 3},
		["cbveggy"] = { ["min"] = 1, ["max"] = 3},
		["cbdrink"] = { ["min"] = 1, ["max"] = 3},
		["cbballs"] = { ["min"] = 1, ["max"] = 3},
		["cbbucket"] = { ["min"] = 1, ["max"] = 3},
		["cbfries"] = { ["min"] = 1, ["max"] = 3},
		["cbrings"] = { ["min"] = 1, ["max"] = 3},
	},
	["Milkman"] = { 
		["milkbottle"] = { ["min"] = 3, ["max"] = 6} 
	},
	["Lumberman"] = { 
		["woodlog"] = { ["min"] = 2, ["max"] = 4} 
	},
	["Transporter"] = { 
		["pouch"] = { ["min"] = 1, ["max"] = 2} 
	},
	["Postalman"] = { 
		["postcard"] = { ["min"] = 1, ["max"] = 2}, 
		["postenvelope"] = { ["min"] = 1, ["max"] = 2}, 
		["postbox"] = { ["min"] = 1, ["max"] = 2}, 
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BUFFS
-----------------------------------------------------------------------------------------------------------------------------------------
Buffs = {
	["Dexterity"] = {},
	["Luck"] = {}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELIVER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Deliver(Name,Payment)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Sucess = false
		local Inventory = rEVOLT.Inventory(Passport)
		for Slot,Value in pairs(Inventory) do
			if List[Name][SplitOne(Value["item"],"-")] then
				local Amount = math.random(List[Name][SplitOne(Value["item"],"-")]["min"],List[Name][SplitOne(Value["item"],"-")]["max"])
				if Inventory[Slot]["amount"] >= Amount then 
					Inventory[Slot]["amount"] = Amount 
				end
				if rEVOLT.TakeItem(Passport,Value["item"],parseInt(Inventory[Slot]["amount"]),true) then
					local Experience = rEVOLT.GetExperience(Passport,Name)
					local Level = ClassCategory(Experience)
					local Valuation = Payment
	
					if Level == 2 or Level == 3 then
						Valuation = Valuation + 25
					elseif Level == 4 or Level == 5 then
						Valuation = Valuation + 30
					elseif Level == 6 or Level == 7 then
						Valuation = Valuation + 35
					elseif Level == 8 or Level == 9 then
						Valuation = Valuation + 40
					elseif Level == 10 then
						Valuation = Valuation + 50
					end
	
					if Buffs["Dexterity"][Passport] and Buffs["Dexterity"][Passport] > os.time() then
						Valuation = Valuation + (Valuation * 0.1)
					end
	
					if math.random(100) <= 30 then
						rEVOLT.UpgradeStress(Passport,1)
					end
	
					rEVOLT.GenerateItem(Passport,"dollars",Valuation*Inventory[Slot]["amount"],true)
	
					if rEVOLT.HasGroup(Passport,"Ilegal") then
						local dollars2 = rEVOLT.ItemAmount(Passport, "dollars2")
						if dollars2 >= parseInt(500*Inventory[Slot]["amount"]) then dollars2 = parseInt(500*Inventory[Slot]["amount"]) end
						if rEVOLT.TakeItem(Passport, "dollars2", dollars2, true) then
							rEVOLT.GenerateItem(Passport,"dollars",dollars2, true)
						end
					end

					rEVOLT.PutExperience(Passport,Name,1)  
					if math.random(100) <= 60 then
						Sucess = true
					else
						return true
					end
				end
			end
		end
		if not Sucess then
			TriggerClientEvent("Notify",source,"amarelo","Volte ao "..Name.." e busque mais itens.",5000,"Atenção")
		end
		return Sucess	
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Permission)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if rEVOLT.Groups()[Permission] then
			if rEVOLT.HasGroup(Passport, Permission) then
				if rEVOLT.HasService(Passport,Permission) then
					return true
				end
			else
				TriggerClientEvent("Notify",source,"amarelo","Apenas funcionários podem trabalhar.",5000,"Atenção")
			end
		else
			return true
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:BUFFSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("inventory:BuffServer",function(source,Passport,Name,Amount)
	if not Buffs[Name][Passport] then
		Buffs[Name][Passport] = 0
	end
	if os.time() >= Buffs[Name][Passport] then
		Buffs[Name][Passport] = os.time() + Amount
	else
		Buffs[Name][Passport] = Buffs[Name][Passport] + Amount
		if (Buffs[Name][Passport] - os.time()) >= 3600 then
			Buffs[Name][Passport] = os.time() + 3600
		end
	end
	TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	for Name,_ in pairs(Buffs) do
		if Buffs[Name][Passport] then
			if os.time() < Buffs[Name][Passport] then
				TriggerClientEvent("hud:"..Name,source,Buffs[Name][Passport] - os.time())
			end
		end
	end
end)