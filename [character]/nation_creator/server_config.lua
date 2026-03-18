local Tunnel = module("revolt","lib/Tunnel")
local Proxy  = module("revolt","lib/Proxy")

local rEVOLT  = Proxy.getInterface("rEVOLT")
local fclient = Tunnel.getInterface("nation_creator")
local vHUD    = Tunnel.getInterface("hud")
local REQUEST = Tunnel.getInterface("request")

local func = {}
Tunnel.bindInterface("nation_creator", func)

local multiCharacter = true

---------------------------------------------------------------------------
-- Helpers
---------------------------------------------------------------------------
local function safeDecode(data)
    if data == nil then return nil end
    if type(data) == "table" then return data end
    if type(data) == "string" and data ~= "" then
        local ok, decoded = pcall(json.decode, data)
        if ok then return decoded end
    end
    return nil
end

local function isEmpty(t)
    if t == nil then return true end
    if type(t) == "string" then return t == "" end
    if type(t) ~= "table" then return false end
    for _, v in pairs(t) do
        if v ~= nil then return false end
    end
    return true
end

local function getLicenseHex(src)
    local ids = GetPlayerIdentifiers(src)
    for _, v in ipairs(ids) do
        if v:sub(1,8) == "license:" then
            return v:sub(9) -- remove "license:"
        end
    end
    for _, v in ipairs(ids) do
        if v:sub(1,6) == "steam:" then
            return v:sub(7) -- remove "steam:"
        end
    end
    return nil
end

local function formatMoney(n)
    n = tonumber(n) or 0
    local s = tostring(math.floor(n))
    local left,num,right = string.match(s,'^([^%d]*%d)(%d*)(.-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1.'):reverse())..right
end

---------------------------------------------------------------------------
-- SQL layer (NÃO usa Proxy.lua / rEVOLT.Query)
---------------------------------------------------------------------------
local _prepared = {}

local function Prepare(name, sql)
    _prepared[name] = sql
    return true
end

local function Query(nameOrSql, params)
    params = params or {}
    local sql = _prepared[nameOrSql] or nameOrSql
    if type(sql) ~= "string" then
        print("^1[nation_creator][SQL] Query inválida (esperado string): "..tostring(nameOrSql).."^0")
        return nil
    end
    return exports.oxmysql:query_async(sql, params)
end

---------------------------------------------------------------------------
-- SQL prepares
---------------------------------------------------------------------------
if multiCharacter then
    Prepare("nation_creator/hasAgeColumn", [[
        SELECT COUNT(*) as c
        FROM INFORMATION_SCHEMA.COLUMNS
        WHERE TABLE_SCHEMA = DATABASE()
          AND TABLE_NAME = 'characters'
          AND COLUMN_NAME = 'age'
    ]])

    Prepare("nation_creator/addAgeColumn", [[
        ALTER TABLE characters ADD COLUMN age INT(11) NOT NULL DEFAULT 20
    ]])

    Prepare("nation_creator/update_user_first_spawn", [[
        UPDATE characters
        SET name2 = @firstname, name = @name, age = @age, sex = @sex
        WHERE id = @user_id
    ]])

    Prepare("nation_creator/create_characters", [[
        INSERT INTO characters(license,name,name2,phone,blood)
        VALUES(@license,@name,@name2,@phone,@blood)
    ]])

    Prepare("nation_creator/remove_characters", [[
        UPDATE characters SET deleted = 1 WHERE id = @id
    ]])

    Prepare("nation_creator/get_characters", [[
        SELECT * FROM characters WHERE license = @license and deleted = 0
    ]])

    Prepare("nation_creator/get_character", [[
        SELECT * FROM characters WHERE license = @license and deleted = 0 and id = @user_id
    ]])

    Prepare("nation_creator/get_bank", [[
        SELECT bank FROM characters WHERE id = @user_id
    ]])

    -- cria coluna só se não existir (idempotente)
    CreateThread(function()
        local rows = Query("nation_creator/hasAgeColumn", {}) or {}
        local c = tonumber((rows[1] and rows[1].c) or 0) or 0
        if c == 0 then
            local ok, err = pcall(function()
                Query("nation_creator/addAgeColumn", {})
            end)
            if not ok then
                print("^1[ nation_creator ] Falha ao adicionar coluna age: "..tostring(err).."^0")
            end
        end
    end)
