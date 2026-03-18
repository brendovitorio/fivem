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
Tunnel.bindInterface("propertys",Creative)
vKEYBOARD = Tunnel.getInterface("keyboard")
vSKINSHOP = Tunnel.getInterface("skinshop")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local Lock = {}
local Inside = {}
local Markers = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Propertys(Name,LimitProperty)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport or rEVOLT.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) or Lock[Name] then
				if os.time() > Consult[1]["Tax"] then
					if rEVOLT.Request(source,"Hipoteca atrasada, deseja efetuar o pagamento?","Sim, concluir pagamento","Não, pago depois") then
						if rEVOLT.PaymentFull(Passport,Informations[Consult[1]["Interior"]]["Price"] * 0.1) then
							rEVOLT.Query("propertys/Tax",{ name = Name })
							TriggerClientEvent("Notify",source,"amarelo","Pagamento concluído.",5000)
						end
					end
				else
					Consult[1]["Tax"] = MinimalTimers(Consult[1]["Tax"] - os.time())
					return "Player",Consult[1]
				end
			end
		else
			if LimitProperty then
				local TempInformations = {}
				for Index,Data in pairs(Informations) do
					if not Data["LimitProperty"] then
						TempInformations[Index] = Data
					end
				end
				return "Corretor",TempInformations
			else
				return "Corretor",Informations
			end
		end
	end

	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:TOGGLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Toggle")
