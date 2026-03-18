local Tunnel <const>        = module("revolt", "lib/Tunnel")
local RESOURCE_NAME <const> = GetCurrentResourceName()
local Proxy <const>         = module("revolt", "lib/Proxy")

---@alias vector3 table

local CoreProxy              = Proxy.getInterface("rEVOLT")
local CoreTunnel             = Tunnel.getInterface("rEVOLT")
vRP                         = CoreProxy
vRPs                        = CoreTunnel

local function _hasHandcuffState(target)
    if type(target) == "number" and target ~= PlayerId() and GetPlayerFromServerId(target) ~= -1 then
        local ply = Player(GetPlayerFromServerId(target))
        return (ply and ply.state and ply.state.Handcuff) == true
    end
    return LocalPlayer and LocalPlayer.state and LocalPlayer.state.Handcuff == true
end

rEVOLT = setmetatable({
    isHandcuffed = function()
        return _hasHandcuffState()
    end,
    playAnim = function(upper, seq, loop, ...)
        if CoreTunnel and CoreTunnel.playAnim then
            return CoreTunnel.playAnim(upper, seq, loop, ...)
        end
    end,
    stopAnim = function(upper)
        if CoreTunnel and CoreTunnel.stopAnim then
            return CoreTunnel.stopAnim(upper)
        end
    end,
    getWeapons = function()
        local ped = PlayerPedId()
        local weapons = {}
        for item, info in pairs(Items or {}) do
            if info and info.type == "equip" then
                local weaponHash = GetHashKey(string.upper(item))
                if HasPedGotWeapon(ped, weaponHash, false) then
                    weapons[string.upper(item)] = { ammo = GetAmmoInPedWeapon(ped, weaponHash) or 0 }
                end
            end
        end
        return weapons
    end
},{ __index = CoreProxy or {} })

if not IsDuplicityVersion() and not _G["API"] then
    _G["API"] = {}
    Tunnel.bindInterface(RESOURCE_NAME, API)
end

RegisterNetEvent('bandagem:anim', function()
	exports.emergency_pack:useBandagearm()
end)

Remote = Tunnel.getInterface(RESOURCE_NAME)

function API.closeInventory(time)
    SendNUIMessage({
        route = "CLOSE_INVENTORY"
    })
    SetNuiFocus(false, false)
end

function API.checkInWater()
	return IsPedSwimmingUnderWater(PlayerPedId())
end

RegisterCommand("abrirmochilarevoada", function()
    if LocalPlayer.state.pvp or LocalPlayer.state.defuse_mode or vRP.isHandcuffed() or (GetEntityHealth(PlayerPedId()) <= 101) then
        TriggerEvent("Notify", "negado", "Você não pode acessar seu inventario agora.")
        return
    end

    SendNUIMessage({
        route = "OPEN_INVENTORY",
    })
    SetNuiFocus(true, true)
end, false)

CreateThread(function()
    RegisterKeyMapping("abrirmochilarevoada", "Abrir a mochila", "keyboard", "OEM_3")
    RegisterKeyMapping("openchest", "Trunkchest Open", "keyboard", "PAGEUP")
end)

