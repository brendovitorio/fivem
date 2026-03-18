local function ensureTable(v) return type(v)=="table" and v or {} end
local function ensureBool(v) return v and true or false end
if type(RegisterNuiCallback)~="function" and type(RegisterNUICallback)=="function" then RegisterNuiCallback=RegisterNUICallback end

RegisterNUICallback('GetPartners', function(data, cb)
    cb(ensureTable(vTunnel.GetPartners()))
end)

RegisterNUICallback('NewPartner', function(data, cb)
    cb(ensureBool(vTunnel.addPartner(data)))
end)

RegisterNUICallback('DeletePartner', function(data,cb)
    cb(ensureBool(vTunnel.deletePartner(data.partner)))
end)
