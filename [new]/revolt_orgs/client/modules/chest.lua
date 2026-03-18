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

RegisterNuiCallback('GetRegisters', function(data, cb)
    cb(ensureTable(vTunnel.getLogs()))
end)