local main = {
    useKmh = true, -- If you set this to true, the resource will use km/h instead of mph
    detectionRadius = 60, -- This is the furthest distance you can be from a radar to activate it
    blipName = "Radar", -- This shows how many bikes available at each dock
    blip = 184,
    blipShortRange = true,
    blipScale = 0.7,
    blipColour = 0,
    blipDisplay = 9,
}

local mainProp = `prop_led_sign`
local circleProp = `prop_orange_leds`

local Locations = {
    { 
        limit = 120,
        coords = {-596.04,6481.72,14.54,14.18},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {-1945.04,4560.64,57.05,317.49},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {1435.14,715.63,77.9,325.99},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {2257.09,2765.48,44.05,308.98},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {2412.45,-260.78,85.01,331.66},
        width = 0.7
    },
    --[[ { 
        limit = 90,
        coords = {867.81622314453,-832.78131103516,43.282249450684,90.86},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {480.3356628418,-864.31433105469,37.262077331543,265.45},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {319.41986083984,-814.41882324219,29.277896881104,341.47},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {320.61996459961,-716.52734375,29.31042098999,158.21},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-81.182762145996,-915.29260253906,29.341621398926,64.41},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-158.36999511719,-919.14288330078,29.243787765503,240.76},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-78.409156799316,-743.14782714844,33.935371398926,247.35},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-2.9179878234863,-738.35949707031,32.23416519165,70.11},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {75.698928833008,-799.08203125,31.574987411499,243.88},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {147.96415710449,-793.04730224609,31.171054840088,71.77},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {146.30186462402,-845.74713134766,30.911014556885,158.21},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {139.51914978027,-951.27722167969,29.690511703491,338.53},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {141.96131896973,-1028.2622070312,29.350721359253,250.38},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {161.19586181641,-1008.8147583008,29.52507019043,70.69},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {249.41529846191,-1007.6521606445,29.271160125732,340.38},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {251.37547302246,-913.74200439453,29.063556671143,159.56},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {263.40600585938,-835.68988037109,29.432601928711,67.23},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {204.17408752441,-849.33825683594,30.643995285034,246.8},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {77.115631103516,-972.892578125,29.357583999634,70.08},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {1.7189590930939,-972.13330078125,29.596092224121,249.29},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-121.60761260986,-1194.1809082031,27.104818344116,175.84},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-121.60761260986,-1194.1809082031,27.104818344116,175.84},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-89.242874145508,-1250.8377685547,29.224451065063,352.57},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-46.169624328613,-1379.2952880859,29.350046157837,268.1},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {37.293739318848,-1354.6977539062,29.300163269043,90.1},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {103.43514251709,-1431.0723876953,29.292896270752,141.94},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {92.829071044922,-1489.9786376953,29.294422149658,317.43},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {206.55195617676,-1619.9744873047,29.285629272461,209.97},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {332.40853881836,-1706.7180175781,29.325614929199,47.52},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {218.88354492188,-1744.5852050781,29.00830078125,298.16},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {140.41015625,-1797.7784423828,28.350072860718,138.84},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-102.82416534424,-1775.1572265625,29.517436981201,228.55},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-166.64848327637,-1752.3649902344,29.976579666138,139.83},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-221.23745727539,-1825.6240234375,30.002511978149,297.75},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-466.75128173828,-1772.4486083984,20.858991622925,92.71},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-657.50103759766,-1676.6151123047,25.28059387207,219.15},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-678.79223632812,-1579.2236328125,18.401857376099,321.42},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-660.76123046875,-1392.7131347656,10.638459205627,171.41},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {1051.4545898438,-405.94879150391,66.957763671875,130.16},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {900.76104736328,-577.65411376953,57.360877990723,54.24},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {1303.7026367188,-1629.7503662109,52.224590301514,125.07},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {1193.4221191406,-1713.9113769531,35.54224395752,297.89},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {948.10467529297,-1791.5307617188,31.136507034302,173.95},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {946.16088867188,-2033.1687011719,30.140871047974,352.24},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {1055.0656738281,-1872.6278076172,30.527578353882,96.71},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {1105.5740966797,580.72772216797,100.4454574585,347.75},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {481.16094970703,862.74792480469,197.99496459961,255.41},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-12.962394714355,1056.4543457031,219.4083404541,81.9},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {-583.85406494141,967.13433837891,241.9677734375,231.4},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-412.79434204102,6050.2172851562,31.590328216553,34.38},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-330.98568725586,6215.4106445312,31.337661743164,133.14},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-393.00296020508,6297.4995117188,29.474477767944,119.01},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-147.30581665039,6377.2924804688,31.527755737305,311.27},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-7.0239720344543,6537.931640625,31.455959320068,134.91},
        width = 0.7
    },
    { 
        limit = 60,
        coords = {-154.75106811523,6452.603515625,31.376420974731,220.97},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {-815.67370605469,1817.9106445312,166.62837219238,131.65},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {138.92471313477,1613.8673095703,229.15576171875,180.96},
        width = 0.7
    },
    { 
        limit = 120,
        coords = {135.13459777832,1669.8150634766,228.55128479004,42.46},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {328.83099365234,1020.1640014648,210.52578735352,358.62},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {241.10844421387,1279.9792480469,234.41209411621,182.48},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {483.49383544922,48.593879699707,93.484931945801,154.29},
        width = 0.7
    },
    { 
        limit = 90,
        coords = {434.95065307617,-98.92497253418,68.264335632324,322.58},
        width = 0.7
    },    ]] 
}

