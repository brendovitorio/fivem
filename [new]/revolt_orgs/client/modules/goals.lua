local function ensureTable(v) return type(v)=="table" and v or {} end
local function ensureBool(v) return v and true or false end


local function safeTunnelCall(fn, default, ...)
    if type(fn) ~= "function" then return default end
    local ok, res = pcall(fn, ...)
    if ok then return res end
    print(("[NUI] safeTunnelCall error: %s"):format(res))
    return default
end
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- CALLBACKS
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback('NewGoal', function(data, cb)
  cb(ensureBool(vTunnel.newGoal(data)))
end)

RegisterNuiCallback('GetGoals', function(data, cb)
    local res = safeTunnelCall(vTunnel.getGoals, {})
    cb(ensureTable(res))
end)

RegisterNUICallback('GetGoalsDetails', function(data, cb)
      cb(ensureTable(vTunnel.GetGoalsDetails()))
end)

RegisterNUICallback('EditMyGoal', function(data, cb)
  cb(ensureBool(vTunnel.EditMyGoal(data)))
end)

RegisterNUICallback('getPersonalRanking', function(_, cb)
  cb(ensureTable(vTunnel.getPersonalRanking()))
end)

RegisterNUICallback('ClaimRewards', function(data, cb)
  vTunnel._close()

  SetNuiFocus(false, false)
  SendNUIMessage({ action = 'close' })

  cb(ensureBool(vTunnel.ClaimRewards(data.rewards)))
end)