local nyo = GetResourceState('nyo_modules') == 'started' and exports['nyo_modules'] or {}
local resourceName = GetCurrentResourceName()


local framework = {}

function framework.playTabletAnim()
    ExecuteCommand('e tablet')
end

function framework.endTabletAnim()
    nyo.deleteObject()
end

return framework