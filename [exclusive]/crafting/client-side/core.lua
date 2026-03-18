-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("crafting",Creative)
vSERVER = Tunnel.getInterface("crafting")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFTING
-----------------------------------------------------------------------------------------------------------------------------------------
local Crafting = {
	{ vec3(-355.75,-1555.85,25.17),"Lixeiro" },
	{ vec3(287.36,2843.6,44.7),"Lixeiro" },
	{ vec3(-413.68,6171.99,31.48),"Lixeiro" },
	{ vec3(2741.5,3464.06,55.69),"Mercado" },
	{ vec3(-29.57,-1655.14,29.49),"Mercado" },
	{ vec3(1084.82,-2002.8,31.37),"Foundry" },

	{ vec3(-1194.93,-897.56,13.88),"BurgerShot" },
	{ vec3(-1196.1,-900.14,13.88),"BurgerShot2" },
	{ vec3(-1190.5,-898.53,13.88),"BurgerShot3" },
	{ vec3(-1200.55,-896.63,13.88),"BurgerShot4" },

	{ vec3(-514.65,-699.19,33.18),"CluckinBell" },
	{ vec3(-516.31,-700.32,33.18),"CluckinBell2" },
	{ vec3(-520.93,-701.34,33.18),"CluckinBell3" },
	--[[ { vec3(-517.92,-702.47,33.18),"CluckinBell4" }, ]]
	

	{ vec3(-1308.39,-291.54,36.82),"Mechanic" },
	{ vec3(-1301.77,-288.03,36.82),"Mechanic" },
	{ vec3(-1294.85,-284.3,36.82),"Mechanic" },
	{ vec3(-1288.44,-280.87,36.82),"Mechanic" },
	
	{ vec3(870.78,-2123.73,30.4),"Mechanic" },
	{ vec3(878.25,-2131.39,30.4),"Mechanic" },
	{ vec3(889.38,-2132.39,30.4),"Mechanic" },
	{ vec3(900.24,-2133.27,30.4),"Mechanic" },
	{ vec3(911.41,-2134.27,30.4),"Mechanic" },
	{ vec3(914.62,-2127.21,30.4),"Mechanic" },
	{ vec3(916.4,-2105.81,30.4),"Mechanic" },

	{ vec3(412.63,3.55,84.92),"Ilegal2" },
	{ vec3(1487.77,1129.3,114.17),"Ilegal2" },
	{ vec3(-1871.09,2062.03,135.44),"Ilegal3" },
	{ vec3(-1522.95,111.38,50.03),"Ilegal3" },
	{ vec3(157.47,-1713.2,25.78),"Ilegal4" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Number,v in pairs(Crafting) do
		exports["target"]:AddCircleZone("Crafts:"..Number,vec3(v[1][1],v[1][2],v[1][3]),0.35,{
			name = "Crafts:"..Number,
		},{
			shop = v[2],
			Distance = 2.75,
			options = {
				{
					event = "crafting:Open",
					label = "Abrir",
					tunnel = "shop"
				}
			}
		})
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY:CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("inventory:Close")
AddEventHandler("inventory:Close",function()
	SetNuiFocus(false,false)
	SetCursorLocation(0.5,0.5)
	SendNUIMessage({ Action = "Close" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("close",function(Data,Callback)
	SendNUIMessage({ Action = "Close" })
	SetNuiFocus(false,false)
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Request",function(Data,Callback)
	local Endpoint = GetCurrentServerEndpoint():gsub(":(%d+)$","").."/revolt_base"
	local Crafting,Inventory,invPeso,invMaxpeso,craftSlots = vSERVER.Request(Data["name"])
	if Crafting then
		Callback({ Endpoint = Endpoint, Crafting = Crafting, Inventory = Inventory, invPeso = invPeso, invMaxpeso = invMaxpeso, craftSlots = craftSlots })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUESTBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Trade",function(Data,Callback)
	PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 1)
	if not vSERVER.Trade(Data["name"],Data["item"],Data["amount"],Data["slot"],Data["target"]) then
		SetNuiFocus(false,false)
		SetCursorLocation(0.5,0.5)
		SendNUIMessage({ Action = "Close" })
	end
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("Update",function(Data,Callback)
	PlaySoundFrontend(-1, "CLICK_BACK", "WEB_NAVIGATION_SOUNDS_PHONE", 1)
	vSERVER.Update(Data["slot"],Data["target"],Data["amount"])
	Callback("Ok")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("crafting:Update")
AddEventHandler("crafting:Update",function(Action)
	SendNUIMessage({ Action = Action })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CRAFT:OPEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("crafting:Open",function(Name)
	if not exports["hud"]:Wanted() and vSERVER.Permission(Name) then
		SetNuiFocus(true,true)
		SendNUIMessage({ Action = "Open", name = Name, type = List[Name]["Mode"] })
	end
end)