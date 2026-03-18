RegisterNetEvent(GetCurrentResourceName() .. ':loadChests', function(chests)
    Chests = chests
    print(#chests..' baus carregados')
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Wait(30000)
    if #Chests == 0 then
        TriggerServerEvent(GetCurrentResourceName()..':requestChests')
    end
end)

RegisterNetEvent(GetCurrentResourceName() .. ':addChest', function(chest)
    Chests[#Chests + 1] = chest
end)

RegisterNetEvent(GetCurrentResourceName() .. ':updateChest', function(id, chest)
    for k, v in pairs(Chests) do
        if v.id == id then
            Chests[k] = chest
            break
        end
    end
end)

RegisterNetEvent(GetCurrentResourceName() .. ':removeChest', function(id)
    for i = #Chests, 1, -1 do
        if Chests[i].id == id then
            table.remove(Chests, i)
            break
        end
    end
end)

RegisterNetEvent(GetCurrentResourceName() .. ':loadMarkets', function(markets)
    Shops.Mercado.coords = markets
    CreateMarketsBlips()
end)

AddEventHandler('onClientResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    Wait(30000)
    if #Shops.Mercado.coords == 0 then
        TriggerServerEvent(GetCurrentResourceName()..':requestMarkets')
    end
end)

RegisterNetEvent(GetCurrentResourceName() .. ':addMarket', function(market)
    Shops.Mercado.coords[#Shops.Mercado.coords + 1] = market
    CreateMarketsBlips()
end)

RegisterNetEvent(GetCurrentResourceName() .. ':updateMarket', function(id, market)
    for k, v in pairs(Shops.Mercado.coords) do
        if v.id == id then
            Shops.Mercado.coords[k] = market
            break
        end
    end
    CreateMarketsBlips()
end)

RegisterNetEvent(GetCurrentResourceName() .. ':removeMarket', function(id)
    for i = #Shops.Mercado.coords, 1, -1 do
        if Shops.Mercado.coords[i].id == id then
            table.remove(Shops.Mercado.coords, i)
            break
        end
    end
    CreateMarketsBlips()
end)