function API.getActivePlayers()
    local response = {}
    local players = GetActivePlayers()
    for i = 1, #players do
        response[#response + 1] = GetPlayerServerId(players[i])
    end
    return response
end

function API.sendNuiEvent(ev)
    SendNUIMessage(ev)
end

CreateThread(function()
    SetNuiFocus(false, false)
end)

AddEventHandler(GetCurrentResourceName() .. ":sendNuiEvent", function(ev)
    if IsNuiFocused() and not IsNuiFocusKeepingInput() then
        SendNUIMessage(ev)
    end
end)

function API.getNearestPlayer(radius)
    local closest = false
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local limit = (tonumber(radius) or 2.0) + 0.0001
    for _, entity in pairs(GetGamePool("CPed")) do
        local index = NetworkGetPlayerIndexFromPed(entity)
        if index and entity ~= ped and IsPedAPlayer(entity) and NetworkIsPlayerConnected(index) then
            local dist = #(coords - GetEntityCoords(entity))
            if dist < limit then
                closest = GetPlayerServerId(index)
                limit = dist
            end
        end
    end
    return closest
end

function API.isHandcuffed(target)
    return _hasHandcuffState(target)
end

function API.playAnim(upper, seq, loop, ...)
    return rEVOLT.playAnim(upper, seq, loop, ...)
end

function API._playAnim(upper, seq, loop, ...)
    return rEVOLT.playAnim(upper, seq, loop, ...)
end

function API._stopAnim(upper)
    if rEVOLT.stopAnim then
        return rEVOLT.stopAnim(upper)
    end
end

function API._playSound(dict, name)
    PlaySoundFrontend(-1, dict, name, false)
end

function API.giveWeapons(weapons, clearBefore)
    local ped = PlayerPedId()
    if clearBefore then
        RemoveAllPedWeapons(ped, true)
    end
    for weapon, data in pairs(weapons or {}) do
        local hash = GetHashKey(weapon)
        GiveWeaponToPed(ped, hash, tonumber(data.ammo) or 0, false, false)
        SetPedAmmo(ped, hash, tonumber(data.ammo) or 0)
    end
    return true
end

function API.getWeapons()
    return rEVOLT.getWeapons()
end

function API.ModelName(radius)
    local ped = PlayerPedId()
    local vehicle = false
    local limit = (tonumber(radius) or 5.0) + 0.0001
    if IsPedInAnyVehicle(ped) then
        vehicle = GetVehiclePedIsUsing(ped)
    else
        local coords = GetEntityCoords(ped)
        for _, entity in pairs(GetGamePool("CVehicle")) do
            local dist = #(coords - GetEntityCoords(entity))
            if dist < limit then
                vehicle = entity
                limit = dist
            end
        end
    end
    if not vehicle or not DoesEntityExist(vehicle) then
        return false, false, false, false, false, false, false
    end
    local plate = GetVehicleNumberPlateText(vehicle)
    local model = GetEntityArchetypeName(vehicle)
    local net = VehToNet(vehicle)
    local class = GetVehicleClass(vehicle)
    local locked = GetVehicleDoorLockStatus(vehicle)
    local price = 0
    local display = model
    if type(VehicleName) == "function" then
        display = VehicleName(model) or model
    end
    if type(VehiclePrice) == "function" then
        price = VehiclePrice(model) or 0
    end
    return plate, display, net, class, price, locked, model
end

function LoadModel(Model)
	if IsModelInCdimage(Model) and IsModelValid(Model) then
		RequestModel(Model)

		while not HasModelLoaded(Model) do
			RequestModel(Model)

			Citizen.Wait(1)
		end

		return true
	end

	return false
end

function GetCoordsFromCam(Distance, Coords)
	local Rotation = GetGameplayCamRot()
	local Adjusted = vec3((math.pi / 180) * Rotation['x'], (math.pi / 180) * Rotation['y'], (math.pi / 180) * Rotation['z'])
	local Direction = vec3(-math.sin(Adjusted[3]) * math.abs(math.cos(Adjusted[1])), math.cos(Adjusted[3]) * math.abs(math.cos(Adjusted[1])), math.sin(Adjusted[1]))

	return vec3(Coords[1] + Direction[1] * Distance, Coords[2] + Direction[2] * Distance, Coords[3] + Direction[3] * Distance)
end


function API.getNearestVehicle(radius)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, tonumber(radius) or 5.0, 0, 71)
    return veh ~= 0 and veh or nil
end

function API.isInVehicle()
    return IsPedInAnyVehicle(PlayerPedId(), false)
end

function API.getArmour()
    return GetPedArmour(PlayerPedId())
end

function API.setArmour(amount)
    SetPedArmour(PlayerPedId(), tonumber(amount) or 0)
    return true
end

function API._setHealth(amount)
    SetEntityHealth(PlayerPedId(), tonumber(amount) or 100)
    return true
end

function API.taskBar(time)
    local timeout = GetGameTimer() + (tonumber(time) or 3000)
    while GetGameTimer() < timeout do
        Wait(0)
    end
    return true
end

function API._CarregarObjeto(dict, anim, prop, flag, hand, x,y,z,rx,ry,rz)
    if CoreTunnel and CoreTunnel.createObjects then
        return CoreTunnel.createObjects(dict, anim, prop, flag, hand, x,y,z,rx,ry,rz)
    end
    return false
end

function API._DeletarObjeto(mode)
    if CoreTunnel and CoreTunnel.removeObjects then
        return CoreTunnel.removeObjects(mode)
    end
    return false
end

function API._playScreenEffect(name, duration)
    StartScreenEffect(tostring(name), 0, true)
    SetTimeout(tonumber(duration or 5) * 1000, function()
        StopScreenEffect(tostring(name))
    end)
    return true
end

