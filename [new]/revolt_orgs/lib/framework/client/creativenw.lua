local Proxy = module('vrp', 'lib/Proxy')
local vRP = Proxy.getInterface('vRP')
local resourceName = GetCurrentResourceName()


local framework = {}

function framework.playTabletAnim()
    ExecuteCommand('e tablet')
end

function framework.endTabletAnim()
    vRP.Destroy()
end

return framework