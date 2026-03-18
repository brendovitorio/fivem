local frameworkFunctions = {}
local resourceName = GetCurrentResourceName()

local currentFramework = 'none'

RegisterNetEvent(resourceName .. ':frameworkDetected', function(framework)
    currentFramework = framework

    print('SETANDO FRAMEWORK -> ' .. framework)
end)

exports('getFramework', function()
    TriggerServerEvent(resourceName .. ':getFramework')

    while currentFramework == 'none' do
        Wait(100)
    end


    local isServer = IsDuplicityVersion()
    
    local frameworkArchive = isServer and 'server' or 'client'

    frameworkFunctions = module(resourceName, 'framework/'..frameworkArchive..'/'..currentFramework)

    local modularsFunctions = exports[resourceName]:getAllModularsFunctionsForFramework(currentFramework)

    if modularsFunctions then
        for name, handler in pairs(modularsFunctions) do
            if frameworkFunctions[name] then
                frameworkFunctions[name] = handler()
            end
        end
    end

    return frameworkFunctions, currentFramework
end)