function API._toggleHandcuff()
    local state = not (LocalPlayer and LocalPlayer.state and LocalPlayer.state.Handcuff == true)
    LocalPlayer.state:set('Handcuff', state, true)
    return state
end

function API._setHandcuffed(status)
    LocalPlayer.state:set('Handcuff', status == true, true)
    return true
end

function API.isCapuz()
    return LocalPlayer and LocalPlayer.state and LocalPlayer.state.Capuz == true
end

function API._setCapuz(status)
    LocalPlayer.state:set('Capuz', status == true, true)
    return true
end

function API.objectCoords(Model)
	local Aplication = false
	local ObjectCoords = false
	local ObjectHeading = false

	if LoadModel(Model) then
		local Progress = true

		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		local Heading = GetEntityHeading(Ped)
		local NextObject = CreateObjectNoOffset(Model, Coords['x'], Coords['y'], Coords['z'], false, false, false)

		SetEntityCollision(NextObject, false, false)
		SetEntityHeading(NextObject, Heading)
		SetEntityAlpha(NextObject, 100, false)

		while Progress do
			local Ped = PlayerPedId()
			local Cam = GetGameplayCamCoord()
			local Handle = StartExpensiveSynchronousShapeTestLosProbe(Cam, GetCoordsFromCam(10.0, Cam), -1, Ped, 4)
			local _, _, Coords = GetShapeTestResult(Handle)

			if Model == 'prop_ld_binbag_01' then
				SetEntityCoords(NextObject, Coords['x'], Coords['y'], Coords['z'] + 0.9, false, false, false, false)
			else
				SetEntityCoords(NextObject, Coords['x'], Coords['y'], Coords['z'], false, false, false, false)
			end

			DwText('~g~F~w~  CANCELAR', 4, 0.015, 0.86, 0.38, 255, 255, 255, 255)
			DwText('~g~E~w~  COLOCAR OBJETO', 4, 0.015, 0.89, 0.38, 255, 255, 255, 255)
			DwText('~y~SCROLL UP~w~  GIRA ESQUERDA', 4, 0.015, 0.92, 0.38, 255, 255, 255, 255)
			DwText('~y~SCROLL DOWN~w~  GIRA DIREITA', 4, 0.015, 0.95, 0.38, 255, 255, 255, 255)

			if IsControlJustPressed(1, 38) then
				Aplication = true
				Progress = false
			end

			if IsControlJustPressed(0, 49) then
				Progress = false
			end

			if IsControlJustPressed(0, 180) then
				local Heading = GetEntityHeading(NextObject)
				
				SetEntityHeading(NextObject, Heading + 2.5)
			end

			if IsControlJustPressed(0, 181) then
				local Heading = GetEntityHeading(NextObject)

				SetEntityHeading(NextObject, Heading - 2.5)
			end

			Wait(1)
		end

		ObjectCoords = GetEntityCoords(NextObject)
		ObjectHeading = GetEntityHeading(NextObject)

		DeleteEntity(NextObject)
	end

	return Aplication, ObjectCoords, ObjectHeading
end

function DwText(Text, Font, x, y, Scale, R, G, B, A)
	SetTextFont(Font)
	SetTextScale(Scale, Scale)
	SetTextColour(R, G, B, A)
	SetTextOutline()
	SetTextEntry('STRING')
	AddTextComponentString(Text)
	DrawText(x, y)
end

function API.createObject(obj, coords)
	local hash = GetHashKey(obj)
	if LoadModel(hash) then
		local object = CreateObject(hash, coords.x, coords.y, coords.z, true, true, true)
		local netId = ObjToNet(object)
		SetModelAsNoLongerNeeded(hash)
		NetworkRegisterEntityAsNetworked(object)
		SetNetworkIdExistsOnAllMachines(netId, true)
		SetNetworkIdCanMigrate(netId, true)
		SetEntityHeading(object, coords.h)
		SetEntityAsMissionEntity(object, true, true)
		FreezeEntityPosition(object, true)
		PlaceObjectOnGroundProperly(object)
	end
end

RegisterNUICallback('openStore', function(data, cb)
	ExecuteCommand('loja')
	cb(true)
end)

function API.checkAnim()
	local ped = PlayerPedId()
    if IsEntityPlayingAnim(ped,"random@arrests@busted","idle_a",3) then
        return true
    end
    if IsEntityPlayingAnim(ped,"random@mugging3","handsup_standing_base",3) then
        return true
    end
	if IsEntityPlayingAnim(ped,"mp_arresting","idle",3) then
        return true
    end
    return false
end

