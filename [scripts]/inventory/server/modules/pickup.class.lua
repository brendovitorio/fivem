---@class PickupSystem
PickupSystem = {
    pickups = {}
}

local failedAttempts = {}

---@param ownerInfo table<string, number>
---@param idname string
---@param amount number
---@param coords vector3
function PickupSystem:Create(ownerInfo,idname,amount,coords)
    local id = IdGen:gen()
    local src = ownerInfo.src
    local user_id = ownerInfo.user_id
    local itemData = ResolveItemData(idname) or { name = idname, weight = 0 }
    self.pickups[id] = {id = id, item = idname, name = itemData.name or idname , amount = amount,coords = coords, owner_id = user_id}
    TriggerNearEvent(Remote.getActivePlayers(src), "CreatePickup", self.pickups[id],id)
end

---@param id number
---@param user number
---@param src number
---@return boolean
function PickupSystem:getPickup(id, user, src, amount, slot)
  

    local pickupInfo = self.pickups[id]
    local amount = tonumber(amount) or pickupInfo.amount
    if amount > pickupInfo.amount then
        amount = pickupInfo.amount
    end
    if amount < 1 then
        return false
    end
    if rEVOLT.computeInvWeight(user) + (ResolveItemData(pickupInfo.item) and ResolveItemData(pickupInfo.item).weight or 0) * amount > rEVOLT.getInventoryMaxWeight(user) then 
        Notify(src, "negado", 'Espaço insuficiente na mochila!')
        return false
    end

    -- local coords = GetEntityCoords(GetPlayerPed(src))
    -- if #(coords - pickupInfo.coords) > 15.0 then
    --     print('SUSPEITO PEGANDO ITEM DE LONGE - ID: ' .. user)
    --     TriggerEvent("AC:ForceBan", src, {
    --         reason = "Hack (Pickup)",
    --         forceBan = false
    --     })
    --     return false
    -- end

    if amount < pickupInfo.amount then
        pickupInfo.amount = pickupInfo.amount - amount
        self.pickups[id] = pickupInfo
        TriggerNearEvent(Remote.getActivePlayers(src), "UpdatePickup", pickupInfo, id)
    else
        self.pickups[id] = nil
        IdGen:free(id)
        TriggerNearEvent(Remote.getActivePlayers(src), "RemovePickup", id)
    end

    Notify(src, "sucesso", "Você pegou " .. pickupInfo.name .. " (" .. amount .. "x)")

    rEVOLT.giveInventoryItem(user, pickupInfo.item, amount, true, slot)

    rEVOLTc._playSound(src, "HUD_FRONTEND_DEFAULT_SOUNDSET", "PICK_UP")
    rEVOLTc._playAnim(src, true, {{"pickup_object", "pickup_low"}}, false)

    exports["admin"]:generateLog({
        category = "inventario",
        room = "pegou",
        user_id = user,
        message = ( [[O USER_ID %s PEGOU O ITEM %s NA QUANTIDADE DE %s x]] ):format(user, pickupInfo.item, amount)
    })

    return true
end