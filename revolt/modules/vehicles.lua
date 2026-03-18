RegisterServerEvent("CleanVehicle")
AddEventHandler("CleanVehicle", function(entIndex)
	local NetworkGetEntityFromNetworkId = NetworkGetEntityFromNetworkId(entIndex)
	if DoesEntityExist(NetworkGetEntityFromNetworkId) and not IsPedAPlayer(NetworkGetEntityFromNetworkId) and 2 == GetEntityType(NetworkGetEntityFromNetworkId) then
		SetVehicleDirtLevel(NetworkGetEntityFromNetworkId, 0)
	end
end)