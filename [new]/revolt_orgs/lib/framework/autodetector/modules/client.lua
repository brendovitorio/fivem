local functions = {}
local resourceName = GetCurrentResourceName()

local Tunnel = module('vrp','lib/Tunnel')
local Proxy = module('vrp','lib/Proxy')
local vRP = Proxy.getInterface('vRP',  resourceName .. '_auto_detector')

local function getAllModularsFunctionsForFramework(framework)
    local modularsFunctions = functions[framework]

    return modularsFunctions
end

exports('getAllModularsFunctionsForFramework', getAllModularsFunctionsForFramework)

local function registerFrameworkFunction(framework, name, handler)
    if not functions[framework] then
        functions[framework] = {}
    end

    functions[framework][name] = handler
end

function awaitHandler(handler)
    local result = promise.new()

    handler(result)

    return Citizen.Await(result)
end

local mengazo = exports[resourceName]


--[[ registerFrameworkFunction('vrpex', 'getPlayerVehicles', function()
    
end) ]]

--[[ registerFrameworkFunction('creativenw', 'getPlayerVehicles', function()
    
end) ]]

--[[ registerFrameworkFunction('creativev5', 'getPlayerVehicles', function()
    
end) ]]