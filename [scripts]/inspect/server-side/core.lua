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
Tunnel.bindInterface("inspect",Creative)
vCLIENT = Tunnel.getInterface("inspect")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local openPlayer = {}
local openSource = {}
local webhookrevistar1 = "https://discord.com/api/webhooks/1156471623176704040/eroVX4QT0YuS86bFbcrEsAxoXmdWnw4V0N0-WRQjPgc5yTdrGbQZYYpz2IhJqfcUbBJv"
local webhookrevistar2 = "https://discord.com/api/webhooks/1156471779041234994/8-KRK0cV0vmggk-HB7AIOw6IOx16D6h2XIQ6DEnZUPQMBR0K25F15872Ef9b4dCJt9SK"
-----------------------------------------------------------------------------------------------------------------------------------------
-- POLICE:RUNINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("police:runInspect")
AddEventHandler("police:runInspect",function(Entity)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and rEVOLT.GetHealth(source) > 100 then
		openSource[Passport] = Entity[1]
		openPlayer[Passport] = rEVOLT.Passport(Entity[1])

		TriggerClientEvent("player:playerCarry",Entity[1],source,"handcuff")
		TriggerClientEvent("player:Commands",Entity[1],true)
		TriggerClientEvent("inventory:Close",Entity[1])
		TriggerClientEvent("inspect:Open",source)

		rEVOLT.SendWebhook(webhookrevistar1, "LOGs Revistar", "**Passaporte: **"..Passport.."\n**Revistou: **"..openPlayer[Passport], 10357504)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.openChest()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local myInventory = {}
		local inventory = rEVOLT.Inventory(Passport)
		for k,v in pairs(inventory) do
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

			myInventory[k] = v
		end

		local otherInventory = {}
		local inventory = rEVOLT.Inventory(openPlayer[Passport])
		for k,v in pairs(inventory) do
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

			otherInventory[k] = v
		end

		return myInventory,otherInventory,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.InventoryWeight(openPlayer[Passport]),rEVOLT.GetWeight(openPlayer[Passport])
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- RESETINSPECT
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.resetInspect()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if openSource[Passport] then
			TriggerClientEvent("player:Commands",openSource[Passport],false)
			TriggerClientEvent("player:playerCarry",openSource[Passport],source)
			openSource[Passport] = nil
		end

		if openPlayer[Passport] then
			openPlayer[Passport] = nil
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STOREITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.storeItem(Item,Slot,Amount,Target)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if rEVOLT.MaxItens(openPlayer[Passport],Item,Amount) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (rEVOLT.InventoryWeight(openPlayer[Passport]) + (itemWeight(Item) * Amount)) <= rEVOLT.GetWeight(openPlayer[Passport]) then
					if rEVOLT.TakeItem(Passport,Item,Amount,false,Slot) then
						rEVOLT.GiveItem(openPlayer[Passport],Item,Amount,true,Target)
					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKEITEM
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.takeItem(Item,Slot,Target,Amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if openSource[Passport] then
			if DoesEntityExist(GetPlayerPed(openSource[Passport])) then
				if rEVOLT.MaxItens(Passport,Item,Amount) then
					TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",3000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
					return
				end

				if (rEVOLT.InventoryWeight(Passport) + (itemWeight(Item) * Amount)) <= rEVOLT.GetWeight(Passport) then
					if rEVOLT.TakeItem(openPlayer[Passport],Item,Amount,true,Slot) then
						rEVOLT.GiveItem(Passport,Item,Amount,false,Target)
						TriggerClientEvent("inspect:Update",source,"requestChest")
						rEVOLT.SendWebhook(webhookrevistar2, "LOGs Revistar", "**Passaporte: **"..Passport.."\n**Revistou: **"..openPlayer[Passport]..Passport.."\n**Item: **x"..Amount.." "..Item, 10357504)

					end
				else
					TriggerClientEvent("Notify",source,"vermelho","Mochila cheia.",5000)
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATECHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.updateChest(Slot,Target,Amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if openSource[Passport] then
			local Ped = GetPlayerPed(openSource[Passport])
			if DoesEntityExist(Ped) then
				if rEVOLT.invUpdate(openPlayer[Passport],Slot,Target,Amount) then
					TriggerClientEvent("inspect:Update",source,"requestChest")
				end
			end
		end
	end
end