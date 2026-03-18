-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("driverlicense",Creative)
vCLIENT = Tunnel.getInterface("driverlicense")
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.UserData()
    local Data = {}
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Driverlicense = rEVOLT.UserData(Passport,"Driverlicense")
        if json.encode(Driverlicense) ~= "[]" then
            Data["Driverlicense"] = {
                ["categories"] = Driverlicense["categories"],
                ["expiration"] = Driverlicense["expiration"] <= os.time()
            }
        end
        local Inventory = rEVOLT.Inventory(Passport)
        for k,v in pairs(Inventory) do
            local Split = splitString(v.item, "-")
            if Split[1] == "dmvdocs" and Split[2] == tostring(Passport) then
                Data["Documents"] = json.decode(Split[3])
                Data["Theoretical"] = json.decode(Split[4])
                Data["Practice"] = json.decode(Split[5])
            end
        end
        return Data["Driverlicense"],Data["Documents"],Data["Theoretical"],Data["Practice"]
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SetPassedPractice(Index)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Category = Categories[tonumber(Index)]["category"]
        local Inventory = rEVOLT.Inventory(Passport)
        for Slot,v in pairs(Inventory) do
            local Split = splitString(v.item, "-")
            if Split[1] == "dmvdocs" and Split[2] == tostring(Passport) then
                rEVOLT.RemoveItem(Passport, v.item, 1)
            end
        end

        local Identity = rEVOLT.Identities(Passport) 
        local Driverlicense = rEVOLT.UserData(Passport,"Driverlicense")
        if json.encode(Driverlicense) ~= "[]" then
            Driverlicense["categories"][Index] = Category
        else
            Driverlicense = {
                ["name"] = Identity.name .. " ".. Identity.name2,
                ["categories"] = { [Index] = Category },
                ["expiration"] = os.time() + 2628000,
                ["issued"] = os.time()
            }
        end

        rEVOLT.GiveItem(Passport,"driverlicense-" .. Passport .. "-" .. json.encode(Driverlicense),1,true)

        exports["oxmysql"]:executeSync([[
            INSERT INTO playerdata(Passport,dkey,dvalue) 
            VALUES (:Passport,:dkey,:dvalue) ON DUPLICATE KEY 
            UPDATE Passport = :Passport, dkey = :dkey,  dvalue = :dvalue
        ]],{
            Passport = Passport,
            dkey = 'Driverlicense',
            dvalue = json.encode(Driverlicense),
        })
        
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.SetPassedTheory(Index)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Inventory = rEVOLT.Inventory(Passport)
        for Slot,v in pairs(Inventory) do
            local Split = splitString(v.item, "-")
            if Split[1] == "dmvdocs" and Split[2] == tostring(Passport) then
                if rEVOLT.TakeItem(Passport, v.item, 1, false, Slot) then
                    local Theoretical = json.decode(Split[4]) Theoretical[Index] = Categories[tonumber(Index)]["category"]
                    rEVOLT.GiveItem(Passport,"dmvdocs-" .. Passport .. "-" .. Split[3] .. "-" .. json.encode(Theoretical) .. "-" .. Split[5],1)
                end
            end
        end
    end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:documents")