local networkWarnings = false
local Nearest = {}
CreateThread(function()
    RequestModel(mainProp)
    while not HasModelLoaded(mainProp) do Wait(0) end
    for Index,Value in pairs(Locations) do 
        Locations[Index].prop = CreateObject(mainProp, Value.coords[1], Value.coords[2], Value.coords[3]-1.0, false, false, true)
        while not DoesEntityExist(Locations[Index].prop) do Wait(0) end
        PlaceObjectOnGroundProperly(Locations[Index].prop)
        local coords = GetEntityCoords(Locations[Index].prop)
        SetEntityCoords(Locations[Index].prop, coords.x, coords.y, coords.z - 0.4, true, true, true, false)
        FreezeEntityPosition(Locations[Index].prop, true)
        SetEntityHeading(Locations[Index].prop, Value.coords[4])
        RequestModel(circleProp)
        while not HasModelLoaded(circleProp) do Wait(0) end
        Locations[Index].orange1 = CreateObject(circleProp, Locations[Index].coords.x, Locations[Index].coords.y, Locations[Index].coords.z, networkWarnings, true, true)
        while not DoesEntityExist(Locations[Index].orange1) do Wait(0) end
        Locations[Index].orange2 = CreateObject(circleProp, Locations[Index].coords.x, Locations[Index].coords.y, Locations[Index].coords.z, networkWarnings, true, true)
        while not DoesEntityExist(Locations[Index].orange2) do Wait(0) end
        AttachEntityToEntity(Locations[Index].orange1, Locations[Index].prop, -1, 0.0, -0.006, 0.0, 0.0, 0.0, 0.0, true, false, true, false, 1, true) -- set up orange 1
        AttachEntityToEntity(Locations[Index].orange2, Locations[Index].prop, -1, 0.0, -0.006, -0.72, 0.0, 0.0, 0.0, true, false, true, false, 1, true) -- set up orange 2
        SetModelAsNoLongerNeeded(circleProp)
    end
    SetModelAsNoLongerNeeded(mainProp)
	while true do
        local Ped = PlayerPedId()
        local Vehicle = GetVehiclePedIsIn(Ped)
        local Coords = GetEntityCoords(Vehicle)
        if not LocalPlayer["state"]["Police"] and Ped == GetPedInVehicleSeat(Vehicle,-1) then
            for Index,Value in pairs(Locations) do 
                local Distance = #(Coords - vec3((Value.coords[1] - math.cos(math.rad(Value.coords[4])) * Value.width),(Value.coords[2] - math.sin(math.rad(Value.coords[4])) * Value.width),Value.coords[3]))
                if Distance < 100 then
                    if Nearest[Index] == nil then
                        if Distance < 75 and Distance > 10 then
                            Nearest[Index] = Value
                        end
                        if DoesBlipExist(Locations[Index].blip) == false then
                            Locations[Index].blip = AddBlipForEntity(Locations[Index].prop)
                            SetBlipSprite(Locations[Index].blip, main.blip)
                            SetBlipDisplay(main.blip, main.blipDisplay)
                            SetBlipScale(Locations[Index].blip, main.blipScale)
                            SetBlipColour(Locations[Index].blip, main.blipColour)
                            SetBlipAsShortRange(Locations[Index].blip, main.blipShortRange)
                            BeginTextCommandSetBlipName("STRING")
                            AddTextComponentString(main.blipName)
                            EndTextCommandSetBlipName(Locations[Index].blip)
                        end 
                    end
                else
                    if Nearest[Index] ~= nil then
                        Nearest[Index] = nil
                        if DoesBlipExist(Locations[Index].blip) ~= false then
                            RemoveBlip(Locations[Index].blip)
                        end
                    end
                end
            end
        else
            Nearest = {}
        end
		Wait(500)
	end
end)

