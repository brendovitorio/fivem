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

local function dbg(tag, data)
    local ok, j = pcall(json.encode, data or {})
    print(("[revolt_orgs][NUI][%s] %s"):format(tag, ok and j or tostring(data)))
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("GetMembers", function(data,cb)
    dbg("GetMembers:call", data)
    local members = ensureTable(safeTunnelCall(vTunnel and vTunnel.getMembers, {}))
    dbg('GetMembers:ret', members)
    cb(members)
end)

RegisterNuiCallback('DemoteMember', function(data, cb)
    dbg('DemoteMember:call', data)
local res = safeTunnelCall(vTunnel and vTunnel.genMember, nil, { memberId = data.id, action = 'demote' })
    dbg('DemoteMember:ret', res)
    cb(ensureBool(res))
end)

RegisterNuiCallback('PromoteMember', function(data, cb)
    dbg('PromoteMember:call', data)
    local res = safeTunnelCall(vTunnel and vTunnel.genMember, nil, { memberId = data.id, action = 'promote' })
    dbg('PromoteMember:ret', res)
    cb(ensureBool(res))
end)

RegisterNuiCallback('DimissMember', function(data, cb)
    dbg('DimissMember:call', data)
    local res = safeTunnelCall(vTunnel and vTunnel.genMember, nil, { memberId = data.id, action = 'dismiss' })
    dbg('DimissMember:ret', res)
    cb(ensureBool(res))
end)--test

-- Invite accept/decline (NUI modal)
RegisterNUICallback("InviteAccept", function(data, cb)
    dbg("InviteAccept -> " .. safeJson(data))
    local res = vTunnel.acceptInvite and vTunnel.acceptInvite(data) or { ok=false, success=false, message="acceptInvite not implemented" }
    cb(res)
    -- após aceitar, fecha modal e atualiza dados
    if not PANEL_VISIBLE then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
    SendNUIMessage({ action = "inviteClose" })
    SendNUIMessage({ action = "refresh", data = { reason = "members" } })
end)

RegisterNUICallback("InviteDecline", function(data, cb)
    dbg("InviteDecline -> " .. safeJson(data))
    local res = vTunnel.declineInvite and vTunnel.declineInvite(data) or { ok=false, success=false, message="declineInvite not implemented" }
    cb(res)
    if not PANEL_VISIBLE then
        SetNuiFocus(false, false)
        SetNuiFocusKeepInput(false)
    end
    SendNUIMessage({ action = "inviteClose" })
end)