AddEventHandler("driverlicense:documents",function(Index)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        if vCLIENT.IsNotVehicleNearPoint(source,Index) then
            local Price = Categories[tonumber(Index)]["price"]
            local Category = Categories[tonumber(Index)]["category"]
            if rEVOLT.PaymentFull(Passport,Price,"Driverlicense") then
                TriggerClientEvent("sounds:Private",source,"cash",0.1)
                TriggerClientEvent("dynamic:closeSystem",source)
                TriggerClientEvent('Notify',source,"verde","Você pagou <b>$"..parseFormat(Price).."</b> para receber os documentos.",8000,"Auto Escola")
                local Inventory = rEVOLT.Inventory(Passport)
                for Slot,v in pairs(Inventory) do
                    local Split = splitString(v.item, "-")
                    if Split[1] == "dmvdocs" and Split[2] == tostring(Passport) then
                        if rEVOLT.TakeItem(Passport, v.item, 1, false, Slot) then
                            local Documents = json.decode(Split[3]) Documents[Index] = Category
                            rEVOLT.GiveItem(Passport,"dmvdocs-" .. Passport .. "-" .. json.encode(Documents).. "-" .. Split[4] .. "-" .. Split[5],1) return
                        end
                    end
                end
                rEVOLT.GiveItem(Passport,"dmvdocs-" .. Passport .. "-" .. json.encode({ [Index] = Category }).. "-" .. json.encode({}) .. "-" .. json.encode({}),1,true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:issue")
AddEventHandler("driverlicense:issue",function(Price)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Driverlicense = rEVOLT.UserData(Passport,"Driverlicense")
        if json.encode(Driverlicense) ~= "[]" then
            if rEVOLT.PaymentFull(Passport,Price,"Driverlicense") then
                TriggerClientEvent("dynamic:closeSystem",source)
                TriggerClientEvent("sounds:Private",source,"cash",0.1)
                rEVOLT.GiveItem(Passport,"driverlicense-" .. Passport .. "-" .. json.encode(Driverlicense),1,true)
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:renew")
AddEventHandler("driverlicense:renew",function(Price)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        if rEVOLT.PaymentFull(Passport,Price,"Driverlicense") then
            TriggerClientEvent("sounds:Private",source,"cash",0.1)
            TriggerClientEvent("dynamic:closeSystem",source)
            local Driverlicense = rEVOLT.UserData(Passport,"Driverlicense")
            Driverlicense["expiration"] = os.time() + 2628000
            exports["oxmysql"]:executeSync([[
                INSERT INTO playerdata(Passport,dkey,dvalue) 
                VALUES (:Passport,:dkey,:dvalue) ON DUPLICATE KEY 
                UPDATE Passport = :Passport, dkey = :dkey,  dvalue = :dvalue
            ]],{
                Passport = Passport,
                dkey = 'Driverlicense',
                dvalue = json.encode(Driverlicense),
            })
            TriggerClientEvent('Notify',source,"verde","Você pagou <b>$"..parseFormat(Price).."</b> para renovar a habilitação.",8000,"Auto Escola")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:practice")
AddEventHandler("driverlicense:practice",function(Index)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        if vCLIENT.IsNotVehicleNearPoint(source,Index) then
            local Category = Categories[tonumber(Index)]["category"]
            local Price = Categories[tonumber(Index)]["taxs"]["practice"]
            if rEVOLT.PaymentFull(Passport,Price,"Driverlicense") then
                TriggerClientEvent("driverlicense:practice",source,Index)
                TriggerClientEvent("sounds:Private",source,"cash",0.1)
                TriggerClientEvent("dynamic:closeSystem",source)
                TriggerClientEvent('Notify',source,"verde","Você pagou <b>$"..parseFormat(Price).."</b> para realizar a prática.",8000,"Auto Escola")
            end
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("driverlicense:theoretical")
AddEventHandler("driverlicense:theoretical",function(Index)
    local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
        local Category = Categories[tonumber(Index)]["category"]
        local Price = Categories[tonumber(Index)]["taxs"]["theoretical"]
        if rEVOLT.PaymentFull(Passport,Price,"Driverlicense") then
            TriggerClientEvent("driverlicense:theoretical",source,Index)
            TriggerClientEvent("sounds:Private",source,"cash",0.1)
            TriggerClientEvent("dynamic:closeSystem",source)
            TriggerClientEvent('Notify',source,"verde","Você pagou <b>$"..parseFormat(Price).."</b> para realizar o teórico.",8000,"Auto Escola")
        end
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PED
-----------------------------------------------------------------------------------------------------------------------------------------
local Entity = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CREATEPED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.CreatePed(Model,x,y,z,Network)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Entity[Passport] then
			DeleteEntity(Entity[Passport])
		end
		Entity[Passport] = CreatePed(4,GetHashKey(Model),x,y,z,3374176)
        SetPedIntoVehicle(Entity[Passport],NetworkGetEntityFromNetworkId(Network),0) 
        while Entity[Passport] ~= GetPedInVehicleSeat(NetworkGetEntityFromNetworkId(Network),0) do
            SetPedIntoVehicle(Entity[Passport],NetworkGetEntityFromNetworkId(Network),0) 
            Wait(0)
        end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETEPED
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.DeletePed()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Entity[Passport] then
			DeleteEntity(Entity[Passport])
			Entity[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect", function(Passport)
	if Entity[Passport] then
		DeleteEntity(Entity[Passport])
		Entity[Passport] = nil
	end
end)