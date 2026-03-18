-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("trunkchest",Creative)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Vehicle = {}

local webhookMalas = "https://discord.com/api/"
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.openChest()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Vehicle[Passport] then
		local myInfos = {}
		local Inventory = rEVOLT.Inventory(Passport)
		for k,v in pairs(Inventory) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			myInfos[k] = v
		end

		local vehInfos = {}
		local Result = rEVOLT.GetSrvData(Vehicle[Passport]["Data"],true)
		for k,v in pairs(Result) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local splitName = splitString(v["item"],"-")
			if splitName[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - splitName[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			vehInfos[k] = v
		end

		return myInfos,vehInfos,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Result),Vehicle[Passport]["Weight"]
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREVEHS
-----------------------------------------------------------------------------------------------------------------------------------------
local storeVehs = {
	["ratloader"] = {
		["woodlog"] = true
	},
	["stockade"] = {
		["pouch"] = true
	},
	["trash"] = {
		["reciclavel"] = true,
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateChest(Slot,Target,Amount)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end

		if rEVOLT.UpdateChest(Passport,Vehicle[Passport]["Data"],Slot,Target,Amount,true) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeItem(Item,Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end
		local vehName = Vehicle[Passport]["Model"]

		if (storeVehs[vehName] and not storeVehs[vehName][Item]) or Item == "dollars" or Item == "dollarz" or Item == "dollarx" or itemBlock(Item) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
			TriggerClientEvent("Notify",source,"amarelo","Você não pode guardar isso aqui.",5000)
			goto scapeInventory
		end

		if rEVOLT.StoreChest(Passport,Vehicle[Passport]["Data"],Amount,Vehicle[Passport]["Weight"],Slot,Target,true) then
			
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		else
			if Vehicle[Passport] then
				local Result = rEVOLT.GetSrvData(Vehicle[Passport]["Data"],true)
				rEVOLT.SendWebhook(webhookMalas, "LOGs Guardou Malas", "**Passaporte: **"..Passport.."\n**Guardou: **x"..Amount.." "..itemName(Item).."\n**Veículo: **"..Vehicle[Passport]["Model"].."\n**Placa: **"..Vehicle[Passport]["Plate"], 16729391)
				TriggerClientEvent("trunkchest:UpdateWeight",source,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Result),Vehicle[Passport]["Weight"])
			end
		end
	end

	::scapeInventory::
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.takeItem(Item, Slot,Amount,Target)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport and Vehicle[Passport] then
		if Amount <= 0 then Amount = 1 end

		if rEVOLT.TakeChest(Passport,Vehicle[Passport]["Data"],Amount,Slot,Target,true) then
			TriggerClientEvent("trunkchest:Update",source,"requestChest")
		else
			if Vehicle[Passport] then
				local Result = rEVOLT.GetSrvData(Vehicle[Passport]["Data"],true)
				rEVOLT.SendWebhook(webhookMalas, "LOGs Pegou Malas", "**Passaporte: **"..Passport.."\n**Pegou: **x"..Amount.." "..itemName(Item).."\n**Veículo: **"..Vehicle[Passport]["Model"].."\n**Placa: **"..Vehicle[Passport]["Plate"], 3898671)
				TriggerClientEvent("trunkchest:UpdateWeight",source,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Result),Vehicle[Passport]["Weight"])
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHESTCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.chestClose()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and Vehicle[Passport] then
		TriggerClientEvent("player:syncDoorsOptions",source,Vehicle[Passport]["Net"],"close")
		Vehicle[Passport] = nil
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TRUNKCHEST:OPENTRUNK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("trunkchest:openTrunk")
AddEventHandler("trunkchest:openTrunk",function(Entity)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if VehicleChest(Entity[2]) > 0 then
			local PassportPlate = rEVOLT.PassportPlate(Entity[1])

			if PassportPlate then
				Vehicle[Passport] = {
					["Net"] = Entity[4],
					["Plate"] = Entity[1],
					["Model"] = Entity[2],
					["User"] = PassportPlate["Passport"],
					["Weight"] = VehicleChest(Entity[2]),
					["Data"] = "Chest:"..PassportPlate["Passport"]..":"..Entity[2]
				}

				local Network = NetworkGetEntityFromNetworkId(Vehicle[Passport]["Net"])

				if GetVehicleDoorLockStatus(Network) <= 1 then
					TriggerClientEvent("trunkchest:Open",source)
					TriggerClientEvent("player:syncDoorsOptions",source,Vehicle[Passport]["Net"],"open")
				else
					TriggerClientEvent("Notify",source,"amarelo","Veículo trancado.",5000)
					Vehicle[Passport] = nil
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Vehicle[Passport] then
		Vehicle[Passport] = nil
	end
end)