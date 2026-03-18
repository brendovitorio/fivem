-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Active = {}
Sources = {}
Identity = {}
Characters = {}
Dependents = {}
UserPhone = {}
PassportPlate = {}
PreparedQueries = {}
TemporaryData = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
PerformHttpRequest("https://ifconfig.me/ip", function(status, response, headers)
    rEVOLT.ServerEndpoint = response
end, "GET", "", {["Content-Type"] = "application/json"})
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT._Prepare(Name,Query)
    PreparedQueries[Name] = Query
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Desc()
    return ServerName
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Mode(Name)    
    return VehicleMode(Name) 
end  
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.VehiclePrice(Name)     
    return VehiclePrice(Name) 
end
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.VehicleGems(Name)     
    return VehicleGemstone(Name) 
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUERY
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Query(NameOrQuery,Params)
    local query = PreparedQueries[NameOrQuery] or NameOrQuery
    Params = Params or {}

    if NameOrQuery == "playerdata/SetData" then
        Params.dkey = Params.dkey or Params.Name or Params.name or Params.key
        Params.dvalue = Params.dvalue or Params.Information or Params.information or Params.value
    elseif NameOrQuery == "playerdata/GetData" then
        Params.dkey = Params.dkey or Params.Name or Params.name or Params.key
    elseif NameOrQuery == "entitydata/SetData" then
        Params.dkey = Params.dkey or Params.Name or Params.name or Params.key
        Params.dvalue = Params.dvalue or Params.Information or Params.information or Params.value
    elseif NameOrQuery == "entitydata/GetData" or NameOrQuery == "entitydata/RemoveData" then
        Params.dkey = Params.dkey or Params.Name or Params.name or Params.key
    end

    if type(query) ~= "string" then
        print("^1[rEVOLT.Query] Query inválida: "..tostring(NameOrQuery).." | tipo recebido: "..type(query).."^0")
        return {}
    end

    return exports.oxmysql:query_async(query, Params)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IDENTITIES
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Identities(source)
    local Result = false
    local Identifiers = GetPlayerIdentifiers(source)
    for _,v in pairs(Identifiers) do
        if string.find(v,"license") then
            local SplitName = splitString(v,":")
            Result = SplitName[2]
            break
        end
    end
    return Result
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ARCHIVE
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Archive(Archive,Text)
    Archive = io.open(Archive,"a")
    if Archive then
        Archive.write(Archive,Text.."\n")
    end
    Archive.close(Archive)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Banned(License)
    local Consult = rEVOLT.Query("banneds/GetBanned",{ license = License })
    if Consult[1] then
        if Consult[1]["time"] <= os.time() then
            rEVOLT.Query("banneds/RemoveBanned",{ license = License })
            return false
        end
        return true
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ACCOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Account(License)
    local Consult = rEVOLT.Query("accounts/Account",{ license = License })
    return Consult[1] or false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- USERDATA
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.UserData(Passport,Key)
    local Consult = rEVOLT.Query("playerdata/GetData",{ Passport = Passport, dkey = Key })
    if Consult[1] then
        return json.decode(Consult[1]["dvalue"])
    else
        return {}
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INSIDEPROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.InsidePropertys(Passport,Coords)
    local Datatable = rEVOLT.Datatable(Passport)
    if Datatable then
        Datatable["Pos"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- INVENTORY
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Inventory(Passport)
    local Datatable = rEVOLT.Datatable(Passport)
    if Datatable then
        if not Datatable["Inventory"] then
            Datatable["Inventory"] = {}
        end
        return Datatable["Inventory"]
    end
    return {}
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SAVETEMPORARY
-------------------------------------- ---------------------------------------------------------------------------------------------------
function rEVOLT.SaveTemporary(Passport,source,Route)
    local source = source
    local Datatable = rEVOLT.Datatable(Passport)
    local Ped = GetPlayerPed(source)
    if not TemporaryData[Passport] and Datatable then
        TemporaryData[Passport] = {}
        TemporaryData[Passport]["Inventory"] = Datatable["Inventory"]
        TemporaryData[Passport]["Health"] = GetEntityHealth(Ped)
        TemporaryData[Passport]["Armour"] = GetPedArmour(Ped)
        TemporaryData[Passport]["Stress"] = Datatable["Stress"]
        TemporaryData[Passport]["Hunger"] = Datatable["Hunger"]
        TemporaryData[Passport]["Thirst"] = Datatable["Thirst"]
        TemporaryData[Passport]["route"] = Route
        --SetPedArmour(Ped,100)
        rEVOLTC.setArmour(source,100)
        rEVOLTC.SetHealth(source,200)
        rEVOLT.UpgradeHunger(Passport,100)
        rEVOLT.UpgradeThirst(Passport,100)
        rEVOLT.DowngradeStress(Passport,100)
        TriggerEvent("inventory:saveTemporary", Passport)
        Datatable["Inventory"] = {}
        for Number,v in pairs(ArenaItens) do
            rEVOLT.GenerateItem(Passport,Number,v,false)
        end
        TriggerEvent("rEVOLT:BucketServer",source,"Enter",Route)
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- APPLYTEMPORARY
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.ApplyTemporary(Passport,source)
    local source = source
    local Datatable = rEVOLT.Datatable(Passport)
    local Ped = GetPlayerPed(source)
    if TemporaryData[Passport] and Datatable then
        Datatable["Inventory"] = {}
        Datatable["Inventory"] = TemporaryData[Passport]["Inventory"]
        Datatable["Stress"] = TemporaryData[Passport]["Stress"]
        Datatable["Hunger"] = TemporaryData[Passport]["Hunger"]
        Datatable["Thirst"] = TemporaryData[Passport]["Thirst"]

        TriggerClientEvent("hud:Thirst",source,Datatable["Thirst"])
        TriggerClientEvent("hud:Hunger",source,Datatable["Hunger"])
        TriggerClientEvent("hud:Stress",source,Datatable["Stress"])
        
        --SetPedArmour(Ped,TemporaryData[Passport]["Armour"])
        rEVOLTC.setArmour(source,TemporaryData[Passport]["Armour"])
        rEVOLTC.SetHealth(source,TemporaryData[Passport]["Health"])
        TriggerEvent("inventory:applyTemporary",Passport)
        TriggerEvent("rEVOLT:BucketServer",source,"Exit")
        TemporaryData[Passport] = nil
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINCHARACTER
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.SkinCharacter(Passport,Hash)
    local Datatable = rEVOLT.Datatable(Passport)
    if Datatable then
        Datatable["Skin"] = Hash
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PASSPORT
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Passport(source)
    if Characters[source] then
        return Characters[source]["id"]
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Players()
    return Sources
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SOURCE
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Source(Passport)
    return Sources[parseInt(Passport)]
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DATATABLE
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Datatable(Passport)
    if Characters[Sources[parseInt(Passport)]] then
        return Characters[Sources[parseInt(Passport)]]["table"]
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICK
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.Kick(source,Reason)
    DropPlayer(source,Reason)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- KICKALL
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.KickALL()
    local List = rEVOLT.Players()
    for _,Sources in pairs(List) do
        rEVOLT.Kick(Sources,"Desconectado, a cidade reiniciou.")
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLAYERDROPPED
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("playerDropped",function(Reason)
    local source = source
    local Ped = GetPlayerPed(source)
    local Health = GetEntityHealth(Ped)
    local Armour = GetPedArmour(Ped)
    local Coords = GetEntityCoords(Ped)
    if Characters[source] and DoesEntityExist(Ped) then
        Disconnect(source,Health,Armour,Coords,Reason)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Disconnect(source,Health,Armour,Coords,Reason)
    local source = source
    local Passport = rEVOLT.Passport(source)
    local Datatable = rEVOLT.Datatable(Passport)
    if Passport then
        TriggerEvent("Discord","Disconnect","**Source:** "..source.."\n**Passaporte:** "..Passport.."\n**Health:** "..Health.."\n**Armour:** "..Armour.."\n**Cds:** "..Coords.."\n**Motivo:** "..Reason,3092790)
        if Datatable then
            if TemporaryData[Passport] then
                Datatable["Stress"] = TemporaryData[Passport]["Stress"]
                Datatable["Hunger"] = TemporaryData[Passport]["Hunger"]
                Datatable["Thirst"] = TemporaryData[Passport]["Thirst"]
                Datatable["Armour"] = TemporaryData[Passport]["Armour"]
                Datatable["Health"] = TemporaryData[Passport]["Health"]
                Datatable["Inventory"] = TemporaryData[Passport]["Inventory"]
                Datatable["Pos"] = { x = BackArenaPos["x"], y = BackArenaPos["y"], z = BackArenaPos["z"] }
                TriggerEvent("arena:Players","-",TemporaryData[Passport]["route"])
                TemporaryData[Passport] = nil
            else
                Datatable["Health"] = Health
                Datatable["Armour"] = Armour
                Datatable["Pos"] = { x = mathLength(Coords["x"]), y = mathLength(Coords["y"]), z = mathLength(Coords["z"]) }
            end
            if Datatable["Health"] <= 100 then
                TriggerClientEvent("hud:Textform",-1,Coords,"<b>Passaporte:</b> "..Passport.."<br><b>Motivo:</b> "..Reason,CombatLogMinutes * 60000)
            end
            TriggerEvent("Disconnect",Passport,source)
            rEVOLT.Query("playerdata/SetData",{ Passport = Passport, dkey = "Datatable", dvalue = json.encode(Datatable) })
            Characters[source] = nil
            Sources[Passport] = nil
            GlobalState["SetDiscord"] = GetNumPlayerIndices()
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- QUEUE:CONNECTING
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Queue:Connecting", function(source, identifiers, deferrals, name)
    deferrals.defer()
    local Identity = rEVOLT.Identities(source)
    if Identity then
        if Maintenance then
            if MaintenanceLicenses[Identity] then
                deferrals.done()
            else
                deferrals.done(MaintenanceText)
            end
        elseif not rEVOLT.Banned(Identity) then
            if Whitelisted then
                local Account = rEVOLT.Account(Identity)
                if Account and Account.whitelist then
                    deferrals.done()
                else
                    local Card = {
                        ["$schema"] = "http://adaptivecards.io/schemas/adaptive-card.json",
                        ["type"] = "AdaptiveCard",
                        ["version"] = "1.4",
                        ["horizontalAlignment"] = 'center',
                        ["body"] = {
                            {
                                ["type"] = "Container",
                                ["items"] = {
                                    {
                                        ["type"] = "TextBlock",
                                        ["text"] = "Bem-vindo à Revolt RP",
                                        ["weight"] = 'bolder',
                                        ["size"] = 'extraLarge', 
                                    },
                                    --[[ {
                                        ["type"] = "TextBlock",
                                        ["text"] = "Olá, "..name.."! Prepare-se para mergulhar na vida vibrante e imprevisível de Revolt RP! Aqui, cada escolha molda o seu destino e cada ação tem uma consequência. Junte-se a outros jogadores, estabeleça alianças, enfrente adversários e construa sua própria história neste vasto universo roleplay. Lembre-se: Respeite as regras, entre no personagem e divirta-se!",
                                        ["isSubtle"] = true,
                                        ["wrap"] = true,
                                    }, ]]
                                    {
                                        ["type"] = "ColumnSet",
                                        ["columns"] = {
                                            {
                                                ["type"] = "Column",
                                                ["width"] = "400px",
                                                ["items"] = {
                                                    {
                                                        ["type"] = "TextBlock",
                                                        ["text"] = "Olá, "..name.."! Prepare-se para mergulhar na vida vibrante e imprevisível de Revolt RP! Aqui, cada escolha molda o seu destino e cada ação tem uma consequência. Junte-se a outros jogadores, estabeleça alianças, enfrente adversários e construa sua própria história neste vasto universo roleplay. Lembre-se: Respeite as regras, entre no personagem e divirta-se!",
                                                        ["isSubtle"] = true,
                                                        ["wrap"] = true,
                                                    },
                                                    
                                                    
                                                },
                                            },
                                            
                                        },
                                    },
                                    {
                                        ["type"] = "ColumnSet",
                                        ["columns"] = {
                                            {
                                                ["type"] = "Column",
                                                ["width"] = "250px",
                                                ["items"] = {
                                                    
                                                    {
                                                        ["type"] = "Input.ChoiceSet",
                                                        ["id"] = "choice_set",
                                                        ["label"] = "Onde nos encontrou?",
                                                        ["placeholder"] = "Selecionar",
                                                        ["choices"] = {
                                                            {
                                                                ["id"] = 'input_text',
                                                                ["type"] = "input_text",
                                                                ["title"] = 'Lista Fivem',
                                                                ["value"] = 'Lista Fivem'
                                                            },
                                                            {
                                                                ["id"] = 'input_text',
                                                                ["type"] = "input_text",
                                                                ["title"] = 'Ultima Season',
                                                                ["value"] = 'Ultima Season'
                                                            },
                                                            {
                                                                ["id"] = 'input_text',
                                                                ["type"] = "input_text",
                                                                ["title"] = 'Tiktok',
                                                                ["value"] = 'Tiktok'
                                                            },
                                                            {
                                                                ["id"] = 'input_text',
                                                                ["type"] = "input_text",
                                                                ["title"] = 'Outros',
                                                                ["value"] = 'Outros'
                                                            },
                                                        }
                                                    },
                                                    
                                                },
                                            },
                                            
                                        },
                                    },
                                }
                            },
                            {
                                ["isVisible"]=false,
                                ["type"] = "Container",
                                ["items"] = {
                                    {
                                        ["type"] = "TextBlock",
                                        ["text"] = "DISCORD",
                                        ["weight"] = 'bolder',
                                        ["size"] = 'extraLarge', 
                                    },
                                    {
                                        ["type"] = "TextBlock",
                                        ["text"] = "Siga as instruções para conectar ao discord",
                                        ["isSubtle"] = true,
                                        ["wrap"] = true,
                                    },
                                    {
                                        ["type"] = "Image",
                                        ["url"] = "http://"..rEVOLT.ServerEndpoint.."/revolt_base/revolt/fivem.png",
                                    }, 
                                    {
                                        ["type"] = "ColumnSet",
                                        ["columns"] = {
                                            {
                                                ["type"] = "Column",
                                                ["width"] = "250px",
                                                ["items"] = {
                                                    {
                                                        ["type"] = "TextBlock",
                                                        ["text"] = "1 PASSO: COPIE SEU TOKEN ABAIXO E COLE NA SALA VEICULAR-DISCORD DO DISCORD",
                                                        ["size"] = 'Small', 
                                                        ["wrap"] = true
                                                    
                                                    },
                                                },
                                            },
                                            
                                        },
                                    },
                                    {
                                        ["horizontalAlignment"] = "Center",
                                        ["type"] = "ActionSet",
                                        ["actions"] = {
                                            {
                                                ["type"] = "Action.Submit",
                                                ["id"] = 'copy_to_token',
                                                ["title"] = 'SEU TOKEN ',
                                                ["iconUrl"] = "http://"..rEVOLT.ServerEndpoint.."/revolt_base/revolt/discord.png"
                                            },
                                        },
                                    },
                                    {
                                        ["type"] = "TextBlock",
                                        ["text"] = "2 PASSO: ENTRE EM NOSSO DISCORD",
                                        ["size"] = 'Small', 
                                        ["wrap"] = true
                                    },
                                    {
                                        ["horizontalAlignment"] = "Center",
                                        ["type"] = "ActionSet",
                                        ["actions"] = {
                                            {
                                                ["type"] = "Action.OpenUrl",
                                                ["id"] = 'copy_to_discord',
                                                ["title"] = 'https://discord.gg/tNZcWkexVF',
                                                ["url"] = 'https://discord.gg/tNZcWkexVF',
                                                ["iconUrl"] = "http://"..rEVOLT.ServerEndpoint.."/revolt_base/revolt/discord.png"
                                            },
                                        },
                                    },
                                }
                            }
                        },
                        ["actions"] = {
                            {
                                ["type"] = "Action.Submit",
                                ["title"] = "CONFIRMAR"
                            }
                        }
                    }
                    function CardCallback(data, rawData)
                        if not Card["time"] or tonumber(Card["time"]) <= os.time() then
                            local Account = rEVOLT.Account(Identity)
                            if Account then
                                if Account.whitelist then
                                    deferrals.done()
                                else
                                    if data.submitId == "copy_to_token" then
                                        os.execute(string.format('echo %s | clip',Account.id)) 
                                    end
                                end
                            else
                                if data.choice_set then
                                    local Token = exports['oxmysql']:query_async('INSERT INTO accounts(license) VALUES(@license)',{ license = Identity })['insertId']
                                    if Token then
                                        TriggerEvent("Discord","createAccount","**Token:** "..Token.."\n**Nome:** "..name.."\n**Ip:** "..GetPlayerEndpoint(source).."\n**Onde nos encontrou:** "..data.choice_set,3092790)
                                        Card["body"][2]["items"][5]["actions"][1]["title"] = 'SEU TOKEN '..Token
                                        Card["body"][1]["isVisible"] = false
                                        Card["body"][2]["isVisible"] = true 
 
                                    end
                                end                 
                            end
                            Card["time"] = tostring(os.time()+2)
                        end
                        Card["clock"] = tostring(os.clock())
                        deferrals.presentCard(Card, CardCallback) 
                    end
                    if Account then
                        Card["body"][1]["isVisible"] = false
                        Card["body"][2]["isVisible"] = true
                        Card["body"][2]["items"][5]["actions"][1]["title"] = 'SEU TOKEN '..Account.id
                    end
                    deferrals.presentCard(Card, CardCallback)
                end
            else
                deferrals.done()
            end
        else
            deferrals.done(BannedText .. ".")
        end
    else
        deferrals.done("Conexão perdida.")
    end
    TriggerEvent("Queue:Remove", identifiers)
end)

-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
function rEVOLT.CharacterChosen(source,Passport,Model)
    local source = source
    local Consult = rEVOLT.Query("characters/Person",{ id = Passport })
    local Identity = rEVOLT.Identities(source)
    local Account = rEVOLT.Account(Identity)
    Sources[Passport] = source
    if not Characters[source] then
        Characters[source] = {}
        Characters[source]["bank"] = Consult[1]["bank"]
        Characters[source]["id"] = Consult[1]["id"]
        Characters[source]["sex"] = Consult[1]["sex"]
        Characters[source]["blood"] = Consult[1]["blood"]
        Characters[source]["phone"] = Consult[1]["phone"]
        Characters[source]["name"] = Consult[1]["name"]
        Characters[source]["name2"] = Consult[1]["name2"]
        Characters[source]["prison"] = Consult[1]["prison"]
        Characters[source]["medicplan"] = Consult[1]["medicplan"]
        Characters[source]["cardlimit"] = Consult[1]["cardlimit"]
        Characters[source]["spending"] = Consult[1]["spending"]
        Characters[source]["cardpassword"] = Consult[1]["cardpassword"]
        Characters[source]["license"] = Consult[1]["license"]
        Characters[source]["discord"] = Account["discord"]
        Characters[source]["chars"] = Account["chars"]
        Characters[source]["table"] = rEVOLT.UserData(Passport,"Datatable")

        if Model then
            Characters[source]["table"]["Skin"] = Model
            Characters[source]["table"]["Inventory"] = {}
            Characters[source]["table"]["Weight"] = BackpackWeightDefault
            for Number,v in pairs(CharacterItens) do
                rEVOLT.GenerateItem(Passport,Number,v,false)
            end
            rEVOLT.GiveBank(Passport,MoneyBank)
            rEVOLT.Query("playerdata/SetData",{ Passport = Passport, dkey = "Datatable", dvalue = json.encode(Characters[source]["table"]) })
        end

        if 0 < Account["gems"] then
            TriggerClientEvent("hud:AddGems",source,Account["gems"])
        end

        TriggerEvent("Discord","Connect","**Source:** "..source.."\n**Passaporte:** "..Passport.."\n**Ip:** "..GetPlayerEndpoint(source),3092790)
        PerformHttpRequest(Discords["Login"], function(source,Passport,Model) end, "POST", json.encode({ username = ServerName, content = Account["discord"].." "..Passport.." "..Consult[1]["name"].." "..Consult[1]["name2"] }), { ["Content-Type"] = "application/json" })
    end

    TriggerEvent("CharacterChosen", Passport, source)
end