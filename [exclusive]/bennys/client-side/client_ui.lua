local currentMenuItemID = 0
local currentMenuItem = ""
local currentMenuItem2 = ""
local currentMenu = "mainMenu"
local currentCategory = 0
local currentRepinturaCategory = 0
local currentRepinturaType = 0
local currentWheelCategory = 0
local currentNeonSide = 0

local function roundNum(num,numDecimalPlaces)
	return tonumber(string.format("%."..(numDecimalPlaces or 0).."f",num))
end

local function toggleMenuContainer(state)
	SendNUIMessage({ toggleMenuContainer = true, state = state })
end

local function createMenu(menu,heading,subheading)
	SendNUIMessage({ createMenu = true, menu = menu, heading = heading, subheading = subheading })
end

local function destroyMenus()
	SendNUIMessage({ destroyMenus = true })
end

local function populateMenu(menu,id,item,item2)
	SendNUIMessage({ populateMenu = true, menu = menu, id = id, item = item, item2 = item2 })
end

local function finishPopulatingMenu(menu)
	SendNUIMessage({ finishPopulatingMenu = true, menu = menu })
end

local function updateMenuHeading(menu)
	SendNUIMessage({ updateMenuHeading = true, menu = menu })
end

local function updateMenuSubheading(menu)
	SendNUIMessage({ updateMenuSubheading = true, menu = menu })
end

local function updateMenuStatus(text)
	SendNUIMessage({ updateMenuStatus = true, statusText = text })
end

local function toggleMenu(state,menu)
	SendNUIMessage({ toggleMenu = true, state = state, menu = menu })
end

local function updateItem2Text(menu,id,text)
	SendNUIMessage({ updateItem2Text = true, menu = menu, id = id, item2 = text })
end

local function updateItem2TextOnly(menu,id,text)
	SendNUIMessage({ updateItem2TextOnly = true, menu = menu, id = id, item2 = text })
end

local function scrollMenuFunctionality(direction,menu)
	SendNUIMessage({ scrollMenuFunctionality = true, direction = direction, menu = menu })
end

local function playSoundEffect(soundEffect,volume)
	SendNUIMessage({ playSoundEffect = true, soundEffect = soundEffect, volume = volume })
end