Citizen.CreateThread(function()
    while true do
		local TimeDistance = 999
        if length(Nearest) > 0 then
            local Ped = PlayerPedId()
            local Vehicle = GetVehiclePedIsIn(Ped)
            local Coords = GetEntityCoords(Vehicle)
            local Heading = GetEntityHeading(Vehicle)
            for Index,Value in pairs(Nearest) do 
                if Nearest[Index] then
                    if Heading >= Value.coords[4]-90 and Heading <= Value.coords[4]+90 then
                        local Speed = math.ceil(GetEntitySpeed(Vehicle) * 2.236936)
                        if #(Coords - vec3((Value.coords[1] - math.cos(math.rad(Value.coords[4])) * Value.width),(Value.coords[2] - math.sin(math.rad(Value.coords[4])) * Value.width),Value.coords[3])) < 10 then
                            local Players = {}
                            for _,Entity in pairs(GetGamePool("CPed")) do
                                local Index = NetworkGetPlayerIndexFromPed(Entity)
                                if Index and IsPedAPlayer(Entity) and NetworkIsPlayerConnected(Index) then
                                    if #(GetEntityCoords(Entity) - vec3(Value.coords[1],Value.coords[2],Value.coords[3])) < 30 then
                                        Players[Entity] = GetPlayerServerId(Index)
                                    end
                                end
                            end
                            TriggerServerEvent("speedcam:Syncleds",Value,Speed,Players)
                            Nearest[Index] = nil
                            break
                        else
                            local numbers = {tostring(Value.limit):match((tostring(Value.limit):gsub('.', '(%1)')))}
                            if numbers[3] then
                                local x = Value.coords[1] - math.cos(math.rad(Value.coords[4])) * 0.4
                                local y = Value.coords[2] - math.sin(math.rad(Value.coords[4])) * 0.4
                                DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+2,0,0,0, 0.0,0.0,Value.coords[4], 0.5, 0.5, 0.5, 255, 234, 0, 255,1,0,0,0)
                                DrawMarker(tonumber("1"..numbers[2]),Value.coords[1],Value.coords[2],Value.coords[3]+2,0,0,0, 0.0,0.0,Value.coords[4], 0.5, 0.5, 0.5, 255, 234, 0, 255,1,0,0,0)
                                local x = Value.coords[1] + math.cos(math.rad(Value.coords[4])) * 0.4
                                local y = Value.coords[2] + math.sin(math.rad(Value.coords[4])) * 0.4
                                DrawMarker(tonumber("1"..numbers[3]),x,y,Value.coords[3]+2,0,0,0, 0.0,0.0,Value.coords[4], 0.5, 0.5, 0.5, 255, 234, 0, 255,1,0,0,0)
                            else
                                local x = Value.coords[1] - math.cos(math.rad(Value.coords[4])) * 0.2
                                local y = Value.coords[2] - math.sin(math.rad(Value.coords[4])) * 0.2
                                DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+2,0,0,0, 0.0,0.0,Value.coords[4], 0.5, 0.5, 0.5, 255, 234, 0, 255,1,0,0,0)
                                local x = Value.coords[1] + math.cos(math.rad(Value.coords[4])) * 0.2
                                local y = Value.coords[2] + math.sin(math.rad(Value.coords[4])) * 0.2
                                DrawMarker(tonumber("1"..numbers[2]),x,y,Value.coords[3]+2,0,0,0, 0.0,0.0,Value.coords[4], 0.5, 0.5, 0.5, 255, 234, 0, 255,1,0,0,0)
                            end
                        end
                    end
                end
                TimeDistance = 0
            end
        end
		Citizen.Wait(TimeDistance)
	end