AddEventHandler("propertys:Toggle",function(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Inside[Passport] then
			Inside[Passport] = nil
			TriggerEvent("Revolt:BucketServer",source,"Exit")
		else
			Inside[Passport] = Name
			TriggerEvent("Revolt:BucketServer",source,"Enter",Route(Name))
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:BUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Buy")
AddEventHandler("propertys:Buy",function(Name)
	local source = source
	local Split = splitString(Name,"-")
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Name = Split[1]
		local Interior = Split[2]
		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if not Consult[1] then
			TriggerClientEvent("dynamic:closeSystem",source)

			if rEVOLT.Request(source,"Deseja comprar a propriedade?","Sim, assinar papelada","Não, mudeia de ideia") then
				if rEVOLT.PaymentFull(Passport,Informations[Interior]["Price"]) then
					Markers[Name] = true
					local Serial = PropertysSerials()
					rEVOLT.GiveItem(Passport,"propertys-"..Serial,3,true)
					TriggerClientEvent("propertys:Markers",-1,Markers)
					rEVOLT.Query("propertys/Buy",{ name = Name, interior = Interior, passport = Passport, serial = Serial, vault = Informations[Interior]["Vault"], fridge = Informations[Interior]["Fridge"], tax = os.time() + 2592000 })
				else
					TriggerClientEvent("Notify",source,"vermelho","<b>Dólares</b> insuficientes.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Lock")
AddEventHandler("propertys:Lock",function(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport or rEVOLT.InventoryFull(Passport,"propertys-"..Consult[1]["Serial"]) then
				if Lock[Name] then
					Lock[Name] = nil
					TriggerClientEvent("Notify",source,"amarelo","Propriedade trancada.",5000)
				else
					Lock[Name] = true
					TriggerClientEvent("Notify",source,"amarelo","Propriedade destrancada.",5000)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Sell")
AddEventHandler("propertys:Sell",function(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport then
				TriggerClientEvent("dynamic:closeSystem",source)

				if rEVOLT.Request(source,"Deseja vender a propriedade?","Sim, concluir a venda","Não, mudeia de ideia") then
					if Markers[Name] then
						Markers[Name] = nil
						TriggerClientEvent("propertys:Markers",-1,Markers)
					end

					rEVOLT.RemSrvData("Vault:"..Name)
					rEVOLT.RemSrvData("Fridge:"..Name)

					rEVOLT.Query("propertys/Sell",{ name = Name })
					TriggerClientEvent("Notify",source,"amarelo","Venda concluída.",5000)
					rEVOLT.GiveBank(Passport,Informations[Consult[1]["Interior"]]["Price"] * 0.75)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CREDENTIALS
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Credentials")
AddEventHandler("propertys:Credentials",function(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if parseInt(Consult[1]["Passport"]) == Passport then
				TriggerClientEvent("dynamic:closeSystem",source)

				if rEVOLT.Request(source,"Você escolheu reconfigurar todos os cartões de segurança, lembrando que ao prosseguir todos os cartões vão deixar de funcionar, deseja prosseguir?","Sim, prosseguir","Não, outra hora") then
					local Serial = PropertysSerials()
					rEVOLT.Query("propertys/Credentials",{ name = Name, serial = Serial })
					rEVOLT.GiveItem(Passport,"propertys-"..Serial,Consult[1]["Keys"],true)
				end
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Clothes()
	local Clothes = {}
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.GetSrvData("Wardrobe:"..Passport,true)

		for Table,_ in pairs(Consult) do
			Clothes[#Clothes + 1] = Table
		end
	end

	return Clothes
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYS:CLOTHES
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("propertys:Clothes")
AddEventHandler("propertys:Clothes",function(Mode)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.GetSrvData("Wardrobe:"..Passport,true)
		local Split = splitString(Mode)
		local Name = Split[2]

		if Split[1] == "save" then
			local Keyboard = vKEYBOARD.keySingle(source,"Nome")
			if Keyboard then
				local Check = sanitizeString(Keyboard[1],"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",true)

				if not Consult[Check] then
					Consult[Check] = vSKINSHOP.getCustomization(source)
					rEVOLT.SetSrvData("Wardrobe:"..Passport,Consult,true)
					TriggerClientEvent("propertys:ClothesReset",source)
					TriggerClientEvent("Notify",source,"verde","<b>"..Check.."</b> adicionado.",5000)
				else
					TriggerClientEvent("Notify",source,"amarelo","Nome escolhido já existe em seu armário.",5000)
				end
			end
		elseif Split[1] == "delete" then
			if Consult[Name] then
				Consult[Name] = nil
				rEVOLT.SetSrvData("Wardrobe:"..Passport,Consult,true)
				TriggerClientEvent("propertys:ClothesReset",source)
				TriggerClientEvent("Notify",source,"verde","<b>"..Name.."</b> removido.",5000)
			else
				TriggerClientEvent("Notify",source,"amarelo","A vestimenta salva não se encontra mais em seu armário.",5000)
			end
		elseif Split[1] == "apply" then
			if Consult[Name] then
				TriggerClientEvent("skinshop:Apply",source,Consult[Name])
				TriggerClientEvent("Notify",source,"verde","<b>"..Name.."</b> aplicado.",5000)
			else
				TriggerClientEvent("Notify",source,"amarelo","A vestimenta salva não se encontra mais em seu armário.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PROPERTYSSERIALS
-----------------------------------------------------------------------------------------------------------------------------------------
function PropertysSerials()
	local Serial = rEVOLT.GenerateString("LDLDLDLDLD")
	local Consult = rEVOLT.Query("propertys/Serial",{ serial = Serial })
	if Consult[1] then
		PropertysSerials()
	end

	return Serial
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENCHEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.OpenChest(Name,Mode)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Chest = {}
		local Inventory = {}
		local Inv = rEVOLT.Inventory(Passport)
		local Consult = rEVOLT.GetSrvData(Mode..":"..Name)

		for k,v in pairs(Inv) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Inventory[k] = v
		end

		for k,v in pairs(Consult) do
			v["amount"] = parseInt(v["amount"])
			v["name"] = itemName(v["item"])
			v["peso"] = itemWeight(v["item"])
			v["index"] = itemIndex(v["item"])
			v["max"] = itemMaxAmount(v["item"])
			v["economy"] = parseFormat(itemEconomy(v["item"]))
			v["desc"] = itemDescription(v["item"])
			v["key"] = v["item"]
			v["slot"] = k

			local Split = splitString(v["item"],"-")
			if Split[2] ~= nil then
				if itemDurability(v["item"]) then
					v["durability"] = parseInt(os.time() - Split[2])
					v["days"] = itemDurability(v["item"])
				else
					v["durability"] = 0
					v["days"] = 1
				end
			else
				v["durability"] = 0
				v["days"] = 1
			end

			Chest[k] = v
		end

		local Exist = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Exist[1] then
			return Inventory,Chest,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Consult),Exist[1][Mode]
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- STORE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Store(Item,Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if itemBlock(Item) or (Mode == "Vault" and BlockChest(Item)) or (Mode == "Fridge" and not BlockChest(Item)) then
			TriggerClientEvent("propertys:Update",source)
			return
		end

		local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
		if Consult[1] then
			if Item == "diagram" then
				if rEVOLT.TakeItem(Passport,Item,Amount,false,Slot) then
					rEVOLT.Query("propertys/"..Mode,{ name = Name, weight = 10 * Amount })
					TriggerClientEvent("propertys:Update",source)
					TriggerEvent("Discord","bau-casa-colocou","**Passaporte:** "..Passport.."\n**Colocou:** "..Amount.."x "..Item.."\n**Casa:** "..Name.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
				end
			else
				if rEVOLT.StoreChest(Passport,Mode..":"..Name,Amount,Consult[1][Mode],Slot,Target) then
					TriggerClientEvent("propertys:Update",source)
					TriggerEvent("Discord","bau-casa-colocou","**Passaporte:** "..Passport.."\n**Colocou:** "..Amount.."x "..Item.."\n**Casa:** "..Name.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
				else
					local Result = rEVOLT.GetSrvData(Mode..":"..Name)
					TriggerClientEvent("propertys:Weight",source,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Result),Consult[1][Mode])
					TriggerEvent("Discord","bau-casa-colocou","**Passaporte:** "..Passport.."\n**Colocou:** "..Amount.."x "..Item.."\n**Casa:** "..Name.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- TAKE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Take(Slot,Amount,Target,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if rEVOLT.TakeChest(Passport,Mode..":"..Name,Amount,Slot,Target) then
			TriggerClientEvent("propertys:Update",source)
		else
			local Consult = rEVOLT.Query("propertys/Exist",{ name = Name })
			if Consult[1] then
				local Result = rEVOLT.GetSrvData(Mode..":"..Name)
				TriggerClientEvent("propertys:Weight",source,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),rEVOLT.ChestWeight(Result),Consult[1][Mode])
				TriggerEvent("Discord","bau-casa-tirou","**Passaporte:** "..Passport.."\n**Quantidade:** "..Amount.."\n**Item:** "..Slot.."\n**Casa:** "..Name.."\n**Horário:** "..os.date("%H:%M:%S"),3042892)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPDATE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot,Target,Amount,Name,Mode)
	local source = source
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if Amount <= 0 then Amount = 1 end

		if rEVOLT.UpdateChest(Passport,Mode..":"..Name,Slot,Target,Amount) then
			TriggerClientEvent("propertys:Update",source)
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ROUTE
-----------------------------------------------------------------------------------------------------------------------------------------
function Route(Name)
	local Split = splitString(Name,"ropertys")

	return parseInt(100000 + Split[2])
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Connect",function(Passport,source)
	TriggerClientEvent("propertys:Table",source,Propertys,Interiors,Markers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DISCONNECT
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("Disconnect",function(Passport)
	if Inside[Passport] then
		rEVOLT.InsidePropertys(Passport,Propertys[Inside[Passport]])
		Inside[Passport] = nil
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTART
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	Wait(1000)
	TriggerClientEvent("propertys:Table",-1,Propertys,Interiors,Markers)
	local Consult = rEVOLT.Query("propertys/All")

	for Index,v in pairs(Consult) do
		Markers[v["Name"]] = true
	end

	TriggerClientEvent("propertys:Table",-1,Propertys,Interiors,Markers)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERCHOSEN
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("CharacterChosen",function(Passport,source)
	local Consult = rEVOLT.Query("propertys/AllUser",{ Passport = Passport })
	if Consult[1] then
		local Tables = {}

		for _,v in pairs(Consult) do
			local Name = v["Name"]
			if Propertys[Name] then
				Tables[#Tables + 1] = { ["Coords"] = Propertys[Name] }
			end
		end

		TriggerClientEvent("spawn:Increment",source,Tables)
	end
end)