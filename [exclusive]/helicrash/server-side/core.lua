-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local LootBoxes = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Helicrash"] = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOOTS
-----------------------------------------------------------------------------------------------------------------------------------------
local Loots = {
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_M1911-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_9", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_MP9-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_45", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_MP5-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_45", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_UZI-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_45", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_MAC10-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_45", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_AK47-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_762", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_AK74-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_762", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_AKS74-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_762", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
	{
		["1"] = { item = "analgesic", amount = 4 },
		["2"] = { item = "meth", amount = 4 },
		["3"] = { item = "gauze", amount = 4},
		["4"] = { item = "WEAPON_M70-"..os.time(), amount = 1 },
		["5"] = { item = "AMMO_762", amount = 100 },
		["6"] = { item = "dollars2", amount = 10000 }
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTICK
-----------------------------------------------------------------------------------------------------------------------------------------
local function ThreadTick()
	if TimersNotify[os.date("%H:%M")] then
		TriggerClientEvent("Notify",-1,"azul","A torre de controle recebeu a informação que uma <b>Aeronave</b> está com problemas mecânicos e está em queda livre, parece que em <b>5 minutos</b> a mesma vai colidir com o solo.",30000,"Queda de Aeronave")
	end
	if Timers[os.date("%H:%M")] and not GlobalState["Helicrash"] then
		LootBoxes = 0
		local Selected = math.random(#Components)
		for Number,v in pairs(Components[Selected]) do
			if Number ~= "1" then
				LootBoxes = LootBoxes + 1
				local Loot = math.random(#Loots)
				rEVOLT.RemSrvData("Helicrash:"..Number,false)
				TriggerEvent("chest:Cooldown","Helicrash:"..Number)
				rEVOLT.SetSrvData("Helicrash:"..Number,Loots[Loot],false)
			end
		end
		TriggerClientEvent("Notify",-1,"azul","Mayday! Mayday! Tivemos problemas técnicos em nossos motores e estamos em queda livre.",30000,"Queda de Aeronave")
		GlobalState["Helicrash"] = Selected
	end
	SetTimeout(30000,ThreadTick)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTICKINIT
-----------------------------------------------------------------------------------------------------------------------------------------
ThreadTick()
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOX
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Box",function()
	if GlobalState["Helicrash"] then
		LootBoxes = LootBoxes - 1
		if LootBoxes <= 0 then
			GlobalState["Helicrash"] = false
			LootBoxes = 0
		end
	end
end)