else
    Prepare("nation_creator/update_user_first_spawn", [[
        UPDATE revolt_user_identities
        SET firstname = @firstname, name = @name, age = @age
        WHERE user_id = @user_id
    ]])
end

---------------------------------------------------------------------------
-- Permissão
---------------------------------------------------------------------------
function func.checkPermission(permission, src)
    local source = src or source
    local user_id = rEVOLT.getUserId(source)
    if not user_id then return false end

    if type(permission) == "table" then
        for _, perm in pairs(permission) do
            if rEVOLT.HasGroup(user_id, perm, 3) then
                return true
            end
        end
        return false
    end

    return rEVOLT.HasGroup(user_id, permission, 3)
end

---------------------------------------------------------------------------
-- Char data
---------------------------------------------------------------------------
local function getGender(user_id)
    local datatable = rEVOLT.getUserDataTable(user_id)
    if not datatable or type(datatable) ~= "table" then
        datatable = safeDecode(rEVOLT.getUData(user_id, "Datatable")) or {}
    end

    local model = datatable.Skin or datatable.customization
    if type(model) == "table" then
        model = model.modelhash or model.model
    end

    if model == GetHashKey("mp_m_freemode_01") or model == "mp_m_freemode_01" then
        return "male"
    elseif model == GetHashKey("mp_f_freemode_01") or model == "mp_f_freemode_01" then
        return "female"
    end

    return model
end

local function getUserChar(user_id)
    local raw = rEVOLT.getUData(user_id, "nation_char")
    local data = safeDecode(raw)
    if data and type(data) == "table" then
        data.gender = getGender(user_id) or data.gender
        return data
    end
    return nil
end

local function getUserClothes(user_id)
    local data = safeDecode(rEVOLT.getUData(user_id, "Clothings"))
    if data and not isEmpty(data) then
        return data
    end
    return {}
end

local function getUserTattoos(user_id)
    local data = safeDecode(rEVOLT.getUData(user_id,"Tatuagens"))
    if data and not isEmpty(data) then return data end

    data = safeDecode(rEVOLT.getUData(user_id,"Tattoos"))
    if data and not isEmpty(data) then return data end

    return {}
end

local function setPlayerTattoos(src, user_id)
    TriggerClientEvent("tattoos:Apply", src, getUserTattoos(user_id))
    TriggerClientEvent("reloadtattos", src)
    TriggerEvent('dpn_tattoo:setPedServer', src)
    TriggerClientEvent("nyoModule:tattooUpdate", src, false)
end

function func.setPlayerTattoos(id)
    local src = source
    local user_id = id or rEVOLT.getUserId(src)
    if user_id then
        setPlayerTattoos(src, user_id)
    end
end

local function getUserLastPosition(src, user_id)
    local coords = {-1198.02,-146.04,40.12}

    local datatable = rEVOLT.getUserDataTable(user_id)
    if datatable and datatable.Pos then
        local p = datatable.Pos
        coords = { p.x, p.y, p.z }
    else
        local data = safeDecode(rEVOLT.getUData(user_id, "Datatable"))
        if data and data.Pos then
            local p = data.Pos
            coords = { p.x, p.y, p.z }
        end
    end

    fclient._setPlayerLastCoords(src, coords)
    return coords
end

function func.getUserLastPosition()
    local src = source
    local user_id = rEVOLT.getUserId(src)
    if user_id then
        getUserLastPosition(src, user_id)
    end
end

function func.changeSession(session)
    local src = source
    SetPlayerRoutingBucket(src, tonumber(session) or 0)
end

---------------------------------------------------------------------------
-- Spawn controller
---------------------------------------------------------------------------
local userlogin = {}

local function processSpawnController(src, char, user_id)
    getUserLastPosition(src, user_id)

    if char then
        if not userlogin[user_id] then
            userlogin[user_id] = true
            fclient._spawnPlayer(src, false)
        else
            fclient._spawnPlayer(src, true)
        end

        fclient.setPlayerChar(src, char, true)
        TriggerClientEvent("nation_barbershop:init", src, char)
        setPlayerTattoos(src, user_id)
        fclient._setClothing(src, getUserClothes(user_id))
        return
    end

    userlogin[user_id] = true

    local data = safeDecode(rEVOLT.getUData(user_id, "Barbershop"))
    if data then
        local gender = getGender(user_id)
        fclient._spawnPlayer(src, false)
        fclient._setOldChar(src, data, getUserClothes(user_id), gender, user_id)
    else
        fclient._startCreator(src)
    end
