-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY COMPAT / LEGACY WRAPPERS
-----------------------------------------------------------------------------------------------------------------------------------------
local warned = {}

local function warnOnce(key, msg)
    if warned[key] then return end
    warned[key] = true
    print(("^3[rEVOLT][compat] %s^0"):format(msg))
end

local function resolvePassport(passportOrSource)
    local value = tonumber(passportOrSource) or passportOrSource
    if not value then return nil end
    local passport = rEVOLT.Passport(value)
    if passport then return passport, value end
    return value, rEVOLT.Source(value)
end

local function resolveSource(passportOrSource)
    local value = tonumber(passportOrSource) or passportOrSource
    if not value then return nil end
    local passport = rEVOLT.Passport(value)
    if passport then return value, passport end
    return rEVOLT.Source(value), value
end

function rEVOLT.GetServerData(Key, Save)
    return rEVOLT.GetSrvData(Key, Save)
end

function rEVOLT.SetServerData(Key, Data, Save)
    return rEVOLT.SetSrvData(Key, Data, Save)
end

function rEVOLT.FullName(passportOrSource)
    local Passport = tonumber(passportOrSource) or passportOrSource
    if not Passport then return "Individuo Indigente" end

    local sourcePassport = rEVOLT.Passport(Passport)
    if sourcePassport then Passport = sourcePassport end

    local Identity = rEVOLT.Identity(Passport)
    if Identity then
        return (Identity.name or "Individuo") .. " " .. (Identity.name2 or "Indigente")
    end

    return "Individuo Indigente"
end

function rEVOLT.CheckRolepass(passportOrSource)
    local Passport = resolvePassport(passportOrSource)
    if not Passport then return false end

    local Identity = rEVOLT.Identity(Passport)
    if not Identity or not Identity.license then return false end

    local Account = rEVOLT.Account(Identity.license)
    if not Account then return false end

    local Rolepass = tonumber(Account.rolepass) or 0
    return Rolepass > os.time() or Rolepass > 0
end

function rEVOLT.UserPremium(passportOrSource)
    local Passport = resolvePassport(passportOrSource)
    if not Passport then return false end

    if rEVOLT.HasGroup and rEVOLT.HasGroup(Passport, "Premium") then
        return true
    end

    local Identity = rEVOLT.Identity(Passport)
    if not Identity or not Identity.license then return false end

    local Account = rEVOLT.Account(Identity.license)
    if not Account then return false end

    local Premium = tonumber(Account.premium) or 0
    return Premium > os.time() or Premium > 0
end

local function syncPremiumGroup(Passport, enable)
    if not Passport or not rEVOLT.SetPermission then return end
    if enable then
        rEVOLT.SetPermission(Passport, "Premium")
    end
end

function rEVOLT.SetPremium(passportOrSource, seconds)
    local Passport = resolvePassport(passportOrSource)
    if not Passport then return false end

    local Identity = rEVOLT.Identity(Passport)
    if not Identity or not Identity.license then return false end

    local expiresAt = os.time() + (tonumber(seconds) or 30 * 24 * 60 * 60)
    rEVOLT.Query("UPDATE accounts SET premium = @premium WHERE license = @license", {
        premium = expiresAt,
        license = Identity.license
    })
    syncPremiumGroup(Passport, true)
    return true
end

function rEVOLT.UpgradePremium(passportOrSource, seconds)
    local Passport = resolvePassport(passportOrSource)
    if not Passport then return false end

    local Identity = rEVOLT.Identity(Passport)
    if not Identity or not Identity.license then return false end

    local Account = rEVOLT.Account(Identity.license)
    local baseTime = os.time()
    if Account and tonumber(Account.premium) and tonumber(Account.premium) > baseTime then
        baseTime = tonumber(Account.premium)
    end

    local expiresAt = baseTime + (tonumber(seconds) or 30 * 24 * 60 * 60)
    rEVOLT.Query("UPDATE accounts SET premium = @premium WHERE license = @license", {
        premium = expiresAt,
        license = Identity.license
    })
    syncPremiumGroup(Passport, true)
    return true
end

