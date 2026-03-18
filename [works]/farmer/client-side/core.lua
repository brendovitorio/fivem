-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Objects = {}
local Displayed = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- INPUTTARGETPOSITION
-----------------------------------------------------------------------------------------------------------------------------------------
function InputTargetPosition(Number,v)
	exports["target"]:AddCircleZone("Farmer:"..Number,v["Coords"],v["Width"],{
		name = "Farmer:"..Number,
		heading = v["Heading"]
	},{
		shop = Number,
		Distance = v["Distance"],
		options = {
			{
				event = v["Event"],
				label = v["Label"],
				tunnel = "server"
			}
		}
	})
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADOBJECTS
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	while true do
		local Ped = PlayerPedId()
		local Coords = GetEntityCoords(Ped)
		for Number,v in pairs(Objects) do
			local Distance = #(Coords - v["Coords"])
			if Distance <= v["Show"] and GlobalState["Work"] >= v["Time"] then
				if not Displayed[Number] then
					if LoadModel(v["Model"]) then
						Displayed[Number] = CreateObjectNoOffset(v["Model"],v["Coords"]["x"],v["Coords"]["y"],v["Coords"]["z"] - v["Height"],false,false,false)
						SetEntityHeading(Displayed[Number],v["Heading"])
						FreezeEntityPosition(Displayed[Number],true)
						SetModelAsNoLongerNeeded(v["Model"])
						InputTargetPosition(Number,v)
					end
				end
			else
				if Displayed[Number] then
					exports["target"]:RemCircleZone("Farmer:"..Number)
					if DoesEntityExist(Displayed[Number]) then
						DeleteEntity(Displayed[Number])
						Displayed[Number] = nil
					end
				end
			end
		end
		Wait(1000)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:REMOVER
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Remover")
AddEventHandler("farmer:Remover",function(Number,Timers)
	if Objects[Number] then
		Objects[Number]["Time"] = Timers
		if Displayed[Number] then
			exports["target"]:RemCircleZone("Farmer:"..Number)
			if DoesEntityExist(Displayed[Number]) then
				DeleteEntity(Displayed[Number])
				Displayed[Number] = nil
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- FARMER:TABLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNetEvent("farmer:Table")
AddEventHandler("farmer:Table",function(Table)
	Objects = Table
end)