end

local function playerSpawn(user_id, src, first_spawn)
    if first_spawn then
        Wait(1000)
        processSpawnController(src, getUserChar(user_id), user_id)
    end
end

AddEventHandler("rEVOLT:playerSpawn", playerSpawn)

function func.updateLogin()
    local src = source
    local user_id = rEVOLT.getUserId(src)
    if user_id then
        userlogin[user_id] = true
        local char = getUserChar(user_id)
        if char then
            TriggerClientEvent("nation_barbershop:init", src, char)
            setPlayerTattoos(src, user_id)
        end
    end
end

---------------------------------------------------------------------------
-- Save Char
---------------------------------------------------------------------------
function func.saveChar(name, lastName, age, char, id)
    local src = source
    local user_id = id or rEVOLT.getUserId(src)
    if not user_id then return false end

    if char then
        rEVOLT.setUData(user_id, "nation_char", json.encode(char))
    end

    local sex = "M"
    if GetEntityModel(GetPlayerPed(src)) == GetHashKey("mp_f_freemode_01") then
        sex = "F"
    end

    if name and lastName and age then
        Query("nation_creator/update_user_first_spawn", {
            user_id   = user_id,
            firstname = lastName,
            name      = name,
            age       = tonumber(age) or 20,
            sex       = sex
        })

        -- Discordhook (mantido como no seu, mas sem crash)
        local webhook = "----------/890781724705955880/TGOoEGHbFGsuO4Yla4EzTiCmY3CaVBzD0oEJeFltt7G8olEItn6HfDAZa9XCTyorhWJX"
        local identity = rEVOLT.Identities(user_id)
        local infoAccount = identity and identity.license and rEVOLT.Account(identity.license) or nil

        if infoAccount and infoAccount.discord then
            PerformHttpRequest(webhook, function() end, "POST", json.encode({
                content = tostring(infoAccount.discord).." #"..user_id.." "..tostring(name).." "..tostring(lastName)
            }), { ["Content-Type"] = "application/json" })
        end
    end

    TriggerClientEvent("nation_barbershop:init", src, char)

    local skin = (sex == "F") and "mp_f_freemode_01" or "mp_m_freemode_01"
    rEVOLT.SkinCharacter(user_id, skin)

    rEVOLT.playerDropped(src, "Atualizando Personagem.")
    rEVOLT.CharacterChosen(src, user_id, nil)
    return true
end

---------------------------------------------------------------------------
-- Chars info (limite seguro)
---------------------------------------------------------------------------
local function getUserMaxChars(src)
    -- ⚠️ Seu rEVOLT.Account provavelmente NÃO aceita licenseHex cru.
    -- Para não quebrar, retorno fixo. Se quiser premium, me diga o formato que Account espera.
    return 1
end

function func.getCharsInfo()
    local src = source
    local license = getLicenseHex(src)
    if not license then return { chars = {}, maxChars = 0 } end

    local rows = Query("nation_creator/get_characters", { license = license }) or {}
    local info = { chars = {}, maxChars = getUserMaxChars(src) }

    for k, v in ipairs(rows) do
        local char = getUserChar(v.id) or {}
        local clothes = getUserClothes(v.id)

        local gender = "masculino"
        if char.gender == "female" then
            gender = "feminino"
        elseif char.gender and char.gender ~= "male" then
            gender = "outros"
        end

        local bankRows = Query("nation_creator/get_bank", { user_id = v.id }) or {}
        local bank = (bankRows[1] and bankRows[1].bank) or 0

        info.chars[k] = {
            name = tostring(v.name).." "..tostring(v.name2),
            age = tostring(v.age).." anos",
            bank = "$ "..formatMoney(bank),
            clothes = clothes,
            registration = Sanguine(v.blood),
            phone = v.phone,
            user_id = v.id,
            id = "#"..v.id,
            gender = gender,
            char = char
        }
    end

    return info
end

