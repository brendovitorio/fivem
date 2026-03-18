local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")

rEVOLT = Proxy.getInterface("rEVOLT")

local drops = {}
local objectsCreated = {}

local availableObjects = {
    ['cellphone'] = 'prop_cs_hand_radio',
    ['radio'] = 'prop_cs_hand_radio',
    ['WEAPON_L12'] = 'w_ar_specialcarbine'
}

RegisterServerEvent('drop:playerDropItems', function()
    local source = source
    local Passport = rEVOLT.Passport(source)

    if Passport then

        if rEVOLT.HasGroup(Passport, 'Police') then
            return
        end

        local ped = GetPlayerPed(source)
        local coords = GetEntityCoords(ped)

        local inventory = rEVOLT.Inventory(Passport)

        for slot, infos in pairs(inventory) do
            local splitItem = splitString(infos.item, '-')

            local objectModel = availableObjects[splitItem[1]]
            if objectModel then
                if not objectsCreated[source] then
                    objectsCreated[source] = {}
                end

                local object = CreateObject(objectModel, coords.x, coords.y, coords.z - 1.0, true, false)
                FreezeEntityPosition(object, true)

                table.insert(objectsCreated[source], object)
            end

            rEVOLT.TakeItem(Passport, infos.item, infos.amount, false, slot)
        end

        drops[source] = inventory

        TriggerClientEvent('drop:updateDropList', -1, source, coords)
    end
end)

RegisterServerEvent('drop:collectItems', function(index)
    local source = source
    local Passport = rEVOLT.Passport(source)

    TriggerClientEvent('drop:removeDrop', -1, index)
    
    if Passport and drops[index] then
        local items = drops[index]
        drops[index] = nil


        for slot, infos in pairs(items) do
            rEVOLT.GiveItem(Passport, infos.item, infos.amount, true)
        end

        if objectsCreated[index] then
            for key, object in pairs(objectsCreated[index]) do
                if DoesEntityExist(object) then
                    DeleteEntity(object)

                    objectsCreated[index][key] = nil
                end
            end
        end

    end
end)