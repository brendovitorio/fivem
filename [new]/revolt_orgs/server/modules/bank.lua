-- server/modules/bank.lua (compat e robustez)
-- Este resource agora usa oxmysql via wrapper em server/server.lua.
-- Mantém este arquivo apenas para evitar dependências antigas em rEVOLT.prepare/query.

BANK = BANK or {}
BANK.cooldown = BANK.cooldown or {}

if type(BANK.generateLog) ~= "function" then
    function BANK:generateLog(historic, data)
        historic = type(historic) == "table" and historic or {}
        if #historic > 20 then table.remove(historic, 1) end
        historic[#historic + 1] = data
        return historic
    end
end

-- Aliases antigos (caso algum client/module use)
function RegisterTunnel.getBankInfos()
    if type(RegisterTunnel.getBankInfo) == "function" then
        local res = RegisterTunnel.getBankInfo()
        return (type(res)=="table" and res.bankHistoric) or {}
    end
    return {}
end

function RegisterTunnel.transactionBank(data)
    if type(RegisterTunnel._bankTransaction) == "function" then
        data = type(data)=="table" and data or {}
        local t = tostring(data.type or "")
        local amount = tonumber(data.amount or data.value) or 0
        if t == "withdraw" or t == "deposit" or t == "transfer" then
            return RegisterTunnel._bankTransaction({ type = t, amount = amount, toOrg = data.toOrg, to = data.to })
        end
    end
    return false
end
