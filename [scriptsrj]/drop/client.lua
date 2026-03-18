local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")

rEVOLT = Proxy.getInterface("rEVOLT")

local drops = {}

AddEventHandler('gameEventTriggered', function(name, args)
    if name == 'CEventNetworkEntityDamage' then
        local ped = PlayerPedId()

        if GetEntityHealth(ped) <= 100 and ped == args[1] and IsPedAPlayer(args[2]) then
            local Index = NetworkGetPlayerIndexFromPed(args[2])
			local sourceKilled = GetPlayerServerId(Index)

            local playerId = PlayerId()
            local plyServerId = GetPlayerServerId(playerId)
            if sourceKilled ~= plyServerId then
                TriggerServerEvent('drop:playerDropItems')
            end
        end
    end
end)


RegisterNetEvent('drop:updateDropList', function(dropIndex, coords)
    drops[dropIndex] = {
        coords = coords,
    }
end)

CreateThread(function()
    while true do
        local timer = 1000

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local health = GetEntityHealth(ped)
        local playerServerId = GetPlayerServerId(PlayerId())

        for dropIndex, infos in pairs(drops) do
            local distance = #(coords - infos.coords)
            if not IsPedInAnyVehicle(ped) then  
                if distance <= 5.0 and dropIndex ~= playerServerId and health > 100 then
                    timer = 0

                    DrawText(infos.coords.x, infos.coords.y, infos.coords.z, "~g~APERTE   ~h~E~h~   PARA COLETAR" ,false)                

                    if distance <= 1.5 and IsControlJustPressed(0, 38) then
                        TriggerServerEvent('drop:collectItems', dropIndex)
                    end
                end
            end
        end

        Wait(timer)
    end
end)

RegisterNetEvent('drop:removeDrop', function(dropIndex)
    if drops[dropIndex] then
        drops[dropIndex] = nil
    end
end)


function DrawText(x,y,z,text,color)
	local onScreen,_x,_y = GetScreenCoordFromWorldCoord(x,y,z)

	if onScreen then
		BeginTextCommandDisplayText("STRING")
		AddTextComponentSubstringKeyboardDisplay(text)

		if color then
			SetTextColour(150,196,172,255)
		else
			SetTextColour(204,204,204,175)
		end

		SetTextScale(0.35,0.35)
		SetTextFont(4)
		SetTextCentre(1)
		EndTextCommandDisplayText(_x,_y)

		local width = string.len(text) / 300

		if color then
			DrawRect(_x,_y + 0.0125,width,0.03,162,124,219,200)
		else
			DrawRect(_x,_y + 0.0125,width,0.03,15,15,15,200)
		end
	end
end