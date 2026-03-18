-----------------------------------------------------------------------------------------------------------------------------------------
-- REVOLT
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLTC = Tunnel.getInterface("rEVOLT")
trEVOLT = Tunnel.getInterface("rEVOLT")
rEVOLT = Proxy.getInterface("rEVOLT")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONNECTION
-----------------------------------------------------------------------------------------------------------------------------------------
Creative = {}
Tunnel.bindInterface("garages",Creative)
vCLIENT = Tunnel.getInterface("garages")
vKEYBOARD = Tunnel.getInterface("keyboard")
-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIAVEIS
-----------------------------------------------------------------------------------------------------------------------------------------
local Spawn = {}
local Signal = {}
local Searched = {}
local TypePayment1 = "Compra De Veiculo" 
local TypePayment2 = "Aluguel De Veiculo" 
local TypePayment3 = "Compra De Veiculo" 
local TypePayment4 = "Impound" 
local TypePayment5 = "Taxa De Veiculo" 
local TypePayment6 = "Retirou Veiculo" 
-----------------------------------------------------------------------------------------------------------------------------------------
-- GLOBALSTATE
-----------------------------------------------------------------------------------------------------------------------------------------
GlobalState["Plates"] = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.ServerVehicle(Model,x,y,z,Heading,Plate,Nitrox,Doors,Body,Fuel)
    local Randomize = 0
    local Vehicle = CreateVehicle(Model,x,y,z,Heading,true,true)

    while not DoesEntityExist(Vehicle) and Randomize <= 1000 do
        Randomize = Randomize + 1
        Wait(100)
    end

    if DoesEntityExist(Vehicle) then
        if Plate ~= nil then
            SetVehicleNumberPlateText(Vehicle,Plate)
        else
            Plate = rEVOLT.GeneratePlate()
            SetVehicleNumberPlateText(Vehicle,Plate)
        end

        SetVehicleBodyHealth(Vehicle,Body + 0.0)

        if Doors then
            local Doors = json.decode(Doors)
            if Doors ~= nil then
                for Number,Status in pairs(Doors) do
                    if Status then
                        SetVehicleDoorBroken(Vehicle,parseInt(Number),true)
                    end
                end
            end
        end

        local Network = NetworkGetNetworkIdFromEntity(Vehicle)
        if Model ~= "wheelchair" then
            local Network = NetworkGetEntityFromNetworkId(Network)
            SetVehicleDoorsLocked(Network,2)
            local Nitro = GlobalState["Nitro"]
            Nitro[Plate] = Nitrox or 0
            GlobalState:set("Nitro",Nitro,true)
			Entity(Network)["state"]:set("Fuel",Fuel or 100,true)
        end

        return Network,Vehicle
    end
    return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES
-----------------------------------------------------------------------------------------------------------------------------------------
local Garages = {
	["1"] = { name = "Garage", payment = true },
	["2"] = { name = "Garage", payment = true },
	["3"] = { name = "Garage", payment = true },
	["4"] = { name = "Garage", payment = true },
	["5"] = { name = "Garage", payment = true },
	["6"] = { name = "Garage", payment = true },
	["7"] = { name = "Garage", payment = true },
	["8"] = { name = "Garage", payment = true },
	["9"] = { name = "Garage", payment = true },
	["10"] = { name = "Garage", payment = true },
	["11"] = { name = "Garage", payment = true },
	["12"] = { name = "Garage", payment = true },
	["13"] = { name = "Garage", payment = true },
	["14"] = { name = "Garage", payment = true },
	["15"] = { name = "Garage", payment = true },
	["16"] = { name = "Garage", payment = true },
	["17"] = { name = "Garage", payment = true },
	["18"] = { name = "Garage", payment = true },
	["19"] = { name = "Garage", payment = true },
	["20"] = { name = "Garage", payment = true },
	["21"] = { name = "Garage", payment = true },
	["22"] = { name = "Garage", payment = true },
	["23"] = { name = "Garage", payment = true },
	["24"] = { name = "Garage", payment = true },
	["25"] = { name = "Garage", payment = true },
	["26"] = { name = "Garage", payment = true },
	["27"] = { name = "Garage", payment = true },
	["28"] = { name = "Garage", payment = false },

	-- Paramedic
	["41"] = { name = "Paramedic", payment = false, perm = "Paramedic" },
	["42"] = { name = "heliParamedic", payment = false, perm = "Paramedic" },

	-- Police
	["61"] = { name = "Police", payment = false, perm = "Police" },
	["62"] = { name = "heliPolice", payment = false, perm = "Police" },

	-- Ilegal

	-- Boats
	["121"] = { name = "Boats", payment = true },
	["122"] = { name = "Boats", payment = true },
	["123"] = { name = "Boats", payment = true },
	["124"] = { name = "Boats", payment = true },
	["125"] = { name = "Boats", payment = true },
	["126"] = { name = "Boats", payment = true },

	-- Works
	["141"] = { name = "Lumberman", payment = false },
	["142"] = { name = "Miner", payment = false },
	["143"] = { name = "Tows", payment = false },
	["144"] = { name = "Transporter", payment = false },
	["145"] = { name = "Taxi", payment = false },
	["146"] = { name = "Garbageman", payment = false },
	["147"] = { name = "Garbageman", payment = false },
	["148"] = { name = "Garbageman", payment = false },
	["149"] = { name = "Taxi", payment = false },
	["150"] = { name = "Trucker", payment = false },
	["151"] = { name = "Bus", payment = false },
	["152"] = { name = "Bus", payment = false },
	["153"] = { name = "Postal", payment = false },
	["154"] = { name = "Milk", payment = false },
	["155"] = { name = "Tractor", payment = false },
	["156"] = { name = "Pilot", payment = false },
	["157"] = { name = "Mechanic", payment = false, perm = "Mechanic" },
	["158"] = { name = "Mechanic", payment = false, perm = "Mechanic" },
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNALREMOVE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("signalRemove",function(Plate)
	if not Signal[Plate] then
		Signal[Plate] = true
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEREVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateReveryone",function(Plate)
	if GlobalState["Plates"][Plate] then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = nil
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEEVERYONE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("plateEveryone",function(Plate)
	local Plates = GlobalState["Plates"]
	Plates[Plate] = true
	GlobalState:set("Plates",Plates,true)
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- PLATEPLAYERS
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("platePlayers",function(Plate,Passport)
	if not rEVOLT.PassportPlate(Plate) then
		local Plates = GlobalState["Plates"]
		Plates[Plate] = Passport
		GlobalState:set("Plates",Plates,true)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- WORKS
-----------------------------------------------------------------------------------------------------------------------------------------
local Works = {
	["Boats"] = {
		"dinghy",
		"jetmax",
		"marquis",
		"seashark",
		"speeder",
		"squalo",
		"suntrap",
		"toro",
		"tropic"
	},
	["bicycles"] = {
		"bmx",
		"scorcher",
		"cruiser",
		"tribike",
		"tribike2",
		"tribike3",
	},
	["Paramedic"] = {
		"ambulance2",
	},
	["heliParamedic"] = {
		"maverick2"
	},
	["Police"] = {
		"polvic",
		"komodapol",
		"r1250pol",
		"nc700pol",
		"polchar",
		"ballerpol",
		"elegy2pol",
		"fugitivepol",
		"kurumapol",
		"oracle2pol",
		"police3pol",
		"policepol",
		"policetpol",
		"schafter2pol",
		"sheriff2pol",
		"sultanrspol",
		"tailgater2pol",
		"polchall",
		"poltang"
    },
	["heliPolice"] = {
		"B412"
	},
	["busPolice"] = {
		"pbus",
		"riot"
	},
	["Bus"] = {
		"bus",
	},
	["Mechanic"] = {
		"flatbed",
		"towtruck",
		"towtruck2"
	},
	["Miner"] = {
		"tiptruck",
		"tiptruck2"
	},
	["Transporter"] = {
		"stockade"
	},
	["Lumberman"] = {
		"ratloader"
	},
	["Tows"] = {
		"flatbed",
		"towtruck",
		"towtruck2"
	},
	["Garbageman"] = {
		"trash",
		"trash2"
	},
	["Taxi"] = {
		"taxi"
	},
	["Trucker"] = {
		"hauler",
		"hauler2",
		"packer",
		"phantom"
	},
	["Postal"] = {
		"boxville2"
	},
	["Milk"] = {
		"youga2"
	},
	["Tractor"] = {
		"tractor2",
		"raketrailer"
	},
	["Pilot"] = {
		"cuban800",
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- VEHICLES
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Vehicles(Number)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and not exports["hud"]:Wanted(Passport) then
	
		if Garages[Number] then
			if Garages[Number]["perm"] then
				if not rEVOLT.HasService(Passport,Garages[Number]["perm"]) then
					return false
				end
			end
		else
			local Consult = rEVOLT.Query("propertys/Exist",{ Number = tonumber(SplitTwo(Number,":")) })
			if not ((Consult[1] and Consult[1]["Passport"] == Passport) or (Consult[1] and rEVOLT.InventoryFull(Passport,"homekey-"..Consult[1]["Keychain"].."-"..Consult[1]["Number"])) or exports["propertys"]:Lock(tonumber(SplitTwo(Number,":")))) then
				return false
			end
		end

		local Vehicle = {}
		local Garage = Garages[Number] and Garages[Number]["name"]
		if Garage and Works[Garage] then
			for _,v in pairs(Works[Garage]) do
				local vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = v })
				if VehicleExist(v) then
					if vehicle[1] then
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
							["type"] = VehicleMode(v),
							["engine"] = vehicle[1]["engine"],
							["chassi"] = vehicle[1]["health"],
							["body"] = vehicle[1]["body"],
							["gas"] = vehicle[1]["fuel"],
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * 0.10
						}
					else
						Vehicle[#Vehicle + 1] = { 
							["model"] = v,
							["name"] = VehicleName(v),
							["type"] = VehicleMode(v),
							["engine"] = 1000,
							["chassi"] = 1000,
							["body"] = 1000,
							["gas"] = 100,
							["chest"] = VehicleChest(v),
							["tax"] = VehiclePrice(v) * 0.10
						}
					end
				end
			end
		else
			local Consult = rEVOLT.Query("vehicles/UserVehicles",{ Passport = Passport })
			for _,v in pairs(Consult) do
				if VehicleExist(v["vehicle"]) then
					if v["work"] == "false" then
						if v["tax"] <= os.time() then
							if rEVOLT.HasGroup(v["Passport"],"Magnata") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Foguetao") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Metralha") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Infinity") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Favela") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Platina") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							elseif rEVOLT.HasGroup(v["Passport"],"Ouro") then
								rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = v["vehicle"] })
							end
						end
						if VehicleMode(v["vehicle"]) == "Rental" and (v["rental"]+86400) <= os.time() then
							rEVOLT.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = v["vehicle"]})
						else
							Vehicle[#Vehicle + 1] = { 
								["model"] = v["vehicle"],
								["name"] = VehicleName(v["vehicle"]),
								["type"] = VehicleMode(v["vehicle"]),
								["engine"] = v["engine"],
								["chassi"] = v["health"],
								["body"] = v["body"],
								["gas"] = v["fuel"],
								["chest"] = VehicleChest(v["vehicle"]),
								["tax"] = VehiclePrice(v["vehicle"]) * 0.10
							}
						end
					end
				end
			end
		end
		return Vehicle
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Impound()
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Vehicles = {}
		local Vehicle = rEVOLT.Query("vehicles/UserVehicles",{ Passport = Passport })
		for Number,v in ipairs(Vehicle) do
			if v["arrest"] >= os.time() then
				--[[ if VehiclePrice(v["vehicle"]) > 0 then
					Vehicles[#Vehicles + 1] = { ["Model"] = v["vehicle"], ["name"] = VehicleName(v["vehicle"]), ["Price"] = VehiclePrice(v["vehicle"]) }
				else
					Vehicles[#Vehicles + 1] = { ["Model"] = v["vehicle"], ["name"] = VehicleName(v["vehicle"]), ["Gemstone"] = VehicleGemstone(v["vehicle"]) }
				end ]]
				Vehicles[#Vehicles + 1] = { ["Model"] = v["vehicle"], ["name"] = VehicleName(v["vehicle"]), ["Price"] = (VehicleMode(v["vehicle"]) == "Rental" and 200000) or VehiclePrice(v["vehicle"]) }
			end
		end
		return Vehicles
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:IMPOUND
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Impound")
AddEventHandler("garages:Impound",function(vehicle)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		TriggerClientEvent("dynamic:closeSystem",source)
		if VehiclePrice(vehicle) > 0 then
			if rEVOLT.PaymentFull(Passport,VehiclePrice(vehicle) * 0.15,TypePayment4) then
				rEVOLT.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = vehicle })
				TriggerClientEvent("Notify",source,"verde","Veículo liberado.",5000)
			end
		else
			if rEVOLT.PaymentFull(Passport,VehicleGemstone(vehicle) * 0.15,TypePayment4) then
				rEVOLT.Query("vehicles/paymentArrest",{ Passport = Passport, vehicle = vehicle })
				TriggerClientEvent("Notify",source,"verde","Veículo liberado.",5000)
			end
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TAX
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Tax(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Consult = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] and Consult[1]["tax"] <= os.time() then
			local Price = VehiclePrice(Name) * 0.10
			if rEVOLT.PaymentFull(Passport,Price,TypePayment5) then
				rEVOLT.Query("vehicles/updateVehiclesTax",{ Passport = Passport, vehicle = Name })
				TriggerClientEvent("Notify",source,"verde","Pagamento concluído.",5000)
				TriggerEvent("Discord","TaxVehicle","**Passaporte:** "..Passport.."\n**Veículo:** "..VehicleName(Name).."\n**Dólares:** "..Price,3553599)
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SELL
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Sell(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "Rental" or Mode == "Work" then
			return
		end
		local Consult = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if Consult[1] then
			local Price = VehiclePrice(Name) * 0.5
			if rEVOLT.Request(source,"Garagem","Vender o veículo <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b>?","Sim, concluír venda","Não, mudei de ideia") then
				local Consult = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				if Consult[1] then
					rEVOLT.GiveBank(Passport,Price)
					rEVOLT.Query("vehicles/removeVehicles",{ Passport = Passport, vehicle = Name })
					TriggerEvent("Discord","SellVehicle","**Passaporte:** "..Passport.."\n**Veículo:** "..VehicleName(Name).."\n**Dólares:** "..Price,3553599)
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:TRANSFER
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Transfer(Name)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Mode = VehicleMode(Name)
		if Mode == "Rental" or Mode == "Work" then
			return
		end
		local myVehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if myVehicle[1] then
			TriggerClientEvent("dynamic:closeSystem",source)
			local Keyboard = vKEYBOARD.Primary(source,"Passaporte:")
			if Keyboard then
				local OtherPassport = parseInt(Keyboard[1])
				local Identity = rEVOLT.Identities(OtherPassport)
				if Identity then
		
					local MaxVehicles = 3
					if rEVOLT.HasGroup(OtherPassport,"Magnata") then
						MaxVehicles = MaxVehicles + 20
					elseif rEVOLT.HasGroup(OtherPassport,"Foguetao") then
						MaxVehicles = MaxVehicles + 15
					elseif rEVOLT.HasGroup(OtherPassport,"Metralha") then
						MaxVehicles = MaxVehicles + 10
					elseif rEVOLT.HasGroup(OtherPassport,"Infinity") then
						MaxVehicles = MaxVehicles + 7
					elseif rEVOLT.HasGroup(OtherPassport,"Favela") then
						MaxVehicles = MaxVehicles + 5
					elseif rEVOLT.HasGroup(OtherPassport,"Platina") then
						MaxVehicles = MaxVehicles + 5
					elseif rEVOLT.HasGroup(OtherPassport,"Ouro") then
						MaxVehicles = MaxVehicles + 4
					elseif rEVOLT.HasGroup(OtherPassport,"Prata") then
						MaxVehicles = MaxVehicles + 2
					elseif rEVOLT.HasGroup(OtherPassport,"Bronze") then
						MaxVehicles = MaxVehicles + 1
					end

					local Vehicles = exports["oxmysql"]:query_async("SELECT vehicle, COUNT(vehicle) AS countVehicle FROM vehicles WHERE work = 'false' AND Passport = @Passport GROUP BY vehicle ORDER BY countVehicle DESC;",{ Passport = OtherPassport })
					if #Vehicles >= MaxVehicles then
						TriggerClientEvent("Notify",source,"azul","<b>"..Identity["name"].." "..Identity["name2"].."</b> Atingiu o número máximo de veículos em sua garagem.",8000)
					else
						if rEVOLT.Request(source,"Garagem","Transferir o veículo <b>"..VehicleName(Name).."</b> para <b>"..Identity["name"].." "..Identity["name2"].."</b>?","Sim, transferir","Não, mudei de ideia") then
							local Vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = parseInt(OtherPassport), vehicle = Name })
							if Vehicle[1] then
								TriggerClientEvent("Notify",source,"amarelo","<b>"..Identity["name"].." "..Identity["name2"].."</b> já possui este modelo de veículo.",5000)
							else
								rEVOLT.Query("vehicles/moveVehicles",{ Passport = Passport, OtherPassport = parseInt(OtherPassport), vehicle = Name })
								TriggerClientEvent("Notify",source,"verde","Transferência concluída.",5000)
								TriggerEvent("Discord","TransferVehicle","**Passaporte:** "..Passport.."\n**Veículo:** "..VehicleName(Name).."\n**Para:** "..OtherPassport,3553599)
							end
						end
					end
					
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:SPAWN
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Spawn(Name, Number)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport then
		local Gemstone = VehicleGemstone(Name)
		local Price = VehiclePrice(Name)
		local vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
		if not vehicle[1] then
			if parseInt(Gemstone) > 0 then
				if rEVOLT.Request(source,"Alugar o veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.."</b> Gemas?","Sim, concluír aluguel","Não, mudei de ideia") then
					if rEVOLT.PaymentGems(Passport,Gemstone) then
						rEVOLT.Query("vehicles/rentalVehicles",{ Passport = Passport, vehicle = Name, plate = rEVOLT.GeneratePlate(), work = "true" })
						TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> concluído.",5000,"sucesso")
						vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
					else
						return
					end
				else
				 	return
				end
			else
				if parseInt(Price) > 0 then
					if rEVOLT.Request(source,"Comprar <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b> dólares?","Sim, concluír pagamento","Não, mudei de ideia") then
						if rEVOLT.PaymentFull(Passport,Price,TypePayment1) then
							rEVOLT.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = rEVOLT.GeneratePlate(), work = "true" })
							vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
						else
						end
					else
					 	return
					end
				else
					rEVOLT.Query("vehicles/addVehicles",{ Passport = Passport, vehicle = Name, plate = rEVOLT.GeneratePlate(), work = "true" })
					vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = Name })
				end
			end
		end

		if vehicle[1] then
			local Plates = GlobalState["Plates"]
			local Plate = vehicle[1]["plate"]

			if Spawn[Plate] then
				if not Signal[Plate] then
					if not Searched[Passport] then
						Searched[Passport] = os.time()
					end

					if os.time() >= parseInt(Searched[Passport]) then
						Searched[Passport] = os.time() + 60

						local Network = Spawn[Plate][3]
						local Network = NetworkGetEntityFromNetworkId(Network)
						if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 then
							vCLIENT.SearchBlip(source,GetEntityCoords(Network))
							TriggerClientEvent("Notify",source,"amarelo","Rastreador do veículo foi ativado por <b>30</b> segundos, lembrando que se o mesmo estiver em movimento a localização pode ser imprecisa.",10000)
						else
							if Spawn[Plate] then
								Spawn[Plate] = nil
							end

							if Plates[Plate] then
								Plates[Plate] = nil
								GlobalState:set("Plates",Plates,true)
							end

							TriggerClientEvent("Notify",source,"verde","A seguradora efetuou o resgate do seu veículo e o mesmo já se encontra disponível para retirada.",5000)
						end
					else
						TriggerClientEvent("Notify",source,"amarelo","Rastreador só pode ser ativado a cada <b>60</b> segundos.",5000)
					end
				else
					TriggerClientEvent("Notify",source,"amarelo","Rastreador está desativado.",5000)
				end
			else
				if vehicle[1]["tax"] <= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Taxa do veículo atrasada.",5000)
				elseif vehicle[1]["arrest"] >= os.time() then
					TriggerClientEvent("Notify",source,"amarelo","Veículo apreendido, dirija-se até o <b>Pátio de Apreensão</b> e efetue o pagamento da liberação do mesmo.",5000)
				else
					if vehicle[1]["rental"] ~= 0 then
						if vehicle[1]["rental"] <= os.time() then
							if parseInt(Gemstone) > 0 then
								if rEVOLT.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>"..Gemstone.." Gemas</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
									if rEVOLT.PaymentGems(Passport,Gemstone) then
										rEVOLT.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
										TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
										TriggerEvent("Discord","RentalVehicle","**Passaporte:** "..Passport.."\n**Veículo:** "..VehicleName(Name).."\n**Gemas:** "..Gemstone,3553599)
									else
										TriggerClientEvent("Notify",source,"vermelho","<b>Gemas</b> insuficientes.",5000,"negado")
										return
									end
								else
									return
								end
							else
								if parseInt(Price) > 0 then
									if rEVOLT.Request(source,"Atualizar o aluguel do veículo <b>"..VehicleName(Name).."</b> por <b>$"..parseFormat(Price).."</b>?","Sim, concluír pagamento","Não, mudei de ideia") then
										if rEVOLT.PaymentFull(Passport,Price,TypePayment1) then
											rEVOLT.Query("vehicles/rentalVehiclesUpdate",{ Passport = Passport, vehicle = Name })
											TriggerClientEvent("Notify",source,"verde","Aluguel do veículo <b>"..VehicleName(Name).."</b> atualizado.",5000)
											TriggerEvent("Discord","RentalVehicle","**Passaporte:** "..Passport.."\n**Veículo:** "..VehicleName(Name).."\n**Dólares:** "..Price,3553599)
										else
											return
										end
									else
										return
									end
								end
							end
						end
					end

					local Coords = vCLIENT.SpawnPosition(source,Number)
					if Coords then
						local Mods = nil
						local Datatable = rEVOLT.Query("entitydata/GetData",{ dkey = "Mods:"..Passport..":"..Name })
						if parseInt(#Datatable) > 0 then
							Mods = Datatable[1]["dvalue"]
						end

						if Garages[Number] and Garages[Number]["payment"] then
							if rEVOLT.HasGroup(Passport,"Premium") then
								TriggerClientEvent("dynamic:closeSystem",source)
								local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])
								if Network then
									vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
									TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
									TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
									Spawn[Plate] = { Passport,Name,Network }

									Plates[Plate] = Passport
									GlobalState:set("Plates",Plates,true)
								end
							else 
								if rEVOLT.PaymentFull(Passport,50,TypePayment6,"Retiro de Veiculo") then
									TriggerClientEvent("dynamic:closeSystem",source)
									local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])
									if Network then
										vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
										TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
										TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
										Spawn[Plate] = { Passport,Name,Network }
										Plates[Plate] = Passport
										GlobalState:set("Plates",Plates,true)
									end
								else
									return
								end
							end
						else
							TriggerClientEvent("dynamic:closeSystem",source)
							local Network = Creative.ServerVehicle(Name,Coords[1],Coords[2],Coords[3],Coords[4],Plate,vehicle[1]["nitro"],vehicle[1]["doors"],vehicle[1]["body"])
							if Network then
								vCLIENT.CreateVehicle(-1,Name,Network,vehicle[1]["engine"],vehicle[1]["health"],Mods,vehicle[1]["windows"],vehicle[1]["tyres"])
								TriggerClientEvent("Notify",source,"azul",CompleteTimers(vehicle[1]["tax"] - os.time()),1000)
								TriggerEvent("engine:tryFuel",Plate,vehicle[1]["fuel"])
								Spawn[Plate] = { Passport,Name,Network }

								Plates[Plate] = Passport
								GlobalState:set("Plates",Plates,true)
							end
						end
					end
				end
			end
		end
	end
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- CAR
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("car",function(source,Message)
	local Passport = rEVOLT.Passport(source)
	if Passport then
		if rEVOLT.HasGroup(Passport,"Admin") and Message[1] then
			local VehicleName = Message[1]
			local Ped = GetPlayerPed(source)
			local Coords = GetEntityCoords(Ped)
			local Heading = GetEntityHeading(Ped)
			local Plate = "VEH"..(10000 + Passport)
			local Network,Vehicle = Creative.ServerVehicle(VehicleName,Coords["x"],Coords["y"],Coords["z"],Heading,Plate,2000,nil,1000)
			if not Network then return end
			vCLIENT.CreateVehicle(-1,VehicleName,Network,1000,1000,nil,false,false)
			Spawn[Plate] = { Passport,VehicleName,Network }
			TriggerEvent("engine:tryFuel",Plate,100)
			SetPedIntoVehicle(Ped,Vehicle,-1)

			local Plates = GlobalState["Plates"]
			Plates[Plate] = Passport
			GlobalState:set("Plates",Plates,true)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DV
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("dv",function(source)
	local Passport = rEVOLT.Passport(source)
	if Passport and rEVOLT.HasGroup(Passport,"Admin",2) then
		TriggerClientEvent("garages:Delete",source)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCK
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:Lock")
AddEventHandler("garages:Lock",function(Network,Plate)
	local source = source
	local Passport = rEVOLT.Passport(source)
	if Passport and GlobalState["Plates"][Plate] == Passport then
		TriggerEvent("garages:LockVehicle",source,Network)
		TriggerClientEvent("garages:LockVehicle",source,Network)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:LOCKVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
AddEventHandler("garages:LockVehicle",function(source,Network)
	local Network = NetworkGetEntityFromNetworkId(Network)
	local Doors = GetVehicleDoorLockStatus(Network)

	if parseInt(Doors) <= 1 then
		TriggerClientEvent("Notify",source,"locked","Veículo trancado.",5000)
		TriggerClientEvent("sounds:Private",source,"locked",0.7)
		Wait(200)
		TriggerClientEvent("sounds:Private",source,"lock",0.2)
		SetVehicleDoorsLocked(Network,2)
	else
		TriggerClientEvent("Notify",source,"unlocked","Veículo destrancado.",5000)
		TriggerClientEvent("sounds:Private",source,"unlocked",0.7)
		Wait(200)
		TriggerClientEvent("sounds:Private",source,"unlock",0.2)
		SetVehicleDoorsLocked(Network,1)
	end

	if GetVehiclePedIsIn(GetPlayerPed(source),false) == 0 then
		rEVOLTC.createObjects(source,"anim@mp_player_intmenu@key_fob@","fob_click_fp","p_car_keys_01",48,57005,0.11, 0.03, -0.03, 90.0, 0.0, 0.0)
		Citizen.Wait(500)
		rEVOLTC.removeObjects(source, "one")
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DELETE
-----------------------------------------------------------------------------------------------------------------------------------------
function Creative.Delete(Network,Health,Engine,Body,Fuel,Doors,Windows,Tyres,Plate)
	if Spawn[Plate] then
		local Passport = Spawn[Plate][1]
		local vehName = Spawn[Plate][2]

		if parseInt(Engine) <= 100 then
			Engine = 100
		end

		if parseInt(Body) <= 100 then
			Body = 100
		end

		if parseInt(Fuel) >= 100 then
			Fuel = 100
		end

		if parseInt(Fuel) <= 0 then
			Fuel = 0
		end

		local vehicle = rEVOLT.Query("vehicles/selectVehicles",{ Passport = Passport, vehicle = vehName })
		if vehicle[1] ~= nil then
			rEVOLT.Query("vehicles/updateVehicles",{ Passport = Passport, vehicle = vehName, nitro = GlobalState["Nitro"][Plate] or 0, engine = parseInt(Engine), body = parseInt(Body), health = parseInt(Health), fuel = parseInt(Fuel), doors = json.encode(Doors), windows = json.encode(Windows), tyres = json.encode(Tyres) })
		end
	end

	TriggerEvent("garages:deleteVehicle",Network,Plate)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- GARAGES:DELETEVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterServerEvent("garages:deleteVehicle")
AddEventHandler("garages:deleteVehicle",function(Network,Plate)
	if Network ~= nil and Plate ~= nil then
		if GlobalState["Plates"][Plate] then
			local Plates = GlobalState["Plates"]
			Plates[Plate] = nil
			GlobalState:set("Plates",Plates,true)
		end

		if GlobalState["Nitro"][Plate] then
			local Nitro = GlobalState["Nitro"]
			Nitro[Plate] = nil
			GlobalState:set("Nitro",Nitro,true)
		end

		if Signal[Plate] then
			Signal[Plate] = nil
		end

		if Spawn[Plate] then
			Spawn[Plate] = nil
		end

		if string.sub(Plate,1,4) == "DISM" then
			local Passport = parseInt(string.sub(Plate,5,8)) - 1000
			local source = rEVOLT.Source(Passport)
			if source then
				TriggerClientEvent("inventory:Disreset",source)
				TriggerClientEvent("Notify",source,"amarelo","O veículo do seu contrato foi encaminhado para o <b>Impound</b> e o <b>Lester</b> disse que você pode assinar um novo contrato quando quiser.",10000)
			end
		end

		local Network = NetworkGetEntityFromNetworkId(Network)
		if DoesEntityExist(Network) and not IsPedAPlayer(Network) and GetEntityType(Network) == 2 and GetVehicleNumberPlateText(Network) == Plate then
			DeleteEntity(Network)
		end
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SIGNAL
-----------------------------------------------------------------------------------------------------------------------------------------
exports("Signal",function(Plate)
	return Signal[Plate]
end)