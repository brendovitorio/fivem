local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
fclient = Tunnel.getInterface("nation_tattoos")
func = {}
Tunnel.bindInterface("nation_tattoos", func)

function func.checkPermission(permission, src)
    local source = src or source
    local Passport = rEVOLT.getUserId(source)
    if type(permission) == "table" then
        for i, perm in pairs(permission) do
            if rEVOLT.HasGroup(Passport, perm) then
                return true
            end
        end
        return false
    end
    return not permission or rEVOLT.HasGroup(Passport, permission)
end

function func.saveChar(t)
    local source = source
    local Passport = rEVOLT.getUserId(source)
    if Passport then
        local char = getUserChar(Passport)
        char.tattoos, char.overlay = t.tattoos, t.overlay
        rEVOLT.execute("playerdata/SetData",{ Passport = parseInt(Passport), dkey = "Tatuagens", dvalue = json.encode(char,{indent=false}) })
    end
end

function func.tryPay(value)
    local source = source
    local Passport = rEVOLT.getUserId(source)
    if value >= 0 then
        if rEVOLT.PaymentFull(Passport, value) or value == 0 then
            return true
        end
    end
    return false
end

function func.getTattoos()
    local source = source
    local Passport = rEVOLT.getUserId(source)
    if Passport then
        local char = getUserChar(Passport)
        return (char.tattoos or {}), (char.overlay or 0)
    end
    return false
end

function getUserChar(Passport)
    local data = rEVOLT.UserData(Passport, "Tatuagens")
    if next(data) ~= nil then
        local char = data
        if char then
            return char
        end
    end
    return {}
end