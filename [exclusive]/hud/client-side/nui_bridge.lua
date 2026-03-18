-----------------------------------------------------------------------------------------------------------------------------------------
-- NUI BRIDGE (compatibilidade: HUD antigo -> NUI nova React)
-- Objetivo: NÃO mexer no estilo da NUI, só padronizar o payload para ela renderizar.
-----------------------------------------------------------------------------------------------------------------------------------------

local function normalizePayload(t)
    if type(t) ~= "table" then return {} end

    -- Mapeamentos do HUD antigo para os nomes esperados pela NUI nova
    if t.heart ~= nil and t.health == nil then t.health = t.heart end
    if t.armour ~= nil and t.armor == nil then t.armor = t.armour end

    if t.km ~= nil and t.speed == nil then t.speed = t.km end
    if t.location ~= nil and t.streetName == nil then t.streetName = t.location end
    if t.crossing ~= nil and t.areaName == nil then t.areaName = t.crossing end
    if t.hour ~= nil and t.time == nil then t.time = t.hour end
    if t.hudIsActive ~= nil and t.show == nil then t.show = t.hudIsActive and true or false end

    return t
end

function HudSend(data)
    data = normalizePayload(data)
    data.action = "updateHud"
    SendNUIMessage(data)
end

function HudToggle(show)
    SendNUIMessage({ action = "toggleHud", show = show and true or false })
end
