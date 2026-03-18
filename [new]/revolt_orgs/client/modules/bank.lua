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

RegisterNuiCallback('GetExtracts', function(data, cb)
    dbg('GetExtracts:call', data)
    local res = ensureTable(safeTunnelCall(vTunnel and vTunnel.getBankInfos, {}))
    dbg('GetExtracts:ret', res)
    cb(res)
end)

RegisterNuiCallback('Withdraw', function(data, cb)
    dbg('Withdraw:call', data)
    local ok = ensureBool(safeTunnelCall(vTunnel and vTunnel.transactionBank, false, { type = 'withdraw', amount = data.value }))
    dbg('Withdraw:ret', { ok = ok })
    cb(ok)
end)
  
RegisterNuiCallback('Deposit', function(data, cb)
    dbg('Deposit:call', data)
    local ok = ensureBool(safeTunnelCall(vTunnel and vTunnel.transactionBank, false, { type = 'deposit', amount = data.value }))
    dbg('Deposit:ret', { ok = ok })
    cb(ok)
end)

RegisterNetEvent('updateExtract', function(data)
    SendNUIMessage({ action = 'UpdateExtracts', data = data.extracts })
    SendNUIMessage({ action = 'UpdateBalance', data = data.balance })
    SendNUIMessage({ action = 'UpdatePlayerBalance', data = data.playerBalance })
end)

-- =========================
-- Aliases esperados pela UI nova
-- =========================
RegisterNUICallback("GetBankInfo", function(_, cb)
    dbg("GetBankInfo:call", {})
    local res = safeTunnelCall(vTunnel.getBankInfo, {})
    dbg("GetBankInfo:ret", res)
    cb(type(res)=="table" and res or {})
end)

RegisterNUICallback("DepositMoney", function(data, cb)
    dbg("DepositMoney:call", data)
    local amount = tonumber((data and data.amount) or 0) or 0
    local ok = safeTunnelCall(vTunnel._bankTransaction, false, { type = "deposit", amount = amount })
    dbg('DepositMoney:ret', { ok = ok })
    dbg('WithdrawMoney:ret', { ok = ok })
    dbg('TransferMoney:ret', { ok = ok })
    cb(ok and true or false)
end)

RegisterNUICallback("WithdrawMoney", function(data, cb)
    dbg("WithdrawMoney:call", data)
    local amount = tonumber((data and data.amount) or 0) or 0
    local ok = safeTunnelCall(vTunnel._bankTransaction, false, { type = "withdraw", amount = amount })
    cb(ok and true or false)
end)

RegisterNUICallback("TransferMoney", function(data, cb)
    dbg("TransferMoney:call", data)
    local amount = tonumber((data and data.amount) or 0) or 0
    -- UI manda "to" como número; aqui tratamos como organization string se vier
    local to = (data and data.to) or (data and data.toOrg)
    local ok = safeTunnelCall(vTunnel._bankTransaction, false, { type = "transfer", amount = amount, toOrg = tostring(to or "") })
    cb(ok and true or false)
end)
