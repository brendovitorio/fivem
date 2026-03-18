-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local srvData = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONSULTITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.ConsultItem(Passport,Item,Amount)
    if rEVOLT.Source(Passport) then
        if Amount > rEVOLT.InventoryItemAmount(Passport,Item)[1] then
            return false
        elseif rEVOLT.CheckDamaged(rEVOLT.InventoryItemAmount(Passport,Item)[1]) then
            return false
        end
    end
    return true
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GetWeight(Passport)
    local Source = rEVOLT.Source(Passport)
    local Datatable = rEVOLT.Datatable(Passport)
    if Source and Datatable then
        return BackpackMaxWeightDefault >= Datatable["Weight"] and Datatable["Weight"] or BackpackMaxWeightDefault
    end
    return 0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.SetWeight(Passport,Amount)
    local Source = rEVOLT.Source(Passport)
    local Datatable = rEVOLT.Datatable(Passport)
    if Source and Datatable then
        Datatable["Weight"] = Datatable["Weight"] + Amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.RemoveWeight(Passport,Amount)
    local Source = rEVOLT.Source(Passport)
    local Datatable = rEVOLT.Datatable(Passport)
    if Source and Datatable then
        Datatable["Weight"] = Datatable["Weight"] - Amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATESHOP
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UpdateShop(Passport, Slot, Target, Amount)
    local source = rEVOLT.Source(Passport)
    if source then
        local Amount = parseInt(Amount)
        local Inventory = rEVOLT.Inventory(Passport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then

            local Stack = itemStack(Inventory[tostring(Slot)]["item"])
            if not Inventory[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Inventory[tostring(Slot)]["amount"] then
                    Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                    Inventory[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                end
            else
                if Inventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                    end
                else
                    if Inventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(Inventory[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                            if Repair and Repair == Inventory[tostring(Slot)]["item"] then
                                Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - 1
                                Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                            end
                        end
                    else
                        Inventory[tostring(Target)], Inventory[tostring(Slot)] = Inventory[tostring(Slot)], Inventory[tostring(Target)]
                    end
                end
            end

            if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                if tonumber(Slot) <= 5 and tonumber(Target) > 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,Inventory[tostring(Slot)]["item"])
                end
            end
            
            if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                if tonumber(Target) <= 5 and tonumber(Slot) > 5 then
                    TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                end
            end

            if Inventory[tostring(Slot)]["amount"] <= 0 then
                Inventory[tostring(Slot)] = nil
            end

            return true
        else
            TriggerClientEvent("shops:Update",source,"Request")
        end
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.InventoryWeight(Passport)
    local Weight = 0
    local source = rEVOLT.Source(Passport)
    if source then
        local Inventory = rEVOLT.Inventory(Passport)
        for k,v in pairs(Inventory) do
            Weight = Weight + itemWeight(v["item"]) * v["amount"]
            if itemChest(v["item"]) and v["data"] then
                for Slot,Value in pairs(v["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end
        end
    end
    return Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECKDAMAGED
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.CheckDamaged(Item)
    if itemDurability(Item) and splitString(Item, "-")[2] and parseInt((3600 * itemDurability(Item) - parseInt(os.time() - splitString(Item, "-")[2])) / (3600 * itemDurability(Item)) * 100) <= 1 then
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.ChestWeight(items)
    local Weight = 0
    for k, v in pairs(items) do
        Weight = Weight + (itemWeight(v["item"]) * v["amount"])
        if itemChest(v["item"]) and v["data"] then
            for Slot,Value in pairs(v["data"]) do
                Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
            end
        end
    end
    return Weight
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.InventoryItemAmount(Passport, Item)
    if rEVOLT.Source(Passport) then
        local Inventory = rEVOLT.Inventory(Passport)
        for k, v in pairs(Inventory) do
            if splitString(Item, "-")[1] == splitString(v["item"], "-")[1] then
                return { v["amount"], v["item"] }
            end
        end
    end
    return { 0,"" }
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYFULL
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.InventoryFull(Passport, Item)
    if rEVOLT.Source(Passport) then
        local Inventory = rEVOLT.Inventory(Passport)
        for k,v in pairs(Inventory) do
            if v["item"] == Item then
                return true
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETITEMDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GetItemData(Passport, Item)
    if rEVOLT.Source(Passport) then
        local Inventory = rEVOLT.Inventory(Passport)
        for k,v in pairs(Inventory) do
            if v["item"] == Item then
                if not Inventory[k]["data"] then
                    Inventory[k]["data"] = {}
                end
                return Inventory[k]["data"]
            end
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.ItemAmount(Passport,Item)
    local Amount = 0
    local Inventory = rEVOLT.Inventory(Passport)
    for k,v in pairs(Inventory) do
        if splitString(v["item"], "-")[1] == splitString(Item, "-")[1] then
            Amount = Amount + v["amount"]
        elseif itemChest(v["item"]) and v["data"] then
            for Slot,Value in pairs(v["data"]) do
                if splitString(Value["item"], "-")[1] == splitString(Item, "-")[1] then
                    Amount = Amount + Value["amount"]
                end
            end
        end
    end
    return Amount
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GIVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GiveItem(Passport, Item, Amount, Notify, Slot)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)

        local function addItemToSlot(Slot, Amount)
            local Stack = itemStack(Item)
            if Inventory[tostring(Slot)] and Inventory[tostring(Slot)].item == Item then
                Added = math.min(Amount, (Stack - Inventory[tostring(Slot)].amount))
                Inventory[tostring(Slot)].amount = Inventory[tostring(Slot)].amount + Added
            else
                Added = math.min(Amount, Stack)
                Inventory[tostring(Slot)] = { item = Item, amount = Added }
            end
            if Notify and itemBody(Item) and Added > 0 then
                TriggerClientEvent("NotifyItens", source, { "+", itemIndex(Item), tonumber(Added), itemName(Item) })
            end
            if tonumber(Slot) <= 5 and "Armamento" == itemType(Item) then
                TriggerClientEvent("inventory:CreateWeapon", source, Item)
            end
            return Amount - Added
        end
        
        if Slot then
            if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                Amount = addItemToSlot(Slot, Amount)
                if Amount > 0 then
                    for Slot = tonumber(Slot), 25 do
                        if Amount <= 0 then break end
                        if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                            Amount = addItemToSlot(Slot, Amount)
                        end
                    end
                end
            end
        else
            for Slot = 1, 25 do
                if Amount <= 0 then break end
                if Inventory[tostring(Slot)] and Inventory[tostring(Slot)]["item"] == Item then
                    Amount = addItemToSlot(Slot, Amount)
                end
            end
        end

        if Amount > 0 then
            for Slot = 1, 25 do
                if Amount <= 0 then break end
                if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                    Amount = addItemToSlot(Slot, Amount)
                end
            end
        end

        return Amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GENERATEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GenerateItem(Passport, Item, Amount, Notify, Slot)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local GenerateString = {'D','L'}
        local Inventory = rEVOLT.Inventory(Passport)

        if SplitOne(Item,"-") == "identity" or SplitOne(Item,"-") == "fidentity" or string.sub(SplitOne(Item,"-"),1,5) == "badge"then
            Item = Item .. "-" .. Passport
        else
            if itemDurability(Item) then
                Item = Item .. "-" .. os.time()
            elseif itemCharges(Item) then
                Item = Item .. "-" .. itemCharges(Item)
            end
        end

        local function addItemToSlot(Slot, Amount)
            local Stack = itemStack(Item)
            if Inventory[tostring(Slot)] and Inventory[tostring(Slot)].item == Item then
                Added = math.min(Amount, (Stack - Inventory[tostring(Slot)].amount))
                Inventory[tostring(Slot)].amount = Inventory[tostring(Slot)].amount + Added
            else
                if itemChest(Item) then
                    Added = 1
                    Inventory[tostring(Slot)] = { item = Item .. "-" .. rEVOLT.GenerateString("LDLDLDLDLD"), amount = Added, data = {} }
                    if SplitOne(Item,"-") == "ciggypack" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "cigarette", amount = 30 }
                    elseif SplitOne(Item,"-") == "ollyrancherbag" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "ollyrancher", amount = 30 }
                    elseif SplitOne(Item,"-") == "ammo9box" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "AMMO_9", amount = 30 }
                    elseif SplitOne(Item,"-") == "ammo45box" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "AMMO_45", amount = 30 }
                    elseif SplitOne(Item,"-") == "ammo556box" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "AMMO_556", amount = 30 }
                    elseif SplitOne(Item,"-") == "ammo12box" then
                        Inventory[tostring(Slot)]["data"]["1"] = { item = "AMMO_12", amount = 30 }
                    end
                elseif itemType(Item) == "Armamento" and itemAmmo(Item) then
                    Added = 1
                    Inventory[tostring(Slot)] = { item = Item .. "-" .. rEVOLT.GenerateString(GenerateString[math.random(1, 2)]..GenerateString[math.random(1, 2)]..GenerateString[math.random(1, 2)]..GenerateString[math.random(1, 2)]..GenerateString[math.random(1, 2)]..GenerateString[math.random(1, 2)]), amount = Added }
                else
                    Added = math.min(Amount, Stack)
                    Inventory[tostring(Slot)] = { item = Item, amount = Added }
                end
            end
            if Notify and itemBody(Item) and Added > 0 then
                TriggerClientEvent("NotifyItens", source, { "+", itemIndex(Item), tonumber(Added), itemName(Item) })
            end
            if tonumber(Slot) <= 5 and "Armamento" == itemType(Item) then
                TriggerClientEvent("inventory:CreateWeapon", source, Item)
            end
            return Amount - Added
        end

        if Slot then
            if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                Amount = addItemToSlot(Slot, Amount)
                if Amount > 0 then
                    for Slot = tonumber(Slot), 25 do
                        if Amount <= 0 then break end
                        if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                            Amount = addItemToSlot(Slot, Amount)
                        end
                    end
                end
            end
        else
            for Slot = 1, 25 do
                if Amount <= 0 then break end
                if Inventory[tostring(Slot)] and Inventory[tostring(Slot)]["item"] == Item then
                    Amount = addItemToSlot(Slot, Amount)
                end
            end
        end

        if Amount > 0 then
            for Slot = 1, 25 do
                if Amount <= 0 then break end
                if not Inventory[tostring(Slot)] or Inventory[tostring(Slot)]["item"] == Item then
                    Amount = addItemToSlot(Slot, Amount)
                end
            end
        end

        return Amount
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPVARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Drops = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Drops(Route)
    if not Drops[Route] then
        Drops[Route] = {}
    end
    return Drops[Route]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("inventory:Drops",source,Drops)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DROPINVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.DropInventory(Passport, Route, Amount, Slot)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Drops = rEVOLT.Drops(Route)
        local Inventory = rEVOLT.Inventory(Passport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then

            local function addItemToSlot(Target, Amount)
                local Stack = itemStack(Inventory[tostring(Slot)]["item"])
                if Drops[tostring(Target)] and Drops[tostring(Target)]["Key"] == Inventory[tostring(Slot)]["item"] then
                    Added = math.min(Amount, (Stack - Drops[tostring(Target)]["Amount"]))
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        Drops[tostring(Target)]["Amount"] = Drops[tostring(Target)]["Amount"] + Added
                        TriggerClientEvent("inventory:DropsAdicionar",-1,Route,tostring(Target),Drops[tostring(Target)])
                    end
                else
                    Added = math.min(Amount, Stack)
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added

                        Drops[tostring(Target)] = {
                            ["Id"] = Target,
                            ["Route"] = Route,
                            ["Amount"] = Added,
                            ["Key"] = Inventory[tostring(Slot)]["item"],
                            ["Data"] = Inventory[tostring(Slot)]["data"],
                            ["Peso"] = itemWeight(Inventory[tostring(Slot)]["item"]),
                            ["Index"] = itemIndex(Inventory[tostring(Slot)]["item"]),
                            ["Name"] = itemName(Inventory[tostring(Slot)]["item"]),
                            ["Coords"] = GetEntityCoords(GetPlayerPed(source)),
                            ["Timer"] = os.time() + 600
                        }
                        
                        if itemChest(Inventory[tostring(Slot)]["item"]) and Inventory[tostring(Slot)]["data"] then
                            for Slot,Value in pairs(Inventory[tostring(Slot)]["data"]) do
                                Drops[tostring(Target)]["Peso"] = Drops[tostring(Target)]["Peso"] + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                            end
                        end

                        if SplitTwo(Inventory[tostring(Slot)]["item"],"-") then
                            if itemCharges(Inventory[tostring(Slot)]["item"]) then
                                Drops[tostring(Target)]["charges"] = parseInt(SplitTwo(Inventory[tostring(Slot)]["item"],"-") * 33)
                            end
                            if itemDurability(Inventory[tostring(Slot)]["item"]) then
                                Drops[tostring(Target)]["durability"] = parseInt(os.time() - SplitTwo(Inventory[tostring(Slot)]["item"],"-"))
                                Drops[tostring(Target)]["days"] = itemDurability(Inventory[tostring(Slot)]["item"])
                            end
                        end

                        TriggerClientEvent("inventory:DropsAdicionar",-1,Route,tostring(Target),Drops[tostring(Target)])
                    end
                end
                return Amount - Added
            end
          
            for Target = 1, 25 do
                if Amount <= 0 then break end
                if not Drops[tostring(Target)] or Drops[tostring(Target)]["Key"] == Inventory[tostring(Slot)]["item"] then
                    Amount = addItemToSlot(Target, Amount)
                end
            end
            
            if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) or "Throwing" == itemType(Inventory[tostring(Slot)]["item"]) then
                TriggerClientEvent("inventory:verifyWeapon", source, Inventory[tostring(Slot)]["item"])
                if tonumber(Slot) <= 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,Inventory[tostring(Slot)]["item"])
                end
            end

            if Inventory[tostring(Slot)]["amount"] <= 0 then
                Inventory[tostring(Slot)] = nil
            end

            return Amount
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.PickupInventory(Passport, Route, Amount, Slot, Target)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Drops = rEVOLT.Drops(Route)
        local Inventory = rEVOLT.Inventory(Passport)
        if Drops[tostring(Slot)] and Amount <= Drops[tostring(Slot)]["Amount"] then

            local Weight = itemWeight(Drops[tostring(Slot)]["Key"])
            if itemChest(Drops[tostring(Slot)]["Key"]) and Drops[tostring(Slot)]["Data"] then
                for Slot,Value in pairs(Drops[tostring(Slot)]["Data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end

            if rEVOLT.MaxItens(Passport,Drops[tostring(Slot)]["Key"],Amount) then
                TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",5000,"Aviso")
                TriggerClientEvent("inventory:Update",source,"Backpack")
            else
                if rEVOLT.InventoryWeight(Passport) + Weight * Amount <= rEVOLT.GetWeight(Passport) then

                    local Stack = itemStack(Drops[tostring(Slot)]["Key"])
                    if not Inventory[tostring(Target)] then
                        Added = math.min(Amount, Stack)
                        if Added <= Drops[tostring(Slot)]["Amount"] then
                            Drops[tostring(Slot)]["Amount"] = Drops[tostring(Slot)]["Amount"] - Added
                            Inventory[tostring(Target)] = { item = Drops[tostring(Slot)]["Key"], amount = Added, data = Drops[tostring(Slot)]["Data"] }
                            Amount = Amount - Added
                        end
                    else
                        if Inventory[tostring(Target)]["item"] == Drops[tostring(Slot)]["Key"] then
                            Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                            if Added <= Drops[tostring(Slot)]["Amount"] then
                                Drops[tostring(Slot)]["Amount"] = Drops[tostring(Slot)]["Amount"] - Added
                                Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                                Amount = Amount - Added
                            end
                        else
                            if Drops[tostring(Slot)]["Key"] == "repairkit0"..string.sub(Drops[tostring(Slot)]["Key"],11,12) then
                                if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                                    local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                                    if Repair and Repair == Drops[tostring(Slot)]["Key"] then
                                        Amount = Amount - 1
                                        Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                        Drops[tostring(Slot)]["Amount"] = Drops[tostring(Slot)]["Amount"] - 1
                                    end
                                end
                            else
                                Inventory[tostring(Target)], Drops[tostring(Slot)] = Drops[tostring(Slot)], Inventory[tostring(Target)]
                            end
                        end
                    end
    
                    if "Armamento" == itemType(Drops[tostring(Slot)]["Key"]) then
                        if tonumber(Slot) <= 5 then
                            TriggerClientEvent("inventory:RemoveWeapon",source,Drops[tostring(Slot)]["Key"])
                        end
                    end
        
                    if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                        if tonumber(Slot) <= 5 then
                            TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                        end
                    end
        
                    if Drops[tostring(Slot)]["Amount"] <= 0 then
                        Drops[tostring(Slot)] = nil
                        TriggerClientEvent("inventory:DropsRemover",-1,Route,tostring(Slot))
                    else
                        TriggerClientEvent("inventory:DropsAtualizar",-1,Route,tostring(Slot),Drops[tostring(Slot)]["Amount"])
                    end
    
                    return Amount
                end
            end

        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAXITENS
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.MaxItens(Passport,Item,Amount)
    if itemBody(Item) and rEVOLT.Source(Passport) and itemMaxAmount(Item) then
        if rEVOLT.HasService(Passport,"Restaurants") then
            if itemScape(Item) and rEVOLT.ItemAmount(Passport,Item) + parseInt(Amount) > itemMaxAmount(Item) * 5 then
                return true
            end
        elseif rEVOLT.ItemAmount(Passport,Item) + parseInt(Amount) > itemMaxAmount(Item) then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE ITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.TakeItem(Passport, Item, Amount, Notify, Slot)
    local source = rEVOLT.Source(Passport)
    local take = false
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
        if not Slot then
            for k,v in pairs(Inventory) do
                if v["item"] == Item and Amount <= v["amount"] then

                    Inventory[k]["amount"] = Inventory[k]["amount"] - Amount
                    
                    if Inventory[k]["amount"] <= 0 then
                        if "Armamento" == itemType(Item) or "Throwing" ~= itemType(Item) then
                            TriggerClientEvent("inventory:verifyWeapon", source, Item)
                        end
                        if parseInt(k) <= 5 then
                            TriggerClientEvent("inventory:RemoveWeapon", source, Item)
                        end
                        Inventory[k] = nil
                    end

                    if Notify and itemBody(Item) then
                        TriggerClientEvent("NotifyItens", source, { "-",itemIndex(Item),parseInt(Amount),itemName(Item) })
                    end
                    
                    take = true
                    break
                end
            end
        elseif Inventory[tostring(Slot)]["item"] == Item and Amount <= Inventory[tostring(Slot)]["amount"] then

            Inventory[tostring(Slot)]["amount"] =  Inventory[tostring(Slot)]["amount"] - Amount

            if Inventory[tostring(Slot)]["amount"] <= 0 then
                if "Armamento" == itemType(Item) or "Throwing" ~= itemType(Item) then
                    TriggerClientEvent("inventory:verifyWeapon", source, Item)
                end
                if parseInt(Slot) <= 5 then
                    TriggerClientEvent("inventory:RemoveWeapon", source, Item)
                end
                Inventory[tostring(Slot)] = nil
            end
            
            if Notify and itemBody(Item) then
                TriggerClientEvent("NotifyItens", source, { "-",itemIndex(Item),parseInt(Amount),itemName(Item) })
            end
            
            take = true
        end
    end
    return take
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMOVEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.RemoveItem(Passport,Item,Amount,Notify)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
        for k, v in pairs(Inventory) do
            if v["item"] == Item and parseInt(Amount) <= v["amount"] then
                v["amount"] = v["amount"] - parseInt(Amount)
                if v["amount"] <= 0 then
                    if "Armamento" == itemType(Item) or "Throwing" ~= itemType(Item) then
                    end
                    TriggerClientEvent("inventory:verifyWeapon",source,Item)
                    if parseInt(k) <= 5 then
                        TriggerClientEvent("inventory:RemoveWeapon",source,Item)
                    end
                    Inventory[k] = nil
                end
                if Notify and itemBody(Item) then
                    TriggerClientEvent("NotifyItens", source, { "-",itemIndex(Item),parseInt(Amount),itemName(Item) })
                end
                break
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SEND
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.SendInventory(Passport, OtherPassport, Amount, Slot)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
		local OtherInventory = rEVOLT.Inventory(OtherPassport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then
            local Weight = itemWeight(Inventory[tostring(Slot)]["item"])
            if itemChest(Inventory[tostring(Slot)]["item"]) and Inventory[tostring(Slot)]["data"] then
                for Slot,Value in pairs(Inventory[tostring(Slot)]["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end
            if rEVOLT.MaxItens(OtherPassport,Inventory[tostring(Slot)]["item"],Amount) then
                TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",5000,"Aviso")
                TriggerClientEvent("inventory:Update",source,"Backpack")
            else
                if rEVOLT.InventoryWeight(OtherPassport) + Weight * Amount <= rEVOLT.GetWeight(OtherPassport) then
                    local function addItemToSlot(Target, Amount)
                        local Stack = itemStack(Inventory[tostring(Slot)]["item"])
                        if OtherInventory[tostring(Target)] and OtherInventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                            Added = math.min(Amount, (Stack - OtherInventory[tostring(Target)]["amount"]))
                            if Added <= Inventory[tostring(Slot)]["amount"] then
                                Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                                OtherInventory[tostring(Target)]["amount"] = OtherInventory[tostring(Target)]["amount"] + Added    
                            end
                        else
                            Added = math.min(Amount, Stack)
                            if Added <= Inventory[tostring(Slot)]["amount"] then
                                Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                                OtherInventory[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                            end
                        end
                        if itemBody(Inventory[tostring(Slot)]["item"]) and Added > 0 then
                            TriggerClientEvent("NotifyItens", source, { "-", itemIndex(Inventory[tostring(Slot)]["item"]), tonumber(Added), itemName(Inventory[tostring(Slot)]["item"]) })
                            TriggerClientEvent("NotifyItens", rEVOLT.Source(OtherPassport), { "+", itemIndex(Inventory[tostring(Slot)]["item"]), tonumber(Added), itemName(Inventory[tostring(Slot)]["item"]) })
                        end
                        if tonumber(Target) <= 5 and "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                            TriggerClientEvent("inventory:CreateWeapon", source, Inventory[tostring(Slot)]["item"])
                        end
                        if tonumber(Slot) <= 5 and "Armamento" == itemType(OtherInventory[tostring(Target)]["item"]) then
                            TriggerClientEvent("inventory:RemoveWeapon", source, OtherInventory[tostring(Target)]["item"])
                        end
                        return Amount - Added
                    end
                    for Target = 1,25 do
                        if Amount <= 0 then break end
                        if OtherInventory[tostring(Target)] and OtherInventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                            Amount = addItemToSlot(Target, Amount)
                        end
                    end
                    if Amount > 0 then
                        for Target = 1, 25 do
                            if Amount <= 0 then break end
                            if not OtherInventory[tostring(Target)] or OtherInventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                                Amount = addItemToSlot(Target, Amount)
                            end
                        end
                    end
                    if Inventory[tostring(Slot)]["amount"] <= 0 then
                        Inventory[tostring(Slot)] = nil
                    end
                    return Amount
                else
                    TriggerClientEvent("Notify",source,"amarelo","Mochila cheia.",5000,"Aviso")
                end
            end

        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORYITEMUPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UpdateInventory(Passport, Slot, Target, Amount)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then

            local Stack = itemStack(Inventory[tostring(Slot)]["item"])
            if not Inventory[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Inventory[tostring(Slot)]["amount"] then
                    Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                    Inventory[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                end
            else
                if Inventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                    end
                else
                    if Inventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(Inventory[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                            if Repair and Repair == Inventory[tostring(Slot)]["item"] then
                                Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - 1
                                Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                            end
                        end
                    else
                        Inventory[tostring(Target)], Inventory[tostring(Slot)] = Inventory[tostring(Slot)], Inventory[tostring(Target)]
                    end
                end
            end

            if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                if tonumber(Slot) <= 5 and tonumber(Target) > 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,Inventory[tostring(Slot)]["item"])
                end
            end
            
            if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                if tonumber(Target) <= 5 and tonumber(Slot) > 5 then
                    TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                end
            end

            if Inventory[tostring(Slot)]["amount"] <= 0 then
                Inventory[tostring(Slot)] = nil
            end

            return true
        else
            TriggerClientEvent("inventory:Update",source,"Backpack")
        end
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.TakeInspect(Passport, OtherPassport, Amount, Slot, Target)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
        local OtherInventory = rEVOLT.Inventory(OtherPassport)
        if OtherInventory[tostring(Slot)] and Amount <= OtherInventory[tostring(Slot)]["amount"] then

            local Weight = itemWeight(OtherInventory[tostring(Slot)]["item"])
            if itemChest(OtherInventory[tostring(Slot)]["item"]) and OtherInventory[tostring(Slot)]["data"] then
                for Slot,Value in pairs(OtherInventory[tostring(Slot)]["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end

            if rEVOLT.InventoryWeight(Passport) + Weight * Amount <= rEVOLT.GetWeight(Passport) then

                local Stack = itemStack(OtherInventory[tostring(Slot)]["item"])
                if not Inventory[tostring(Target)] then
                    local Added = math.min(Amount, Stack)
                    if Added <= OtherInventory[tostring(Slot)]["amount"] then
                        OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - Added
                        Inventory[tostring(Target)] = { item = OtherInventory[tostring(Slot)]["item"], amount = Added, data = OtherInventory[tostring(Slot)]["data"] }
                    end
                else
                    if Inventory[tostring(Target)]["item"] == OtherInventory[tostring(Slot)]["item"] then
                        local Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                        if Added <= OtherInventory[tostring(Slot)]["amount"] then
                            OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - Added
                            Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                        end
                    else
                        if OtherInventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(OtherInventory[tostring(Slot)]["item"],11,12) then
                            if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                                local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                                if Repair and Repair == OtherInventory[tostring(Slot)]["item"] then
                                    Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                    OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - 1
                                end
                            end
                        else
                            Inventory[tostring(Target)], OtherInventory[tostring(Slot)] = OtherInventory[tostring(Slot)], Inventory[tostring(Target)]
                        end
                    end
                end
    
                if "Armamento" == itemType(OtherInventory[tostring(Slot)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:RemoveWeapon",source,OtherInventory[tostring(Slot)]["item"])
                    end
                end
    
                if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                    end
                end
    
                if OtherInventory[tostring(Slot)]["amount"] <= 0 then
                    OtherInventory[tostring(Slot)] = nil
                end
    
                TriggerClientEvent("inspect:Update",source,"Update",rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.GetWeight(OtherPassport),rEVOLT.InventoryWeight(OtherPassport))
                
            end
        end
        TriggerClientEvent("inspect:Update",source,"Request")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.StoreInspect(Passport, OtherPassport, Amount, Slot, Target)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Inventory = rEVOLT.Inventory(Passport)
        local OtherInventory = rEVOLT.Inventory(OtherPassport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then

            local Weight = itemWeight(Inventory[tostring(Slot)]["item"])
            if itemChest(Inventory[tostring(Slot)]["item"]) and Inventory[tostring(Slot)]["data"] then
                for Slot,Value in pairs(Inventory[tostring(Slot)]["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end

            if rEVOLT.InventoryWeight(OtherInventory) >= rEVOLT.GetWeight(OtherInventory) + Weight * Amount then

                local Stack = itemStack(Inventory[tostring(Slot)]["item"])
                if not OtherInventory[tostring(Target)] then
                    local Added = math.min(Amount, Stack)
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        OtherInventory[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                    end
                else
                    if OtherInventory[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                        local Added = math.min(Amount, (Stack - OtherInventory[tostring(Target)]["amount"]))
                        if Added <= Inventory[tostring(Slot)]["amount"] then
                            Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                            OtherInventory[tostring(Target)]["amount"] = OtherInventory[tostring(Target)]["amount"] + Added
                        end
                    else
                        if Inventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(Inventory[tostring(Slot)]["item"],11,12) then
                            if rEVOLT.CheckDamaged(OtherInventory[tostring(Target)]["item"]) and OtherInventory[tostring(Target)]["amount"] == 1 then
                                local Repair = itemRepair(OtherInventory[tostring(Target)]["item"])
                                if Repair and Repair == Inventory[tostring(Slot)]["item"] then
                                    OtherInventory[tostring(Target)]["item"] = splitString(OtherInventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                    Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - 1
                                end
                            end
                        else
                            OtherInventory[tostring(Target)], Inventory[tostring(Slot)] = Inventory[tostring(Slot)], OtherInventory[tostring(Target)]
                        end
                    end
                end
    
                if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Slot)]["item"])
                    end
                end

                if "Armamento" == itemType(OtherInventory[tostring(Target)]["item"]) or "Throwing" == itemType(OtherInventory[tostring(Target)]["item"]) then
                    TriggerClientEvent("inventory:verifyWeapon", source, OtherInventory[tostring(Target)]["item"])
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:RemoveWeapon",source,OtherInventory[tostring(Target)]["item"])
                    end
                end
    
                if Inventory[tostring(Slot)]["amount"] <= 0 then
                    Inventory[tostring(Slot)] = nil
                end

                TriggerClientEvent("inspect:Update",source,"Update",rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.GetWeight(OtherPassport),rEVOLT.InventoryWeight(OtherPassport))
            end

        end
        TriggerClientEvent("inspect:Update",source,"Request")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UpdateInspect(OtherPassport, Slot, Target, Amount)
    local source = rEVOLT.Source(OtherPassport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local OtherInventory = rEVOLT.Inventory(OtherPassport)
        if OtherInventory[tostring(Slot)] and Amount <= OtherInventory[tostring(Slot)]["amount"] then

            local Stack = itemStack(OtherInventory[tostring(Slot)]["item"])
            if not OtherInventory[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= OtherInventory[tostring(Slot)]["amount"] then
                    OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - Added
                    OtherInventory[tostring(Target)] = { item = OtherInventory[tostring(Slot)]["item"], amount = Added, data = OtherInventory[tostring(Slot)]["data"] }
                end
            else
                if OtherInventory[tostring(Target)]["item"] == OtherInventory[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - OtherInventory[tostring(Target)]["amount"]))
                    if Added <= OtherInventory[tostring(Slot)]["amount"] then
                        OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - Added
                        OtherInventory[tostring(Target)]["amount"] = OtherInventory[tostring(Target)]["amount"] + Added
                    end
                else
                    if OtherInventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(OtherInventory[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(OtherInventory[tostring(Target)]["item"]) and OtherInventory[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(OtherInventory[tostring(Target)]["item"])
                            if Repair and Repair == OtherInventory[tostring(Slot)]["item"] then
                                OtherInventory[tostring(Slot)]["amount"] = OtherInventory[tostring(Slot)]["amount"] - 1
                                OtherInventory[tostring(Target)]["item"] = splitString(OtherInventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                            end
                        end
                    else
                        OtherInventory[tostring(Target)], OtherInventory[tostring(Slot)] = OtherInventory[tostring(Slot)], OtherInventory[tostring(Target)]
                    end
                end
            end

            if "Armamento" == itemType(OtherInventory[tostring(Slot)]["item"]) then
                if tonumber(Slot) <= 5 and tonumber(Target) > 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,OtherInventory[tostring(Slot)]["item"])
                end
            end
            
            if "Armamento" == itemType(OtherInventory[tostring(Target)]["item"]) then
                if tonumber(Target) <= 5 and tonumber(Slot) > 5 then
                    TriggerClientEvent("inventory:CreateWeapon",source,OtherInventory[tostring(Target)]["item"])
                end
            end

            if OtherInventory[tostring(Slot)]["amount"] <= 0 then
                OtherInventory[tostring(Slot)] = nil
            end

            return true
        else
            TriggerClientEvent("inspect:Update",source,"Request")
        end
        return false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.GetSrvData(Key, Save)
    if not srvData[Key] then
        local Result = rEVOLT.Query("entitydata/GetData", { dkey = Key })
        if Result[1] then
            srvData[Key] = { data = json.decode(Result[1].dvalue), timer = os.time() + 600, save = Save and true or false }
        else
            srvData[Key] = { data = {}, timer = Save and (os.time() + 600) or nil, save = Save and true or false }
        end
    end
	return srvData[Key]["data"]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SETSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.SetSrvData(Key, Data, Save)
    if not srvData[Key] then
        srvData[Key] = { data = Data, timer = Save and (os.time() + 600) or nil, save = Save and true or false }
    else
        srvData[Key]["data"] = Data
        srvData[Key]["timer"] = Save and (os.time() + 600) or nil
        srvData[Key]["save"] = Save and true or false
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REMSRVDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.RemSrvData(Key, Delete)
    if srvData[Key] then
        if srvData[Key]["save"] then
            if not Delete then
                rEVOLT.Query("entitydata/RemoveData", { dkey = Key })
            else
                rEVOLT.Query("entitydata/SetData",{ dkey = Key, dvalue = json.encode(srvData[Key]["data"]) })
            end
        end
        srvData[Key] = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVESERVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("SaveServer")
AddEventHandler("SaveServer",function()
    for Key,Value in pairs(srvData) do
        if Value["timer"] then
            if json.encode(Value["data"]) ~= "[]" or json.encode(Value["data"]) ~= "{}" then
                rEVOLT.Query("entitydata/SetData",{ dkey = Key, dvalue = json.encode(Value["data"]) })
            else
                rEVOLT.Query("entitydata/RemoveData",{ dkey = Key })
            end
        end
    end
	print("Save no banco de dados terminou, ja pode reiniciar o servidor.")
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.TakeChest(Passport, Name, Amount, Slot, Target, ChestWeight, Log)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Chest = rEVOLT.GetSrvData(Name)
        local Inventory = rEVOLT.Inventory(Passport)
        if Chest[tostring(Slot)] and Amount <= Chest[tostring(Slot)]["amount"] then

            local Weight = itemWeight(Chest[tostring(Slot)]["item"])
            if itemChest(Chest[tostring(Slot)]["item"]) and Chest[tostring(Slot)]["data"] then
                for Slot,Value in pairs(Chest[tostring(Slot)]["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end

            if rEVOLT.InventoryWeight(Passport) + Weight * Amount <= rEVOLT.GetWeight(Passport) then

                local Stack = itemStack(Chest[tostring(Slot)]["item"])
                if not Inventory[tostring(Target)] then
                    local Added = math.min(Amount, Stack)
                    if Added <= Chest[tostring(Slot)]["amount"] then
                        Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - Added
                        Inventory[tostring(Target)] = { item = Chest[tostring(Slot)]["item"], amount = Added, data = Chest[tostring(Slot)]["data"] }
                        if Log then
                            TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Retirou:** "..Added.."x "..itemName(Chest[tostring(Slot)]["item"]),9317187)
                        end
                    end
                else
                    if Inventory[tostring(Target)]["item"] == Chest[tostring(Slot)]["item"] then
                        local Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                        if Added <= Chest[tostring(Slot)]["amount"] then
                            Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - Added
                            Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                            if Log then
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Retirou:** "..Added.."x "..itemName(Chest[tostring(Slot)]["item"]),9317187)
                            end
                        end
                    else
                        if Chest[tostring(Slot)]["item"] == "repairkit0"..string.sub(Chest[tostring(Slot)]["item"],11,12) then
                            if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                                local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                                if Repair and Repair == Chest[tostring(Slot)]["item"] then
                                    Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                    Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - 1
                                end
                            end
                        else
                            Inventory[tostring(Target)], Chest[tostring(Slot)] = Chest[tostring(Slot)], Inventory[tostring(Target)]
                            if Log then
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Retirou:** "..Inventory[tostring(Target)]["amount"].."x "..itemName(Inventory[tostring(Target)]["item"]),9317187)
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Guardou:** "..Chest[tostring(Slot)]["amount"].."x "..itemName(Chest[tostring(Slot)]["item"]),3042892)
                            end
                        end
                    end
                end
    
                if "Armamento" == itemType(Chest[tostring(Slot)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:RemoveWeapon",source,Chest[tostring(Slot)]["item"])
                    end
                end
    
                if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                    end
                end
    
                if Chest[tostring(Slot)]["amount"] <= 0 then
                    Chest[tostring(Slot)] = nil
                end

                if string.sub(Name,1,9) == "Helicrash" and json.encode(Chest) == "[]" then
					TriggerClientEvent("inventory:Close",source)
					exports["helicrash"]:Box()
				end
    
                TriggerClientEvent("chest:Update",source,"Update",rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Chest),ChestWeight)  
            end
        end
        TriggerClientEvent("chest:Update",source,"Refresh")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.StoreChest(Passport, Name, Amount, Slot, Target, ChestWeight, Log)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Chest = rEVOLT.GetSrvData(Name)
        local Inventory = rEVOLT.Inventory(Passport)
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] then

            local Weight = itemWeight(Inventory[tostring(Slot)]["item"])
            if itemChest(Inventory[tostring(Slot)]["item"]) and Inventory[tostring(Slot)]["data"] then
                for Slot,Value in pairs(Inventory[tostring(Slot)]["data"]) do
                    Weight = Weight + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
                end
            end

            if ChestWeight >= rEVOLT.ChestWeight(Chest) + Weight * Amount then

                local Stack = itemStack(Inventory[tostring(Slot)]["item"])
                if not Chest[tostring(Target)] then
                    local Added = math.min(Amount, Stack)
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        Chest[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                        if Log then
                            TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Guardou:** "..Added.."x "..itemName(Inventory[tostring(Slot)]["item"]),3042892)
                        end
                    end
                else
                    if Chest[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                        local Added = math.min(Amount, (Stack - Chest[tostring(Target)]["amount"]))
                        if Added <= Inventory[tostring(Slot)]["amount"] then
                            Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                            Chest[tostring(Target)]["amount"] = Chest[tostring(Target)]["amount"] + Added
                            if Log then
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Guardou:** "..Added.."x "..itemName(Inventory[tostring(Slot)]["item"]),3042892)
                            end
                        end
                    else
                        if Inventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(Inventory[tostring(Slot)]["item"],11,12) then
                            if rEVOLT.CheckDamaged(Chest[tostring(Target)]["item"]) and Chest[tostring(Target)]["amount"] == 1 then
                                local Repair = itemRepair(Chest[tostring(Target)]["item"])
                                if Repair and Repair == Inventory[tostring(Slot)]["item"] then
                                    Chest[tostring(Target)]["item"] = splitString(Chest[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                    Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - 1
                                end
                            end
                        else
                            Chest[tostring(Target)], Inventory[tostring(Slot)] = Inventory[tostring(Slot)], Chest[tostring(Target)]
                            if Log then
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Guardou:** "..Chest[tostring(Target)]["amount"].."x "..itemName(Chest[tostring(Target)]["item"]),3042892)
                                TriggerEvent("Discord",Name,"**Passaporte:** "..Passport.."\n**Retirou:** "..Inventory[tostring(Slot)]["amount"].."x "..itemName(Inventory[tostring(Slot)]["item"]),9317187)
                            end
                        end
                    end
                end
    
                if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Slot)]["item"])
                    end
                end

                if "Armamento" == itemType(Chest[tostring(Target)]["item"]) or "Throwing" == itemType(Chest[tostring(Target)]["item"]) then
                    TriggerClientEvent("inventory:verifyWeapon", source, Chest[tostring(Target)]["item"])
                    if tonumber(Slot) <= 5 then
                        TriggerClientEvent("inventory:RemoveWeapon",source,Chest[tostring(Target)]["item"])
                    end
                end
    
                if Inventory[tostring(Slot)]["amount"] <= 0 then
                    Inventory[tostring(Slot)] = nil
                end

                TriggerClientEvent("chest:Update",source,"Update",rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Chest),ChestWeight)

            end

        end
        TriggerClientEvent("chest:Update",source,"Refresh")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UpdateChest(Passport, Name, Slot, Target, Amount)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Chest = rEVOLT.GetSrvData(Name)
        if Chest[tostring(Slot)] and Amount <= Chest[tostring(Slot)]["amount"] then
            local Stack = itemStack(Chest[tostring(Slot)]["item"])
            if not Chest[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Chest[tostring(Slot)]["amount"] then
                    Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - Added
                    Chest[tostring(Target)] = { item = Chest[tostring(Slot)]["item"], amount = Added, data = Chest[tostring(Slot)]["data"] }
                end
            else
                if Chest[tostring(Target)]["item"] == Chest[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - Chest[tostring(Target)]["amount"]))
                    if Added <= Chest[tostring(Slot)]["amount"] then
                        Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - Added
                        Chest[tostring(Target)]["amount"] = Chest[tostring(Target)]["amount"] + Added
                    end
                else
                    if Chest[tostring(Slot)]["item"] == "repairkit0"..string.sub(Chest[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(Chest[tostring(Target)]["item"]) and Chest[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(Chest[tostring(Target)]["item"])
                            if Repair and Repair == Chest[tostring(Slot)]["item"] then
                                Chest[tostring(Slot)]["amount"] = Chest[tostring(Slot)]["amount"] - 1
                                Chest[tostring(Target)]["item"] = splitString(Chest[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                            end
                        end
                    else
                        Chest[tostring(Target)], Chest[tostring(Slot)] = Chest[tostring(Slot)], Chest[tostring(Target)]
                    end
                end
            end

            if Chest[tostring(Slot)]["amount"] <= 0 then
                Chest[tostring(Slot)] = nil
            end

            return Chest
        else
            TriggerClientEvent("chest:Update",source,"Refresh")
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEBAG
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.TakeBag(Passport, Name, Amount, Slot, Target)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Bag = rEVOLT.GetItemData(Passport, Name)
        local Inventory = rEVOLT.Inventory(Passport)
        if Bag[tostring(Slot)] and Amount <= Bag[tostring(Slot)]["amount"] then
            local Stack = itemStack(Bag[tostring(Slot)]["item"])
            if not Inventory[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Bag[tostring(Slot)]["amount"] then
                    Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - Added
                    Inventory[tostring(Target)] = { item = Bag[tostring(Slot)]["item"], amount = Added, data = Bag[tostring(Slot)]["data"] }
                end
            else
                if itemChest(Inventory[tostring(Target)]["item"]) ~= true and notStoreBag(SplitOne(Name,"-"),SplitOne(Inventory[tostring(Target)]["item"],"-")) then
                    if Inventory[tostring(Target)]["item"] == Bag[tostring(Slot)]["item"] then
                        local Added = math.min(Amount, (Stack - Inventory[tostring(Target)]["amount"]))
                        if Added <= Bag[tostring(Slot)]["amount"] then
                            Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - Added
                            Inventory[tostring(Target)]["amount"] = Inventory[tostring(Target)]["amount"] + Added
                        end
                    else
                        if Bag[tostring(Slot)]["item"] == "repairkit0"..string.sub(Bag[tostring(Slot)]["item"],11,12) then
                            if rEVOLT.CheckDamaged(Inventory[tostring(Target)]["item"]) and Inventory[tostring(Target)]["amount"] == 1 then
                                local Repair = itemRepair(Inventory[tostring(Target)]["item"])
                                if Repair and Repair == Bag[tostring(Slot)]["item"] then
                                    Inventory[tostring(Target)]["item"] = splitString(Inventory[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                    Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - 1
                                end
                            end
                        else
                            Inventory[tostring(Target)], Bag[tostring(Slot)] = Bag[tostring(Slot)], Inventory[tostring(Target)]
                        end
                    end
                end
            end

            if "Armamento" == itemType(Bag[tostring(Slot)]["item"]) then
                if tonumber(Slot) <= 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,Bag[tostring(Slot)]["item"])
                end
            end

            if "Armamento" == itemType(Inventory[tostring(Target)]["item"]) then
                if tonumber(Slot) <= 5 then
                    TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Target)]["item"])
                end
            end

            if Bag[tostring(Slot)]["amount"] <= 0 then
                Bag[tostring(Slot)] = nil
            end

            return Bag
        end
        TriggerClientEvent("chest:Update",source,"Refresh")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREBAG
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.StoreBag(Passport, Name, Amount, Slot, Target)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Bag = rEVOLT.GetItemData(Passport, Name) 
        local Inventory = rEVOLT.Inventory(Passport) --[[ SplitOne(Inventory[tostring(Slot)]["item"],"-") ~= SplitOne(Name,"-") ]]
        if Inventory[tostring(Slot)] and Amount <= Inventory[tostring(Slot)]["amount"] and itemChest(Inventory[tostring(Slot)]["item"]) ~= true and notStoreBag(SplitOne(Name,"-"),SplitOne(Inventory[tostring(Slot)]["item"],"-")) then

            local Stack = itemStack(Inventory[tostring(Slot)]["item"])
            if not Bag[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Inventory[tostring(Slot)]["amount"] then
                    Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                    Bag[tostring(Target)] = { item = Inventory[tostring(Slot)]["item"], amount = Added, data = Inventory[tostring(Slot)]["data"] }
                end
            else
                if Bag[tostring(Target)]["item"] == Inventory[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - Bag[tostring(Target)]["amount"]))
                    if Added <= Inventory[tostring(Slot)]["amount"] then
                        Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - Added
                        Bag[tostring(Target)]["amount"] = Bag[tostring(Target)]["amount"] + Added
                    end
                else
                    if Inventory[tostring(Slot)]["item"] == "repairkit0"..string.sub(Inventory[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(Bag[tostring(Target)]["item"]) and Bag[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(Bag[tostring(Target)]["item"])
                            if Repair and Repair == Inventory[tostring(Slot)]["item"] then
                                Bag[tostring(Target)]["item"] = splitString(Bag[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                                Inventory[tostring(Slot)]["amount"] = Inventory[tostring(Slot)]["amount"] - 1
                            end
                        end
                    else
                        Bag[tostring(Target)], Inventory[tostring(Slot)] = Inventory[tostring(Slot)], Bag[tostring(Target)]
                    end
                end
            end

            if "Armamento" == itemType(Inventory[tostring(Slot)]["item"]) then
                if tonumber(Slot) <= 5 then
                    TriggerClientEvent("inventory:CreateWeapon",source,Inventory[tostring(Slot)]["item"])
                end
            end
            
            if "Armamento" == itemType(Bag[tostring(Target)]["item"]) or "Throwing" == itemType(Bag[tostring(Target)]["item"]) then
                TriggerClientEvent("inventory:verifyWeapon", source, Bag[tostring(Target)]["item"])
                if tonumber(Slot) <= 5 then
                    TriggerClientEvent("inventory:RemoveWeapon",source,Bag[tostring(Target)]["item"])
                end
            end

            if Inventory[tostring(Slot)]["amount"] <= 0 then
                Inventory[tostring(Slot)] = nil
            end

        end
        TriggerClientEvent("chest:Update",source,"Refresh")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function notStoreBag(Name,Item)
    if Name == "suitcase" then

        if Item == "identity" then
            return true
        elseif Item == "driverlicense" then
            return true
        elseif Item == "creditcard" then
            return true
        elseif Item == "debitcard" then
            return true
        elseif Item == "dollars" then
            return true
        elseif Item == "WEAPON_PISTOL" then
            return true
        elseif Item == "WEAPON_PISTOL_MK2" then
            return true
        elseif Item == "WEAPON_COMBATPISTOL" then
            return true
        elseif Item == "WEAPON_HEAVYPISTOL" then
            return true
        elseif Item == "WEAPON_SNSPISTOL" then
            return true
        elseif Item == "WEAPON_STUNGUN" then
            return true
        elseif Item == "WEAPON_M1911" then
            return true
        elseif Item == "WEAPON_GLOCK22" then
            return true
        elseif Item == "WEAPON_GLOCK18C" then
            return true
        elseif Item == "WEAPON_M9" then
            return true
        end

    elseif Name == "ciggypack" then
        if Item == "cigarette" then
            return true
        end
    elseif Name == "wallet" then
        
        if Item == "identity" then
            return true
        elseif Item == "driverlicense" then
            return true
        elseif Item == "creditcard" then
            return true
        elseif Item == "debitcard" then
            return true
        elseif Item == "dollars" then
            return true
        end

    elseif Name == "ollyrancherbag" then
        if Item == "ollyrancher" then
            return true
        end
    elseif Name == "ammo9box" then
        if Item == "AMMO_9" then
            return true
        end
    elseif Name == "ammo45box" then
        if Item == "AMMO_45" then
            return true
        end
    elseif Name == "ammo556box" then
        if Item == "AMMO_556" then
            return true
        end
    elseif Name == "ammo12box" then
        if Item == "AMMO_12" then
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATEBAG
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UpdateBag(Passport, Name, Slot, Target, Amount)
    local source = rEVOLT.Source(Passport)
    local Amount = parseInt(Amount)
    if source and Amount > 0 then
        local Bag = rEVOLT.GetItemData(Passport, Name)
        if Bag[tostring(Slot)] and Amount <= Bag[tostring(Slot)]["amount"] then
            local Stack = itemStack(Bag[tostring(Slot)]["item"])
            if not Bag[tostring(Target)] then
                local Added = math.min(Amount, Stack)
                if Added <= Bag[tostring(Slot)]["amount"] then
                    Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - Added
                    Bag[tostring(Target)] = { item = Bag[tostring(Slot)]["item"], amount = Added, data = Bag[tostring(Slot)]["data"] }
                end
            else
                if Bag[tostring(Target)]["item"] == Bag[tostring(Slot)]["item"] then
                    local Added = math.min(Amount, (Stack - Bag[tostring(Target)]["amount"]))
                    if Added <= Bag[tostring(Slot)]["amount"] then
                        Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - Added
                        Bag[tostring(Target)]["amount"] = Bag[tostring(Target)]["amount"] + Added
                    end
                else
                    if Bag[tostring(Slot)]["item"] == "repairkit0"..string.sub(Bag[tostring(Slot)]["item"],11,12) then
                        if rEVOLT.CheckDamaged(Bag[tostring(Target)]["item"]) and Bag[tostring(Target)]["amount"] == 1 then
                            local Repair = itemRepair(Bag[tostring(Target)]["item"])
                            if Repair and Repair == Bag[tostring(Slot)]["item"] then
                                Bag[tostring(Slot)]["amount"] = Bag[tostring(Slot)]["amount"] - 1
                                Bag[tostring(Target)]["item"] = splitString(Bag[tostring(Target)]["item"], "-")[1] .."-"..os.time()
                            end
                        end
                    else
                        Bag[tostring(Target)], Bag[tostring(Slot)] = Bag[tostring(Slot)], Bag[tostring(Target)]
                    end
                end
            end

            if Bag[tostring(Slot)]["amount"] <= 0 then
                Bag[tostring(Slot)] = nil
            end

        else
            TriggerClientEvent("chest:Update",source,"Refresh")
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SRVSYNC
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
        for Route,Table in pairs(Drops) do
            for Number,v in pairs(Table) do
                if Drops[Route] and Drops[Route][Number] and os.time() >= v["Timer"] then
                    TriggerClientEvent("inventory:DropsRemover",-1,Route,Number)
                    Drops[Route][Number] = nil
                end
            end
        end
		for Key,Value in pairs(srvData) do
			if Value["timer"] and os.time() >= Value["timer"] then
                rEVOLT.Query("entitydata/SetData",{ dkey = Key, dvalue = json.encode(Value["data"]) })
				srvData[Key] = nil
			end
		end
		Wait(60000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESOURCESTART
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("onResourceStart",function(Resource)
    if "revolt" == Resource then
        Wait(3000)
    end
end)