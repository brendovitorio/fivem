-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("crafting",Creative)
vCLIENT = Tunnel.getInterface("crafting")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- PERMISSION
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Permission(Name)
    local source = source
    local Passport = rEVOLT.Passport(source)
    if Passport then
        if List[Name]["perm"] then
            if List[Name]["perm"] ~= nil then
                if rEVOLT.HasGroup(Passport,List[Name]["perm"]) then
                    return true
                end
            end
        else
            return true
        end
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- REQUEST
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Request(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and List[Name] then
		
		local Crafting = {}
		local Inventory = {}
		local Inv = rEVOLT.Inventory(Passport)
		local Identity = rEVOLT.Identities(Passport)
		for Index,v in pairs(Inv) do
			if (parseInt(v["amount"]) <= 0 or not itemBody(v["item"])) then
				rEVOLT.RemoveItem(Passport,v["item"],parseInt(v["amount"]),false)
			else
				
				v["amount"] = parseInt(v["amount"])
				v["peso"] = itemWeight(v["item"])
				v["stack"] = itemStack(v["item"])
				v["index"] = itemIndex(v["item"])
				v["name"] = itemName(v["item"])
				v["key"] = v["item"]
				v["slot"] = Index
				v["desc"] = "<item>"..v["name"].."</item>"


				if itemChest(v["item"]) and v["data"] then
					for Slot,Value in pairs(v["data"]) do
						v["peso"] = v["peso"] + (itemWeight(Value["item"]) * parseInt(Value["amount"]))
					end
				end

				local Split = splitString(v["item"])
				local Description = itemDescription(v["item"])
				if Description then
					v["desc"] = v["desc"].."<br><description>"..Description.."</description>"				
				end
	
				if Split[1] == "identity" or Split[1] == "fidentity" or string.sub(v["item"],1,5) == "badge" then
					local Number = parseInt(Split[2])
					local Identity = rEVOLT.Identities(Number)
					if Split[1] == "fidentity" then
						Identity = rEVOLT.FalseIdentity(Number)
					end
					v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..(Identity["name"].." "..Identity["name2"]).."</r></legenda>"
				elseif Split[1] == "vehkey" then
					v["desc"] = v["desc"].."<br><legenda>Placa do Veículo: <r>"..(Split[2]).."</r></legenda>"
				elseif Split[1] == "homekey" then
					v["desc"] = v["desc"].."<br><legenda>Numeração: <r>"..(Split[3]).."</r></legenda>"
				elseif Split[1] == "creditcard" then
					local Number = parseInt(Split[2])
					local Identity = rEVOLT.Identities(Number)
					v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..(Identity["name"].." "..Identity["name2"]).."</r></legenda>"
				elseif Split[1] == "debitcard"  then
					local Number = parseInt(Split[2])
					local Identity = rEVOLT.Identities(Number)
					v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..(Identity["name"].." "..Identity["name2"]).."</r></legenda>"
				elseif Split[1] == "driverlicense" then
					v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..json.decode(Split[3])["name"].."</r> <br>Emissão: <r>"..os.date("%d/%m/%Y", json.decode(Split[3])["issued"]).."</r><br>Validity: <r>"..os.date("%d/%m/%Y", json.decode(Split[3])["expiration"]).."</r><br>Categoria: <r>"..string.gsub(json.encode(json.decode(Split[3])["categories"]), '[^%a,]', '').."</r></legenda>"
				elseif Split[1] == "dmvdocs" then
					v["desc"] = v["desc"].."<br><legenda>Nome: <r>"..rEVOLT.Identities(parseInt(Split[2]))["name"].." "..rEVOLT.Identities(parseInt(Split[2]))["name2"].."</r> <br>Prática: <r>"..string.gsub(Split[5], '[^%a,]', '').."</r><br>Teórica: <r>"..string.gsub(Split[4], '[^%a,]', '').."</r><br>Categoria: <r>"..string.gsub(Split[3], '[^%a,]', '').."</r></legenda>"
				elseif Split[3] and itemType(v["item"]) == "Armamento" then
					v["desc"] = v["desc"].."<br><legenda>Número de série: <r>"..Split[3].."</r></legenda>"
				elseif Split[1] == "receipt" then
					v["desc"] = v["desc"].."<br><legenda>Data: <r>"..os.date("%Y-%m-%d %H:%M:%S", Split[3]).."</r> <br>Nome: <r>"..rEVOLT.Identities(parseInt(Split[2]))["name"].." "..rEVOLT.Identities(parseInt(Split[2]))["name2"].."</r><br>Valor: <r>"..parseFormat(Split[4]).."</r><br>Descrição: <r>"..Split[5].."</r></legenda>"
				end

				if Split[2] then
					if itemCharges(v["item"]) then
						v["charges"] = parseInt(Split[2] * 33)
					end
					if itemDurability(v["item"]) then
						v["durability"] = parseInt(os.time() - Split[2])
						v["days"] = itemDurability(v["item"])
					end
				end

				Inventory[Index] = v
			end
		end

		local Slots = 0
		for Item,v in pairs(List[Name]["List"]) do
			local keyList = {}
            for Required, Amount in pairs(v.require) do
                keyList[#keyList + 1] = { 
					["name"] = itemName(Required),
					["index"] = itemIndex(Required),
					["amount"] = parseInt(Amount),
				}
            end
			Slots = Slots + 1
			Crafting[tostring(Slots)] = {
				["slot"] = Index,
				["key"] = Item,
				["name"] = itemName(Item),
				["index"] = itemIndex(Item),
				["peso"] = itemWeight(Item),
				["amount"] = parseInt(v["amount"]),
				["desc"] = "<item>"..itemName(Item).."</item>" ..  (itemDescription(Item) and "<br><description>" .. itemDescription(Item) .. "</description>" or ""),
				["required"] = keyList,
                ["time"] = v["time"]
			}
		end
		return Crafting,Inventory,rEVOLT.InventoryWeight(Passport),rEVOLT.GetWeight(Passport),Slots
	end
end
---------------------------------------------------------------------------------------------------------------------------------
-- TRADE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Trade(Name,Item,Amount,Slot,Target)
	local source = source
	local Slot = tostring(Slot)
	local Target = tostring(Target)
	local Amount = parseInt(Amount)
	local Passport = rEVOLT.Passport(source)
	if Passport and List[Name]["List"][Item] then
		if List[Name]["Mode"] == "Craft" then
			
			if rEVOLT.MaxItens(Passport,Item,Amount) then
				TriggerClientEvent("Notify",source,"amarelo","Limite atingido.",5000,"Aviso")
			else
				if (rEVOLT.InventoryWeight(Passport) + (itemWeight(Item) * List[Name]["List"][Item]["amount"]) * Amount) <= rEVOLT.GetWeight(Passport) then
					for Index, v in pairs(List[Name]["List"][Item]["require"]) do
						local ConsultItem = rEVOLT.InventoryItemAmount(Passport, Index)
						if ConsultItem[1] < parseInt(v * Amount) then
							TriggerClientEvent("Notify",source,"amarelo","Precisa de <b>"..parseInt(v-ConsultItem[1]).."x "..itemName(Index).."</b>.",5000)
							return
						end
						if rEVOLT.CheckDamaged(ConsultItem[2]) then
							TriggerClientEvent("Notify", source, "vermelho", "Item danificado.", 5000, "Aviso")
							return
						end
					end

					Player(source)["state"]["Buttons"] = true
					Player(source)["state"]["Cancel"] = true
					TriggerClientEvent("inventory:Close", source)
					TriggerClientEvent("Progress",source, List[Name]["List"][Item]["time"] * 1000)
					rEVOLTC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
					SetTimeout(List[Name]["List"][Item]["time"] * 1000,function()
						rEVOLTC.stopAnim(source,false)
						for Index, v in pairs(List[Name]["List"][Item]["require"]) do
							local ConsultItem = rEVOLT.InventoryItemAmount(Passport, Index)
							rEVOLT.RemoveItem(Passport, ConsultItem[2], parseInt(v * Amount), true)
						end
						rEVOLT.GenerateItem(Passport, Item, List[Name]["List"][Item]["amount"] * Amount, true)
						Player(source)["state"]["Buttons"] = false
						Player(source)["state"]["Cancel"] = false
					end)

				else
					TriggerClientEvent("Notify",source,"amarelo","Mochila cheia.",5000,"Aviso")
				end
			end


		elseif List[Name]["Mode"] == "Recycler" then
			for Key,Value in pairs(List[Name]["List"]) do
				if SplitOne(Item,"-") == Key then
					if rEVOLT.TakeItem(Passport,Key,Value["amount"],true,Slot) then
						Player(source)["state"]["Buttons"] = true
						Player(source)["state"]["Cancel"] = true
						TriggerClientEvent("inventory:Close", source)
						TriggerClientEvent("Progress",source, Value["time"] * 1000)
						rEVOLTC.playAnim(source,false,{"amb@prop_human_parking_meter@female@idle_a","idle_a_female"},true)
						SetTimeout(Value["time"] * 1000,function()
							rEVOLTC.stopAnim(source,false)
							for Required, Amount in pairs(Value["require"]) do
								if (rEVOLT.InventoryWeight(Passport) + itemWeight(Required) * Amount) <= rEVOLT.GetWeight(Passport) then
									rEVOLT.GenerateItem(Passport, Required, Amount, true)
								else
									TriggerClientEvent("Notify",source,"amarelo","Mochila cheia.",5000,"Aviso")
								end
							end
							Player(source)["state"]["Buttons"] = false
							Player(source)["state"]["Cancel"] = false
						end)
					end
					break
				end
			end
		end
		TriggerClientEvent("crafting:Update",source,"Request")
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Update(Slot, Target, Amount)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		rEVOLT.UpdateCrafting(Passport, Slot, Target, Amount)
	end
end