local function isMenuActive(menu)
	local menuActive = false

	if menu == "modMenu" then
		for k,v in pairs(vehicleCustomisation) do 
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "RepinturaMenu" then
		for k,v in pairs(vehicleRepinturaOptions) do
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "RodasMenu" then
		for k,v in pairs(vehicleWheelOptions) do
			if (v["category"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	elseif menu == "NeonsSideMenu" then
		for k,v in pairs(vehicleNeonOptions["neonTypes"]) do
			if (v["name"]:gsub("%s+","").."Menu") == currentMenu then
				menuActive = true

				break
			else
				menuActive = false
			end
		end
	end

	return menuActive
end

local function updateCurrentMenuItemID(id,item,item2)
	currentMenuItemID = id
	currentMenuItem = item
	currentMenuItem2 = item2
	if isMenuActive("modMenu") then
		if currentMenu == "AerofólioMenu" then
			MoveVehCam('back',0.5,-1.6,1.3)
		elseif currentMenu == "ParachoquedianteiroMenu" then
			MoveVehCam('front',-0.6,1.5,0.4)
		elseif currentMenu == "ParachoquetraseiroMenu" then
			MoveVehCam('back',-0.5,-1.5,0.2)
		elseif currentMenu == "EscapeMenu" then
			MoveVehCam('back',-0.5,-1.5,0.2)
		elseif currentMenu == "SaialateralMenu" then
			MoveVehCam('left',-1.8,-1.3,0.7)
		elseif currentMenu == "CagedeproteçãoMenu" then
			MoveVehCam('back-top',0.0,4.0,0.7)
		elseif currentMenu == "CapôMenu" then
			MoveVehCam('front-top',-0.5,1.3,1.0)
		elseif currentMenu == "GradeMenu" then
			MoveVehCam('front',-0.6,1.5,0.4)
		elseif currentMenu == "TetoMenu" then
			MoveVehCam('middle',-2.2,2,1.5)
		elseif currentMenu == "SuspensãoMenu" then
			MoveVehCam('left',-1.8,-1.3,0.7)
		end
		if currentCategory ~= 18 then
			PreviewMod(currentCategory,currentMenuItemID)
		end
	elseif isMenuActive("RepinturaMenu") then
		MoveVehCam('middle',-2.6,2.5,1.4)
		PreviewColour(currentRepinturaCategory,currentRepinturaType,currentMenuItemID)
	elseif isMenuActive("RodasMenu") then
		if currentWheelCategory ~= -1 and currentWheelCategory ~= 20 then
			PointCamAtBone("wheel_lf",-1.4,0,0.3)
			PreviewWheel(currentCategory,currentMenuItemID,currentWheelCategory)
		end
	elseif isMenuActive("NeonsSideMenu") then
		PointCamAtBone("neon_l",-2.0,2.0,0.4)
		PreviewNeon(currentNeonSide,currentMenuItemID)
	elseif currentMenu == "PeliculadeVidroMenu" then
		MoveVehCam('middle',-2.0,2,0.5)
		PreviewPeliculadeVidro(currentMenuItemID)
	elseif currentMenu == "NeonCoresMenu" then
		local r = vehicleNeonOptions["neonCores"][currentMenuItemID]["r"]
		local g = vehicleNeonOptions["neonCores"][currentMenuItemID]["g"]
		local b = vehicleNeonOptions["neonCores"][currentMenuItemID]["b"]
		PointCamAtBone("neon_l",-2.0,2.0,0.4)
		PreviewNeonColour(r,g,b)
	elseif currentMenu == "XenonCoresMenu" then
		MoveVehCam('front',-0.6,1.3,0.6)
		PreviewXenonColour(currentMenuItemID)
	elseif currentMenu == "PoliceLiveryMenu" then
		MoveVehCam('left',-1.8,-1.3,0.7)
		PreviewPoliceLivery(currentMenuItemID)
	elseif currentMenu == "PlacasMenu" then
		MoveVehCam('back',0,-1,0.2)
		PreviewPlacas(currentMenuItemID)
	else
		ResetCam()
	end
end

function InitiateMenus(isMotorcycle)
	local Ped = PlayerPedId()
	local vehicle = GetVehiclePedIsUsing(Ped)
	local vehclass = GetVehicleClass(vehicle)

	createMenu("mainMenu","Bem-vindo a Benny's Original Motorworks","Escolha uma Categoria")

	for k,v in ipairs(vehicleCustomisation) do 
		local validMods,amountValidMods = CheckValidMods(v["category"],v["id"])

		if amountValidMods > 0 or v["id"] == 18 then
			populateMenu("mainMenu",v["id"],v["category"],"none")
		end
	end

	populateMenu("mainMenu",-1,"Repintura","none")

	if not isMotorcycle then
		populateMenu("mainMenu",-2,"Pelicula de Vidro","none")
		populateMenu("mainMenu",-3,"Neons","none")
	end

	populateMenu("mainMenu",22,"Xenons","none")
	populateMenu("mainMenu",23,"Rodas","none")

	populateMenu("mainMenu",26,"Veiculo Extras","none")

	populateMenu("mainMenu",25,"Placas","none")

	finishPopulatingMenu("mainMenu")

	for k,v in ipairs(vehicleCustomisation) do 
		local validMods,amountValidMods = CheckValidMods(v["category"],v["id"])
		local currentMod,currentModName = GetCurrentMod(v["id"])

		if amountValidMods > 0 or v["id"] == 18 then
			if v["id"] == 11 or v["id"] == 12 or v["id"] == 13 or v["id"] == 15 or v["id"] == 16 then
				local tempNum = 0

				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"],"Escolha um Upgrade")

				for m,n in pairs(validMods) do
					tempNum = tempNum + 1

					populateMenu(v["category"]:gsub("%s+","").."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices[v["type"]][tempNum])

					if currentMod == n["id"] then
						updateItem2Text(v["category"]:gsub("%s+","").."Menu",n["id"],"Instalado")
					end
				end

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			elseif v["id"] == 18 then
				local currentTurboState = GetCurrentTurboState()
				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"].." Customizacao","Ativar / Desativar turbo")

				populateMenu(v["category"]:gsub("%s+","").."Menu",0,"Desativado","$7500")
				populateMenu(v["category"]:gsub("%s+","").."Menu",1,"Ativado","$"..vehicleCustomisationPrices["turbo"])

				updateItem2Text(v["category"]:gsub("%s+","").."Menu",currentTurboState,"Instalado")

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			else
				createMenu(v["category"]:gsub("%s+","").."Menu",v["category"].." Customizacao","Escolha uma Modificação")

				for m,n in pairs(validMods) do
					populateMenu(v["category"]:gsub("%s+","").."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["cosmetics"])

					if currentMod == n["id"] then
						updateItem2Text(v["category"]:gsub("%s+","").."Menu",n["id"],"Instalado")
					end
				end

				finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
			end
		end
	end

	createMenu("RepinturaMenu","Repintura","Escolha uma Categoria de Cor")

	populateMenu("RepinturaMenu", 0, "Cor Primária", "none")
	populateMenu("RepinturaMenu", 1, "Cor Secundária", "none")
	populateMenu("RepinturaMenu", 2, "Cor Perolada", "none")
	populateMenu("RepinturaMenu", 3, "Cor das Rodas", "none")
	populateMenu("RepinturaMenu", 4, "Cor do Painel", "none")
	populateMenu("RepinturaMenu", 5, "Cor Interna", "none")
	

	finishPopulatingMenu("RepinturaMenu")

	createMenu("RepinturaTypeMenu","Repintura Types","Escolha um tipo de cor")

	for k,v in ipairs(vehicleRepinturaOptions) do
		populateMenu("RepinturaTypeMenu",v["id"],v["category"],"none")
	end

	finishPopulatingMenu("RepinturaTypeMenu")

	for k,v in ipairs(vehicleRepinturaOptions) do 
		createMenu(v["category"].."Menu",v["category"],"Escolha uma cor")

		for m,n in ipairs(v["colours"]) do
			populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["respray"])
		end

		finishPopulatingMenu(v["category"].."Menu")
	end

	createMenu("RodasMenu","Wheel Categories","Escolha uma Categoria")

	for k,v in ipairs(vehicleWheelOptions) do 
		if isMotorcycle then
			if v["id"] == -1 or v["id"] == 20 or v["id"] == 6 then
				populateMenu("RodasMenu",v["id"],v["category"],"none")
			end
		else
			populateMenu("RodasMenu",v["id"],v["category"],"none")
		end
	end

	finishPopulatingMenu("RodasMenu")

	for k,v in ipairs(vehicleWheelOptions) do 
		if v["id"] == -1 then
			local currentCustomWheelState = GetCurrentCustomWheelState()
			createMenu(v["category"]:gsub("%s+","").."Menu",v["category"],"Ativar / Desativar rodas")

			populateMenu(v["category"]:gsub("%s+","").."Menu",0,"Desativado","$0")
			populateMenu(v["category"]:gsub("%s+","").."Menu",1,"Ativado","$"..vehicleCustomisationPrices["customwheels"])

			updateItem2Text(v["category"]:gsub("%s+","").."Menu",currentCustomWheelState,"Instalado")

			finishPopulatingMenu(v["category"]:gsub("%s+","").."Menu")
		elseif v["id"] ~= 20 then
			if isMotorcycle then
				if v["id"] == 6 then
					local validMods,amountValidMods = CheckValidMods(v["category"],v.wheelID,v["id"])

					createMenu(v["category"].."Menu",v["category"].." Rodas","Escolha uma Roda")

					for m,n in pairs(validMods) do
						populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["wheels"])
					end

					finishPopulatingMenu(v["category"].."Menu")
				end
			else
				local validMods,amountValidMods = CheckValidMods(v["category"],v.wheelID,v["id"])

				createMenu(v["category"].."Menu",v["category"].." Rodas","Escolha uma Roda")

				for m,n in pairs(validMods) do
					populateMenu(v["category"].."Menu",n["id"],n["name"],"$"..vehicleCustomisationPrices["wheels"])
				end

				finishPopulatingMenu(v["category"].."Menu")
			end
		end
	end

	local currentWheelSmokeR,currentWheelSmokeG,currentWheelSmokeB = GetCurrentVehicleWheelSmokeColour()
	createMenu("FumacadosPneusMenu","Fumaca dos Pneus Customizacao","Escolha uma cor")

	for k,v in ipairs(vehicleFumacadosPneusOptions) do
		populateMenu("FumacadosPneusMenu",k,v["name"],"$"..vehicleCustomisationPrices["wheelsmoke"])

		if v["r"] == currentWheelSmokeR and v["g"] == currentWheelSmokeG and v["b"] == currentWheelSmokeB then
			updateItem2Text("FumacadosPneusMenu",k,"Instalado")
		end
	end

	finishPopulatingMenu("FumacadosPneusMenu")

	local currentPeliculadeVidro = GetCurrentPeliculadeVidro()
	createMenu("PeliculadeVidroMenu","Pelicula de Vidro Customizacao","Escolha uma Tonalidade")

	for k,v in ipairs(vehiclePeliculadeVidroOptions) do
		populateMenu("PeliculadeVidroMenu",v["id"],v["name"],"$"..vehicleCustomisationPrices["windowtint"])

		if currentPeliculadeVidro == v["id"] then
			updateItem2Text("PeliculadeVidroMenu",v["id"],"Instalado")
		end
	end

	finishPopulatingMenu("PeliculadeVidroMenu")

	local temporaryPlate = GetVehicleNumberPlateTextIndex(vehicle)
	createMenu("PlacasMenu","Plate Colour","Escolha o tipo")

	local plateTypes = {
		"San Andreas Cosmo",
		"San Andreas Supermesh",
		"San Andreas Outsider",
		"San Andreas Slicer",
		"San Andreas Elquatro",
		"San Andreas Dubbed"
	}

	for i = 0,#plateTypes - 1 do
		populateMenu("PlacasMenu",i,plateTypes[i+1],"$1000")

		if temporaryPlate == i then
			updateItem2Text("PlacasMenu",i,"Instalado")
		end
	end
	finishPopulatingMenu("PlacasMenu")

	createMenu("VeiculoExtrasMenu","Veiculo Extras Customizacao","Toggle Extras")

	for i = 1,12 do
		if DoesExtraExist(vehicle,i) then
			if IsVehicleExtraTurnedOn(vehicle,i) then
				populateMenu("VeiculoExtrasMenu",i,"Extra 0"..i,"Ativado")
			else
				populateMenu("VeiculoExtrasMenu",i,"Extra 0"..i,"Desativado")
			end
		end
	end

	finishPopulatingMenu("VeiculoExtrasMenu")

	createMenu("NeonsMenu","Neon Customizacao","Escolha uma Categoria")

	for k,v in ipairs(vehicleNeonOptions["neonTypes"]) do
		populateMenu("NeonsMenu",v["id"],v["name"],"none")
	end

	populateMenu("NeonsMenu",-1,"Neon Cores","none")
	finishPopulatingMenu("NeonsMenu")

	for k,v in ipairs(vehicleNeonOptions["neonTypes"]) do
		local currentNeonState = GetCurrentNeonState(v["id"])
		createMenu(v["name"]:gsub("%s+","").."Menu","Neon Customizacao","Ativar / Desativar Neon")

		populateMenu(v["name"]:gsub("%s+","").."Menu",0,"Desativado","$0")
		populateMenu(v["name"]:gsub("%s+","").."Menu",1,"Ativado","$"..vehicleCustomisationPrices["neonside"])

		updateItem2Text(v["name"]:gsub("%s+","").."Menu",currentNeonState,"Instalado")

		finishPopulatingMenu(v["name"]:gsub("%s+","").."Menu")
	end

	local currentNeonR,currentNeonG,currentNeonB = GetCurrentNeonColour()
	createMenu("NeonCoresMenu","Neon Cores","Escolha uma cor")

	for k,v in ipairs(vehicleNeonOptions["neonCores"]) do
		populateMenu("NeonCoresMenu",k,vehicleNeonOptions["neonCores"][k]["name"],"$"..vehicleCustomisationPrices["neoncolours"])

		if currentNeonR == vehicleNeonOptions["neonCores"][k]["r"] and currentNeonG == vehicleNeonOptions["neonCores"][k]["g"] and currentNeonB == vehicleNeonOptions["neonCores"][k]["b"] then
			updateItem2Text("NeonCoresMenu",k,"Instalado")
		end
	end

	finishPopulatingMenu("NeonCoresMenu")

	createMenu("XenonsMenu","Xenon Customizacao","Escolha a categoria")

	populateMenu("XenonsMenu",0,"Farois","none")
	populateMenu("XenonsMenu",1,"Xenon Cores","none")

	finishPopulatingMenu("XenonsMenu")

	local currentXenonState = GetCurrentXenonState()
	createMenu("FaroisMenu","Farois Customizacao","Ativar / Desativar Xenons")

	populateMenu("FaroisMenu",0,"Desativado","$0")
	populateMenu("FaroisMenu",1,"Ativado","$"..vehicleCustomisationPrices["headlights"])

	updateItem2Text("FaroisMenu",currentXenonState,"Instalado")

	finishPopulatingMenu("FaroisMenu")

	local currentXenonColour = GetCurrentXenonColour()
	createMenu("XenonCoresMenu","Xenon Cores","Escolha uma cor")

	for k,v in ipairs(vehicleXenonOptions["xenonCores"]) do
		populateMenu("XenonCoresMenu",v["id"],v["name"],"$"..vehicleCustomisationPrices["xenoncolours"])

		if currentXenonColour == v["id"] then
			updateItem2Text("XenonCoresMenu",v["id"],"Instalado")
		end
	end

	finishPopulatingMenu("XenonCoresMenu")
end

function DestroyMenus()
	destroyMenus()
end

function DisplayMenuContainer(state)
	toggleMenuContainer(state)
end

function DisplayMenu(state,menu)
	if state then
		currentMenu = menu
	end

	toggleMenu(state,menu)
	updateMenuHeading(menu)
	updateMenuSubheading(menu)
end

function MenuManager(state)
	if state then
		if currentMenuItem2 ~= "Instalado" then
			if isMenuActive("modMenu") then
				if currentCategory == 18 then
					if AttemptPurchase("turbo") then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentCategory == 11 then
					if AttemptPurchase("engines",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentCategory == 12 then
					if AttemptPurchase("brakes",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentCategory == 13 then
					if AttemptPurchase("transmission",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentCategory == 15 then
					if AttemptPurchase("suspension",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentCategory == 16 then
					if AttemptPurchase("shield",currentMenuItemID) then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				else
					if AttemptPurchase("cosmetics") then
						ApplyMod(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				end
			elseif isMenuActive("RepinturaMenu") then
				if AttemptPurchase("respray") then
					ApplyColour(currentRepinturaCategory,currentRepinturaType,currentMenuItemID)
					playSoundEffect("respray",1.0)
					updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
					updateMenuStatus("Comprado")
				else
					updateMenuStatus("Dólares insuficientes.")
				end
			elseif isMenuActive("RodasMenu") then
				if currentWheelCategory == 20 then
					if AttemptPurchase("wheelsmoke") then
						local r = vehicleFumacadosPneusOptions[currentMenuItemID]["r"]
						local g = vehicleFumacadosPneusOptions[currentMenuItemID]["g"]
						local b = vehicleFumacadosPneusOptions[currentMenuItemID]["b"]

						ApplyFumacadosPneus(r,g,b)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				else
					if currentWheelCategory == -1 then
						local currentWheel = GetCurrentWheel()

						if currentWheel == -1 then
							updateMenuStatus("Can't Apply Custom Tyres to Stock Rodas")
						else
							if AttemptPurchase("customwheels") then
								ApplyCustomWheel(currentMenuItemID)
								playSoundEffect("wrench",0.25)
								updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
								updateMenuStatus("Comprado")
							else
								updateMenuStatus("Dólares insuficientes.")
							end
						end
					else
						local currentWheel = GetCurrentWheel()
						local currentCustomWheelState = GetOriginalCustomWheel()

						if currentCustomWheelState and currentWheel == -1 then
							updateMenuStatus("Can't Apply Stock Rodas With Custom Tyres")
						else
							if AttemptPurchase("wheels") then
								ApplyWheel(currentCategory,currentMenuItemID,currentWheelCategory)
								playSoundEffect("wrench",0.25)
								updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
								updateMenuStatus("Comprado")
							else
								updateMenuStatus("Dólares insuficientes.")
							end
						end
					end
				end
			elseif isMenuActive("NeonsSideMenu") then
				if AttemptPurchase("neonside") then
					playSoundEffect("wrench",0.25)
					ApplyNeon(currentNeonSide,currentMenuItemID)
					updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
					updateMenuStatus("Comprado")
				else
					updateMenuStatus("Dólares insuficientes.")
				end 
			else
				if currentMenu == "mainMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentCategory = currentMenuItemID
					toggleMenu(false,"mainMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "RepinturaMenu" then
					currentMenu = "RepinturaTypeMenu"
					currentRepinturaCategory = currentMenuItemID

					toggleMenu(false,"RepinturaMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "RepinturaTypeMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentRepinturaType = currentMenuItemID

					toggleMenu(false,"RepinturaTypeMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "RodasMenu" then
					local currentWheel,currentWheelName,currentWheelType = GetCurrentWheel()

					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentWheelCategory = currentMenuItemID

					if currentWheelType == currentWheelCategory then
						updateItem2Text(currentMenu,currentWheel,"Instalado")
					end

					toggleMenu(false,"RodasMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "NeonsMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"
					currentNeonSide = currentMenuItemID

					toggleMenu(false,"NeonsMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "XenonsMenu" then
					currentMenu = currentMenuItem:gsub("%s+","").."Menu"

					toggleMenu(false,"XenonsMenu")
					toggleMenu(true,currentMenu)
					updateMenuHeading(currentMenu)
					updateMenuSubheading(currentMenu)
				elseif currentMenu == "PeliculadeVidroMenu" then
					if AttemptPurchase("windowtint") then
						ApplyPeliculadeVidro(currentMenuItemID)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentMenu == "NeonCoresMenu" then
					if AttemptPurchase("neoncolours") then
						local r = vehicleNeonOptions["neonCores"][currentMenuItemID]["r"]
						local g = vehicleNeonOptions["neonCores"][currentMenuItemID]["g"]
						local b = vehicleNeonOptions["neonCores"][currentMenuItemID]["b"]

						ApplyNeonColour(r,g,b)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentMenu == "FaroisMenu" then
					if AttemptPurchase("headlights") then
						ApplyXenonLights(currentCategory,currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentMenu == "XenonCoresMenu" then
					if AttemptPurchase("xenoncolours") then
						ApplyXenonColour(currentMenuItemID)
						playSoundEffect("respray",1.0)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentMenu == "PoliceLiveryMenu" then
					if AttemptPurchase("policelivery") then
						ApplyPoliceLivery(currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")   
					end
				elseif currentMenu == "PlacasMenu" then
					if AttemptPurchase("plateindex") then
						ApplyPlacas(currentMenuItemID)
						playSoundEffect("wrench",0.25)
						updateItem2Text(currentMenu,currentMenuItemID,"Instalado")
						updateMenuStatus("Comprado")
					else
						updateMenuStatus("Dólares insuficientes.")
					end
				elseif currentMenu == "VeiculoExtrasMenu" then
					ApplyExtra(currentMenuItemID)
					playSoundEffect("wrench",0.25)

					local Ped = PlayerPedId()
					local vehicle = GetVehiclePedIsUsing(Ped)
					if IsVehicleExtraTurnedOn(vehicle,currentMenuItemID) then
						updateItem2TextOnly(currentMenu,currentMenuItemID,"Ativado")
						updateMenuStatus("Ativado")
					else
						updateItem2TextOnly(currentMenu,currentMenuItemID,"Desativado")
						updateMenuStatus("Desativado")
					end
				end
			end
		else
			if currentMenu == "VeiculoExtrasMenu" then
				ApplyExtra(currentMenuItemID)
				playSoundEffect("wrench",0.25)

				local Ped = PlayerPedId()
				local vehicle = GetVehiclePedIsUsing(Ped)
				if IsVehicleExtraTurnedOn(vehicle,currentMenuItemID) then
					updateItem2TextOnly(currentMenu,currentMenuItemID,"Ativado")
					updateMenuStatus("Ativado")
				else
					updateItem2TextOnly(currentMenu,currentMenuItemID,"Desativado")
					updateMenuStatus("Desativado")
				end
			end
		end
	else
		updateMenuStatus("")

		if isMenuActive("modMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "mainMenu"

			if currentCategory ~= 18 then
				RestoreOriginalMod()
			end

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("RepinturaMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "RepinturaTypeMenu"

			RestoreOriginalCores()

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("RodasMenu") then            
			if currentWheelCategory ~= 20 and currentWheelCategory ~= -1 then
				local currentWheel = GetOriginalWheel()

				updateItem2Text(currentMenu,currentWheel,"$"..vehicleCustomisationPrices["wheels"])

				RestoreOriginalRodas()
			end

			toggleMenu(false,currentMenu)

			currentMenu = "RodasMenu"

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		elseif isMenuActive("NeonsSideMenu") then
			toggleMenu(false,currentMenu)

			currentMenu = "NeonsMenu"

			RestoreOriginalNeonStates()

			toggleMenu(true,currentMenu)
			updateMenuHeading(currentMenu)
			updateMenuSubheading(currentMenu)
		else
			if currentMenu == "mainMenu" then
				ExitBennys()
			elseif currentMenu == "RepinturaMenu" or currentMenu == "PeliculadeVidroMenu" or currentMenu == "RodasMenu" or currentMenu == "NeonsMenu" or currentMenu == "XenonsMenu" or currentMenu == "PoliceLiveryMenu" or currentMenu == "PlacasMenu" or currentMenu == "VeiculoExtrasMenu" then
				toggleMenu(false,currentMenu)

				if currentMenu == "PeliculadeVidroMenu" then
					RestoreOriginalPeliculadeVidro()
				end

				if currentMenu == "PoliceLiveryMenu" then
					RestorePoliceLivery()
				end

				if currentMenu == "PlacasMenu" then
					RestorePlacas()
				end

				currentMenu = "mainMenu"

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "RepinturaTypeMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "RepinturaMenu"

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "NeonCoresMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "NeonsMenu"

				RestoreOriginalNeonCores()

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "FaroisMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "XenonsMenu"

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			elseif currentMenu == "XenonCoresMenu" then
				toggleMenu(false,currentMenu)

				currentMenu = "XenonsMenu"

				RestoreOriginalXenonColour()

				toggleMenu(true,currentMenu)
				updateMenuHeading(currentMenu)
				updateMenuSubheading(currentMenu)
			end
		end
	end
end

function MenuScrollFunctionality(direction)
	scrollMenuFunctionality(direction,currentMenu)
end

RegisterNUICallback("selectedItem",function(Data,Callback)
	updateCurrentMenuItemID(tonumber(Data["id"]),Data["item"],Data["item2"])
	Callback("Ok")
end)

RegisterNUICallback("updateItem2",function(Data,Callback)
	currentMenuItem2 = Data["item"]
	Callback("Ok")
end)