-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTS = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("hud",Creative)
vSERVER = Tunnel.getInterface("hud")
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBAL
-----------------------------------------------------------------------------------------------------------------------------------------
Display = true
-----------------------------------------------------------------------------------------------------------------------------------------
-- STARTUP STATE
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1500)
	Display = true
	HudSend({ hudIsActive = true })
	DisplayRadar(false)
end)

local function UpdateRadarVisibility()
	local Ped = PlayerPedId()
	local ShouldShow = Display and IsPedInAnyVehicle(Ped)
	DisplayRadar(ShouldShow)
end

-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Road = ""
local Gemstone = 0
local Crossing = ""
local Hood = false
-----------------------------------------------------------------------------------------------------------------------------------------
-- PRINCIPAL
-----------------------------------------------------------------------------------------------------------------------------------------
local Health = 999
local Armour = 999
-----------------------------------------------------------------------------------------------------------------------------------------
-- THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
local Thirst = 999
local ThirstTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
local Hunger = 999
local HungerTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
local Stress = 999
local StressTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
local Wanted = 0
local WantedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
local Reposed = 0
local ReposedTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
local Luck = 0
local LuckTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
local Dexterity = 0
local DexterityTimer = 0
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADTIMER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		if LocalPlayer["state"]["Active"] then
			local Ped = PlayerPedId()

			if IsPauseMenuActive() then
				HudToggle(false)
			else
				if Display then

					local Coords = GetEntityCoords(Ped)
					local Armouring = GetPedArmour(Ped)
					local Healing = GetEntityHealth(Ped) - 100
					local Stamina = 100 - GetPlayerSprintStaminaRemaining(PlayerId())
					local MinRoad,MinCross = GetStreetNameAtCoord(Coords["x"],Coords["y"],Coords["z"])
					local FullRoad = GetStreetNameFromHashKey(MinRoad)
					local FullCross = GetStreetNameFromHashKey(MinCross)
					local Heading = GetEntityHeading(Ped)
					local Directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
					local Direction = Directions[math.floor((Heading + 22.5) / 45.0) % 8 + 1]

					if Health ~= Healing then
						if Healing < 0 then Healing = 0 end
						HudSend({ heart = Healing })
						Health = Healing
					end

					if Armour ~= Armouring then
						HudSend({ armour = Armouring })
						Armour = Armouring
					end

					if FullRoad ~= "" and Road ~= FullRoad then
						HudSend({ location = FullRoad, direction = Direction })
						Road = FullRoad
					end

					if FullCross ~= "" and Crossing ~= FullCross then
						HudSend({ crossing = FullCross, direction = Direction })
						Crossing = FullCross
					end
					HudSend({ userId = LocalPlayer["state"]["Passport"] })
					HudSend({ stamina = parseInt(Stamina), hour = GlobalState["Hours"] ..":".. GlobalState["Minutes"], weather = tostring(GlobalState["Weather"] or "CLEAR"), direction = Direction })
				end
			end

			if Luck > 0 and LuckTimer <= GetGameTimer() then
				Luck = Luck - 1
				LuckTimer = GetGameTimer() + 1000
				HudSend({ name = "Luck", payload = Luck })
			end

			if Dexterity > 0 and DexterityTimer <= GetGameTimer() then
				Dexterity = Dexterity - 1
				DexterityTimer = GetGameTimer() + 1000
				HudSend({ name = "Dexterity", payload = Dexterity })
			end

			if Wanted > 0 and WantedTimer <= GetGameTimer() then
				Wanted = Wanted - 1
				WantedTimer = GetGameTimer() + 1000
				HudSend({ starIsActive = true, stars = math.min(math.floor(Wanted / 100), 5) })
			else
				HudSend({ starIsActive = false, stars = 0 })
			end
			
			if Reposed > 0 and ReposedTimer <= GetGameTimer() then
				Reposed = Reposed - 1
				ReposedTimer = GetGameTimer() + 1000
				HudSend({ name = "Reposed", payload = Reposed })
			end

			if HungerTimer <= GetGameTimer() then
				HungerTimer = GetGameTimer() + 10000
				if GetEntityHealth(Ped) > 100 then
					if Hunger < 10 then
						ApplyDamageToPed(Ped,math.random(2),false)
					end
					if Hunger < 20 then
						TriggerEvent("Notify","amarelo","Sofrendo de fome.",2500)
					end
				end
			end

			if ThirstTimer <= GetGameTimer() then
				ThirstTimer = GetGameTimer() + 10000
				if GetEntityHealth(Ped) > 100 then
					if Thirst < 10 then
						ApplyDamageToPed(Ped,math.random(2),false)
					end
					if Thirst < 20 then
						TriggerEvent("Notify","amarelo","Sofrendo de sede.",2500)
					end
				end
			end

			-- if StressTimer <= GetGameTimer() then
			-- 	StressTimer = GetGameTimer() + 20000
			-- 	if Stress >= 80 then
			-- 		ApplyDamageToPed(Ped,math.random(2),false)
			-- 		TriggerEvent("Notify","amarelo","Sofrendo de stress.",2500)
			-- 		ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.10)
			-- 		if not IsPedInAnyVehicle(ped) and parseInt(math.random(3)) >= 3 then
			-- 			SetPedToRagdoll(ped,5000,5000,0,0,0,0)
			-- 		end
			-- 	elseif Stress >= 60 and Stress <= 79 then
			-- 		ApplyDamageToPed(Ped,math.random(2),false)
			-- 		TriggerEvent("Notify","amarelo","Sofrendo de stress.",2500)
			-- 		ShakeGameplayCam("LARGE_EXPLOSION_SHAKE",0.05)
			-- 		if not not IsPedInAnyVehicle(ped) and parseInt(math.random(3)) >= 3 then
			-- 			SetPedToRagdoll(Ped,2500,2500,0,0,0,0)
			-- 		end
			-- 	end
			-- end


		end

		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- ADDSTATEBAGCHANGEHANDLER:INSAFEZONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddStateBagChangeHandler("Safezone",("player:%s"):format(LocalPlayer["state"]["Player"]),function(Name,Key,Value)
	HudSend({ name = "Safezone", payload = Value })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOIP
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voip")
AddEventHandler("hud:Voip",function(Number)
	local Target = { "Baixo","Normal","Médio","Alto","Megafone" }
	HudSend({ talkIsActive = Target[tonumber(Number)] })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:VOICE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Voice")
AddEventHandler("hud:Voice",function(Status)
	HudSend({ isTalking = Status })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Wanted")
AddEventHandler("hud:Wanted",function(Seconds)
	Wanted = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WANTED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Wanted",function()
	return Wanted > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Reposed")
AddEventHandler("hud:Reposed",function(Seconds)
	Reposed = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- REPOSED
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Reposed",function()
	return Reposed > 0 and true or false
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ACTIVE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Active")
AddEventHandler("hud:Active",function(Status)
	Display = Status and true or false
	HudSend({ hudIsActive = Display })
	UpdateRadarVisibility()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("hud",function()
	Display = not Display
	HudSend({ hudIsActive = Display })
	UpdateRadarVisibility()
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROGRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("Progress")
AddEventHandler("Progress",function(Timer)
	HudSend({ name = "Progress", payload = Timer })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLECONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleConnected",function()
	HudSend({ talkIsActive = "Normal" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- MUMBLEDISCONNECTED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("mumbleDisconnected",function()
	HudSend({ talkIsActive = "Offline" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:THIRST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Thirst")
AddEventHandler("hud:Thirst",function(Number)
	if Thirst ~= Number then
		HudSend({ thirst = Number })
		Thirst = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:HUNGER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Hunger")
AddEventHandler("hud:Hunger",function(Number)
	if Hunger ~= Number then
		HudSend({ hunger = Number })
		Hunger = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:STRESS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Stress")
AddEventHandler("hud:Stress",function(Number)
	if Stress ~= Number then
		HudSend({ stress = Number })
		Stress = Number
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:LUCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Luck")
AddEventHandler("hud:Luck",function(Seconds)
	Luck = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:DEXTERITY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Dexterity")
AddEventHandler("hud:Dexterity",function(Seconds)
	Dexterity = Seconds
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:TOGGLEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:toggleHood")
AddEventHandler("hud:toggleHood",function()
	Hood = not Hood

	if Hood then
		SetPedComponentVariation(PlayerPedId(),1,69,0,1)
	else
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end

	HudSend({ Action = "Hood", Status = Hood })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEHOOD
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveHood")
AddEventHandler("hud:RemoveHood",function()
	if Hood then
		Hood = false
		HudSend({ Action = "Hood", Status = Hood })
		SetPedComponentVariation(PlayerPedId(),1,0,0,1)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:ADDGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:AddGems")
AddEventHandler("hud:AddGems",function(Number)
	Gemstone = Gemstone + Number
	HudSend({ diamond = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:REMOVEGEMS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:RemoveGems")
AddEventHandler("hud:RemoveGems",function(Number)
	Gemstone = Gemstone - Number
	if Gemstone < 0 then
		Gemstone = 0
	end
	HudSend({ diamond = Gemstone })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- HUD:RADIO
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("hud:Radio")
AddEventHandler("hud:Radio",function(Frequency)
	HudSend({ mhz = Frequency })
end)