end)

function length(array)
	local len = 0
    if array ~= nil then
        for key,value in pairs(array) do 
            if array[key] then
                len = len+1
            end
	    end
    end
	return len
end

function DrawText3D(X,Y,Z,Text)
	local onScreen,x,y = World3dToScreen2d(X,Y,Z+0.7)
	if onScreen then
		SetTextFont(4)
		SetTextCentre(true)
		SetTextProportional(1)
		SetTextScale(0.35,0.35)
        SetTextColour(255, 234, 0,255)
		SetTextEntry("STRING")
		AddTextComponentString(Text)
		EndTextCommandDisplayText(x,y)
	end
end

RegisterNetEvent("speedcam:Syncleds")
AddEventHandler("speedcam:Syncleds",function(Value,Speed)
    local endTime = GetGameTimer() + 3000
    while GetGameTimer() < endTime do
        local numbers = {tostring(Speed):match((tostring(Speed):gsub('.', '(%1)')))}
        if numbers[3] then
            local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.135
            local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.135
            DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.17, 0.17, 0.17, 255, 234, 0, 255,0,0,0,0)
            local x = Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1
            local y = Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1
            DrawMarker(tonumber("1"..numbers[2]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.17, 0.17, 0.17, 255, 234, 0, 255,0,0,0,0)
            local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.135
            local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.135
            DrawMarker(tonumber("1"..numbers[3]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.17, 0.17, 0.17, 255, 234, 0, 255,0,0,0,0)
        else
            if numbers[2] then
                local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.08
                local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.08
                DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0)
                local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.08
                local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.08
                DrawMarker(tonumber("1"..numbers[2]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0)
            else
                local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.08
                local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.08
                DrawMarker(tonumber("1"..0),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0)
                local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.08
                local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.08
                DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0)
            end
        end
        local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.11
        local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.11
        DrawMarker(28,x,y,Value.coords[3]+0.45,0,0,0, 0.0,0.0,Value.coords[4], 0.035, 0.035, 0.035, 255, 234, 0, 255,0,0,0,0)
        local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.11
        local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.11
        DrawMarker(28,x,y,Value.coords[3]+0.45,0,0,0, 0.0,0.0,Value.coords[4], 0.035, 0.035, 0.035, 255, 234, 0, 255,0,0,0,0)
        local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.11
        local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.11
        DrawMarker(28,x,y,Value.coords[3]+1.17,0,0,0, 0.0,0.0,Value.coords[4], 0.035, 0.035, 0.035, 255, 234, 0, 255,0,0,0,0)
        local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.11
        local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.11
        DrawMarker(28,x,y,Value.coords[3]+1.17,0,0,0, 0.0,0.0,Value.coords[4], 0.035, 0.035, 0.035, 255, 234, 0, 255,0,0,0,0)
        Wait(5)
    end
end)

--[[  local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) - math.cos(math.rad(Value.coords[4])) * 0.08
                            local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) - math.sin(math.rad(Value.coords[4])) * 0.08
                            DrawMarker(tonumber("1"..numbers[1]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0)
                            local x = (Value.coords[1] + math.sin(math.rad(Value.coords[4])) * 0.1) + math.cos(math.rad(Value.coords[4])) * 0.08
                            local y = (Value.coords[2] - math.cos(math.rad(Value.coords[4])) * 0.1) + math.sin(math.rad(Value.coords[4])) * 0.08
                            DrawMarker(tonumber("1"..numbers[2]),x,y,Value.coords[3]+0.75,0,0,0, 0.0,0.0,Value.coords[4], 0.2, 0.2, 0.2, 255, 234, 0, 255,0,0,0,0) ]]