---------------------------------------------------------------------------
-- Play / Create / Delete
---------------------------------------------------------------------------
function func.playChar(info)
    local src = source
    local license = getLicenseHex(src)
    if not license then return end

    local data = Query("nation_creator/get_character", { license = license, user_id = info.user_id }) or {}
    if #data <= 0 then return end

    rEVOLT.CharacterChosen(src, info.user_id, nil)

    local user_id = rEVOLT.getUserId(src) or rEVOLT.getUserId(src) or info.user_id
    local ip = GetPlayerEndpoint(src) or "0.0.0.0"

    rEVOLT.sendLog('joins',
        '[ID]: '..tostring(user_id)..' \n[IP]: '..tostring(ip)..' \n[======ENTROU NO SERVIDOR======]'..
        os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
        true
    )

    playerSpawn(info.user_id, src, true)
end

function func.tryDeleteChar(info)
    return false, "Não permitido"
end

function func.tryCreateChar()
    local src = source
    local license = getLicenseHex(src)
    if not license then return false end

    local data = Query("nation_creator/get_characters", { license = license }) or {}
    if #data >= getUserMaxChars(src) then
        return false
    end

    Query("nation_creator/create_characters", {
        license = license,
        name  = "Individuo",
        name2 = "Indigente",
        phone = rEVOLT.GeneratePhone(),
        blood = math.random(4)
    })

    local myChars = Query("nation_creator/get_characters", { license = license }) or {}
    local newRow = myChars[#myChars]
    if not newRow or not newRow.id then return false end

    local user_id = newRow.id
    rEVOLT.CharacterChosen(src, user_id, "mp_m_freemode_01")
    return true
end

---------------------------------------------------------------------------
-- Commands
---------------------------------------------------------------------------
RegisterCommand('resetchar', function(src, args)
    if not func.checkPermission({ "admin.permissao", "mod.permissao", "Admin" }, src) then return end

    local Passport = rEVOLT.getUserId(src) or rEVOLT.getUserId(src)

    if args[1] then
        local id = tonumber(args[1])
        if not id then return end

        local target = (rEVOLT.getUserSource and rEVOLT.getUserSource(id)) or (rEVOLT.Source and rEVOLT.Source(id))
        if target and vHUD.Request(src, "Deseja resetar o id "..id.." ?", "Sim", "Não") then
            fclient._startCreator(target)
            rEVOLT.sendLog('resetchar',
                '[ID]: '..tostring(Passport)..'\n[RESETOU O PERSONAGEM DE]: '..tostring(id)..
                os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
                true
            )
        end
    else
        if vHUD.Request(src, "Deseja resetar seu personagem ?", "Sim", "Não") then
            fclient._startCreator(src)
            rEVOLT.sendLog('resetchar',
                '[ID]: '..tostring(Passport)..'\n[RESETOU O PERSONAGEM]: PERSONAGEM PRÓPRIO'..
                os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S"),
                true
            )
        end
    end
end)

RegisterCommand('reset', function(src, args)
    local Passport = rEVOLT.getUserId(src) or rEVOLT.getUserId(src)
    if not Passport then return end

    if not (rEVOLT.HasGroup(Passport, "Admin", 2) or not rEVOLT.getUserId(src)) then
        return
    end

    if args[1] then
        local id = tonumber(args[1])
        if not id then return end

        local target = (rEVOLT.Source and rEVOLT.Source(id)) or (rEVOLT.getUserSource and rEVOLT.getUserSource(id))
        if target and rEVOLT.Request(src, "Deseja resetar o id "..id.." ?", "Sim", "Não") then
            fclient._startCreator(target)
        end
    else
        if rEVOLT.Request(src, "Deseja resetar seu personagem ?", "Sim", "Não") then
            fclient._startCreator(src)
        end
    end
end)

RegisterCommand('spawn', function(src)
    local Passport = rEVOLT.getUserId(src) or rEVOLT.getUserId(src)
    if not Passport then return end

    if not (rEVOLT.HasGroup(Passport, "Admin", 2) or not rEVOLT.getUserId(src)) then
        return
    end

    if multiCharacter then
        rEVOLT.playerDropped(src, "Trocando Personagem.")
        Wait(1000)
        TriggerClientEvent("spawn:setupChars", src)
    else
        playerSpawn(rEVOLT.getUserId(src), src, true)
    end
end)

---------------------------------------------------------------------------
-- Event reset
---------------------------------------------------------------------------
RegisterServerEvent("nation:resetplayer")
AddEventHandler("nation:resetplayer", function(src, user_id)
    if src then
        fclient._startCreator(src)
    end
end)