function rEVOLT.UpgradeCough(Passport, Amount)
    local Datatable = rEVOLT.Datatable(Passport)
    if not Datatable then return false end
    Datatable.Cough = math.min(100, (tonumber(Datatable.Cough) or 0) + (tonumber(Amount) or 0))
    return Datatable.Cough
end

function rEVOLT.DowngradeCough(Passport, Amount)
    local Datatable = rEVOLT.Datatable(Passport)
    if not Datatable then return false end
    Datatable.Cough = math.max(0, (tonumber(Datatable.Cough) or 0) - (tonumber(Amount) or 0))
    return Datatable.Cough
end

function rEVOLT.UpgradeOxygen(Passport, Amount)
    local Datatable = rEVOLT.Datatable(Passport)
    if not Datatable then return false end
    Datatable.Oxygen = math.min(100, (tonumber(Datatable.Oxygen) or 0) + (tonumber(Amount) or 0))
    return Datatable.Oxygen
end

function rEVOLT.GiveFine(Passport, Value, Message, OfficerName)
    Passport = tonumber(Passport)
    Value = tonumber(Value) or 0
    if not Passport or Value <= 0 then return false end

    local officer = OfficerName or "Sistema"
    local identityName = rEVOLT.FullName(Passport)
    local date = os.date("%d/%m/%Y")
    local hour = os.date("%H:%M")

    rEVOLT.Query("fines/Add", {
        Passport = Passport,
        Name = officer,
        Date = date,
        Hour = hour,
        Value = Value,
        Message = Message or ("Multa aplicada a %s"):format(identityName)
    })

    rEVOLT.Query("UPDATE characters SET fines = fines + @Value WHERE id = @Passport", {
        Passport = Passport,
        Value = Value
    })

    return true
end

function rEVOLT.DoesEntityExist(source)
    local Ped = GetPlayerPed(source)
    return Ped and Ped > 0 and DoesEntityExist(Ped) or false
end

function rEVOLT.ClosestVehicle(source, Radius)
    return rEVOLTC.ClosestVehicle(source, Radius)
end

function rEVOLT.PlayAnim(source, Upper, Sequency, Loop, blendInSpeed, blendOutSpeed, Time, Flag)
    return rEVOLTC.playAnim(source, Upper, Sequency, Loop, blendInSpeed, blendOutSpeed, Time, Flag)
end

function rEVOLT.CreateObjects(source, Dict, Anim, Prop, Flag, Hands, Pos1, Pos2, Pos3, Pos4, Pos5, Pos6)
    return rEVOLTC.createObjects(source, Dict, Anim, Prop, Flag, Hands, Pos1, Pos2, Pos3, Pos4, Pos5, Pos6)
end

function rEVOLT.Destroy(source, Mode)
    return rEVOLTC.removeObjects(source, Mode)
end

function rEVOLT.Task(source, amount, duration)
    local ok = pcall(function()
        if exports["taskbar"] and exports["taskbar"].taskBar then
            return exports["taskbar"]:taskBar(source, tonumber(duration) or 1000)
        end
    end)
    if ok then
        return true
    end
    warnOnce("task", "Task() não encontrou minigame/taskbar; usando fallback liberado.")
    return true
end

function rEVOLT.Memory(source)
    local ok, result = pcall(function()
        if exports["memory"] and exports["memory"].Memory then
            return exports["memory"]:Memory(source)
        end
    end)
    if ok and result ~= nil then return result end
    warnOnce("memory", "Memory() não encontrou recurso de memória; usando fallback liberado.")
    return true
end

function rEVOLT.Device(source, seconds)
    local ok, result = pcall(function()
        if exports["hackdevice"] and exports["hackdevice"].Device then
            return exports["hackdevice"]:Device(source, seconds)
        end
    end)
    if ok and result ~= nil then return result end
    warnOnce("device", "Device() não encontrou recurso de hacking; usando fallback liberado.")
    return true
end

function rEVOLT.Blackout()
    GlobalState["Blackout"] = true
    TriggerClientEvent("Notify", -1, "azul", "A cidade entrou em apagão temporário.", "Central", 5000)
    return true
end
