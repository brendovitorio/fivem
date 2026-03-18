-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TACKLE:UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("tackle:Update")
AddEventHandler("tackle:Update",function(source,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	if rEVOLT.Passport(source) then
		TriggerClientEvent("tackle:Player",source,ForwardVectorX,ForwardVectorY,ForwardVectorZ,Tackler)
	end
end)