local inZoneDrug = false
local inZoneDrug2 = false
local inZoneDrug3 = false
local inZoneDrug4 = false

local zone1 = PolyZone:Create({
	vector2(1279.55, 4323.48),
	vector2(1279.55, 4379.55),
	vector2(1315.53, 4379.55),
	vector2(1315.53, 4323.48)
}, {
	name="",
	--minZ=0,
	--maxZ=800

})

local zone2 = CircleZone:Create(vector2(-50.38, 6373.48), 21.23, {
	name="null",
})

local zone3 = CircleZone:Create(vector2(-80.68, 346.59), 43.90, {
	name="null",
})

local zone4 = CircleZone:Create(vector2(-940.91, -789.39), 25.07, {
	name="",
})

zone1:onPlayerInOut(function(naZona, _)
	inZoneDrug = naZona
end)

-- zone2:onPlayerInOut(function(naZona, _)
--     inZoneDrug2 = naZona
-- end)

-- zone3:onPlayerInOut(function(naZona, _)
--     inZoneDrug3 = naZona
-- end)

-- zone4:onPlayerInOut(function(naZona, _)
--     inZoneDrug4 = naZona
-- end)
CreateThread(function()
	while true do
		local ped = PlayerPedId()
		local coords = GetEntityCoords(ped)

		if zone2:isPointInside(coords) then
			inZoneDrug2 = true
		else
			inZoneDrug2 = false
		end

		if zone3:isPointInside(coords) then
			inZoneDrug3 = true
		else
			inZoneDrug3 = false
		end

		if zone4:isPointInside(coords) then
			inZoneDrug4 = true
		else
			inZoneDrug4 = false
		end
		Wait(5000)
	end
end)

function API.isInDrugZone()
	return inZoneDrug or inZoneDrug2 or inZoneDrug3 or inZoneDrug4
end

-- Evento para remover cabelo com a tesoura
RegisterNetEvent("tesoura:removerCabelo")
AddEventHandler("tesoura:removerCabelo", function()
	LocalPlayer.state.blockHair = true 
    local ped = PlayerPedId()
	Citizen.Wait(100)
    -- Define o cabelo como careca (componente 2, variação 0)
    SetPedComponentVariation(ped, 2, 0, 0, 0)
    -- Remove qualquer chapéu ou acessório de cabeça
    ClearPedProp(ped, 0)
end)

-- Evento para aplicar cabelo masculino aleatório
RegisterNetEvent("tesoura:aplicarCabeloMasculino")
AddEventHandler("tesoura:aplicarCabeloMasculino", function()
	
    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    
    -- Verifica se é o modelo masculino mp_m_freemode_01
    if pedModel == GetHashKey("mp_m_freemode_01") then
	LocalPlayer.state.blockHair = true 

        -- Remove qualquer chapéu ou acessório de cabeça
        ClearPedProp(ped, 0)
        
        -- Gera um cabelo aleatório entre 1 e 200
        local randomHair = math.random(1, 200)
        local randomColor = math.random(0, 63) -- Cores de cabelo disponíveis
        local randomHighlight = math.random(0, 63) -- Cores de destaque
        
        -- Aplica o cabelo aleatório
        SetPedComponentVariation(ped, 2, randomHair, 0, 0)
        SetPedHairColor(ped, randomColor, randomHighlight)
    else
        TriggerEvent("Notify", "negado", "Esta tesoura só funciona em personagens masculinos!", 5)
    end
end)

-- Evento para aplicar cabelo feminino aleatório
RegisterNetEvent("tesoura:aplicarCabeloFeminino")
AddEventHandler("tesoura:aplicarCabeloFeminino", function()
    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)
    
    -- Verifica se é o modelo feminino mp_f_freemode_01
    if pedModel == GetHashKey("mp_f_freemode_01") then
		LocalPlayer.state.blockHair = true 

        -- Remove qualquer chapéu ou acessório de cabeça
        ClearPedProp(ped, 0)
        
        -- Gera um cabelo aleatório entre 1 e 200
        local randomHair = math.random(1, 200)
        local randomColor = math.random(0, 63) -- Cores de cabelo disponíveis
        local randomHighlight = math.random(0, 63) -- Cores de destaque
        
        -- Aplica o cabelo aleatório
        SetPedComponentVariation(ped, 2, randomHair, 0, 0)
        SetPedHairColor(ped, randomColor, randomHighlight)
    else
        TriggerEvent("Notify", "negado", "Esta tesoura só funciona em personagens femininos!", 5)
    end
end)