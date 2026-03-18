local function ensureTable(v) return type(v)=="table" and v or {} end
local function ensureBool(v) return v and true or false end

local function safeTunnelCall(fn, default, ...)
    if type(fn) ~= "function" then return default end
    local ok, res = pcall(fn, ...)
    if ok then return res end
    print(("[NUI] safeTunnelCall error: %s"):format(res))
    return default
end
if type(RegisterNuiCallback)~="function" and type(RegisterNUICallback)=="function" then RegisterNuiCallback=RegisterNUICallback end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNuiCallback('GetPermissions', function(data, cb)
    data = ensureTable(data)
    local roleEdit = data.roleEdit

    local permissions = safeTunnelCall(vTunnel.getPermissions, {}, roleEdit)
    permissions = ensureTable(permissions)

    local t = {}
    for perm, status in pairs(permissions) do
        if Config.defaultPermissions and Config.defaultPermissions[perm] then
            t[#t + 1] = { perm = perm, status = ensureBool(status) }
        end
    end

    cb(t)
end)

RegisterNUICallback('SetPermissions', function(data, cb)
    data = ensureTable(data)
    local perms = ensureTable(data.permissions)

    local t = {}
    for perm, v in pairs(perms) do
        if type(perm) == "string" then
            v = ensureTable(v)
            t[perm] = ensureBool(v.status)
        end
    end

    cb(ensureBool(vTunnel.updatePermissions(data.role, t)))
end)

RegisterNUICallback('SetConfig', function(data, cb)
    if (data.discord and not data.discord:find('https://')) then
        return print('Discord: Insira um URL Valido Insira um URL Valido Exemplo: https://discord.gg/ywytvuwpsE.')
    end

    if (data.banner and not data.banner:find('https://')) then
        return print('Banner: Insira um URL Valido Exemplo: https://google.com/imagem.png.')
    end

    if (data.logo and not data.logo:find('https://')) then
        return print('Logo: Insira um URL Valido Exemplo: https://google.com/imagem.png.')
    end

    cb(ensureBool(vTunnel.updateConfig(data)))
end)
