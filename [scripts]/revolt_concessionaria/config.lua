local Tunnel = module("revolt","lib/Tunnel")
local Proxy = module("revolt","lib/Proxy")
rEVOLT = Proxy.getInterface("rEVOLT")

config = {}
Proxy.addInterface("revolt_concessionaria", config)

config.imgDir = "https://docs.fivem.net/vehicles/" -- URL base das imagens (altere se quiser)

config.topVehicles = {	 
	"panto",
	"kuruma"
}

config.logo = "https://cdn.discordapp.com/attachments/1011084224645824562/1270936113183195186/Maze_Store_Logo.png?ex=66b582fe&is=66b4317e&hm=339bc3c9983b5cdbc6b51c11070e6f068dfd6d215e4a607105b3529de17fbffa&" 
config.defaultImg = "https://svgsilh.com/svg/160895.svg" 
config.openconce_permission = nil 
config.updateconce_permission = "dono.permissao" 
config.porcentagem_venda = 75 
config.porcentagem_testdrive = 0.01
config.tempo_testdrive = 90 
config.maxDistance = 300 
config.porcentagem_aluguel = 1 

config.conceClasses = {
	{ class = "sedans", img = "https://img.indianautosblog.com/2018/09/25/india-bound-2019-honda-civic-images-front-three-qu-e966.jpg" },
	{ class = "suvs", img = "https://i.pinimg.com/736x/91/13/80/91138078a0d5ec38d745cbc906ebe61c.jpg" },
	{ class = "imports", img = "https://besthqwallpapers.com/Uploads/25-6-2019/97150/thumb2-lamborghini-gallardo-supercars-motion-blur-road-gray-gallardo.jpg" },
	{ class = "trucks", img = "https://img.freepik.com/fotos-premium/foto-de-caminhao-grande-de-18-rodas-para-design-grafico-de-plano-de-fundo-ou-impressao_800563-4570.jpg" },
	{ class = "motos", img = "https://i.pinimg.com/originals/cc/92/dd/cc92dda56f23a2a41682e80e7fe0f744.jpg" },
	{ class = "outros", img = "https://besthqwallpapers.com/Uploads/13-5-2018/52433/thumb2-ford-transit-custom-sport-4k-2018-cars-motion-blur-orange-ford-transit.jpg" },
}

config.myVehicles_img = "https://www.itl.cat/pngfile/big/50-505834_download-nfs-hot-pursuit.jpg"

config.availableClasses = {
	["sedans"] = {"sedan"},
	["suvs"] = {"suv"},
	["imports"] = {"classic", "sport", "super"},  
	["trucks"] = {"industrial", "utility", "commercial"},
	["motos"] = {"moto", "cycle"},
	["outros"] = {"compact", "coupé", "muscle", "off-road",  "boat",  "helicopter",  "plane",  "service", "emergency",  "military",  "train", "van"}
}

-- ÍCONES DA CONCE

config.miscIcons = {
	{ description = "Força e velocidade necessárias para aquela dose de adrenalina.", img = "https://cdn.discordapp.com/attachments/1011084224645824562/1270941071269953589/motor-removebg-preview.png?ex=66b5879c&is=66b4361c&hm=e92eb570faa89849d787159031699b7ab174e875560e9530cbd857fa4235c22b&" },
	{ description = "Incríveis opções econômicas que cabem no seu bolso!", img = "https://images.vexels.com/media/users/3/145753/isolated/preview/cc87af32e3beef17b5e349cec667bda5-captura-de-saco-de-dinheiro.png" },
	{ description = "Para você que valoriza a eficácia e praticidade.", img = "https://cdn.discordapp.com/attachments/1011084224645824562/1270941494907371571/velo-removebg-preview.png?ex=66b58801&is=66b43681&hm=c5ad948ac2977f26ffb6ffd9d1b6f5ea590a19e2c53dc528e8e0ee907b4c610a&" },
}

config.descontos = {
	{ perm = "bronze.permissao", porcentagem =  5 },
	{ perm = "prata.permissao", porcentagem = 10 },
	{ perm = "ouro.permissao", porcentagem = 15 },
	{ perm = "platina.permissao", porcentagem = 20 },
	{ perm = "diamante.permissao", porcentagem = 25 }
}

config.getVehList = function()
	return exports['nation_garages']:getVehicleList()
end

config.getVehicleInfo = function(vehicle)
	return exports['nation_garages']:getVehicleInfo(vehicle)
end

config.getVehicleModel = function(vehicle)
	return exports['nation_garages']:getVehicleModelName(vehicle)
end

config.getVehicleTrunk = function(vehicle)
	return exports['nation_garages']:getVehicleTrunk(vehicle)
end

config.getVehiclePrice = function(vehicle)
	return exports['nation_garages']:getVehiclePrice(vehicle)
end

config.getVehicleType = function(vehicle)
	return exports['nation_garages']:getVehicleType(vehicle)
end

config.isVehicleBanned = function(vehicle)
	return exports['nation_garages']:getVehicleBan(vehicle)
end

config.getVehicleInfo = function(vehicle)
	return exports['nation_garages']:getVehicleInfo(vehicle)
end

function getConceList(cb)
	Citizen.CreateThread(function()
		local vehicles = rEVOLT.Query("revolt_conce/getConceVehicles") or {}
		cb(vehicles)
	end)
end

function getTopList()
	getConceList(function(list)
		local vehicleList = {}
		for k,v in ipairs(list) do
			local vehInfo = config.getVehicleInfo(v.vehicle)
			if vehInfo then
				vehicleList[#vehicleList+1] = { 
					vehicle = v.vehicle, price = vehInfo.price
				}
			end
		end
		if #vehicleList >= 5 then
			table.sort(vehicleList, function(a, b) return a.price > b.price end)
			for i = 1, 5 do
				local veh = vehicleList[i]
				config.topVehicles[i] = veh.vehicle 
			end
		end
	end)
end

config.vehicleClasses = {
	[0] = "compact",  
	[1] = "sedan",  
	[2] = "suv",  
	[3] = "coupé",  
	[4] = "muscle",  
	[5] = "classic",  
	[6] = "sport",  
	[7] = "super",  
	[8] = "moto",  
	[9] = "off-road",  
	[10] = "industrial",  
	[11] = "utility",
	[12] = "van",
	[13] = "cycle",  
	[14] = "boat",  
	[15] = "helicopter",  
	[16] = "plane",  
	[17] = "service", 
	[18] = "emergency",  
	[19] = "military",  
	[20] = "commercial",  
	[21] = "train" 
}

config.tryBuyVehicle = function(source, user_id, vehicle, color, price, mods)
	if source and user_id and vehicle and color and price and mods then
		local data = rEVOLT.Query("revolt_conce/hasVehicle", {user_id = user_id, vehicle = vehicle})
		local hasVehicle = #data > 0
		local isRented = data[1] and data[1].alugado > 0
		if hasVehicle and not isRented then
			return false, "veículo já possuído"
		end
		if rEVOLT.tryPayment(user_id,price) then
			Citizen.CreateThread(function()
				if isRented then
					rEVOLT.Execute("revolt_conce/updateUserVehicle", {
						user_id = user_id, vehicle = vehicle
					})
				else 
					rEVOLT.Execute("revolt_conce/addUserVehicle", {
						user_id = user_id, vehicle = vehicle, detido = 0, time = 0, engine = 1000, body = 1000, fuel = 100, ipva = os.time()
					})
				end
				mods.customPcolor = color
				rEVOLT.setSData("custom:u"..user_id.."veh_"..vehicle,json.encode(mods))
			end)
			return true, "sucesso!"
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end

config.trySellVehicle = function(source, user_id, vehicle, price)
	if source and user_id and vehicle and price then
		local hasVehicle = #rEVOLT.Query("revolt_conce/hasFullVehicle", {user_id = user_id, vehicle = vehicle}) > 0
		if hasVehicle then
			Citizen.CreateThread(function()
				rEVOLT.Execute("revolt_conce/removeUserVehicle", {user_id = user_id, vehicle = vehicle})
				rEVOLT.giveMoney(user_id,parseInt(price))
			end)
			return true, "sucesso!"
		else
			return false, "veículo alugado ou já vendido"
		end
	end
	return false, "erro inesperado"
end

config.tryTestDrive = function(source, user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_testdrive / 100))
		return true, "deseja pagar <b>$ "..rEVOLT.format(price).."</b> para realizar o test drive em um(a) <b>"..info.modelo.."</b> ?"
	end
	return false, "erro inesperado"
end

config.payTest = function(source,user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_testdrive / 100))
		if rEVOLT.tryFullPayment(user_id, price) then
			return true, "sucesso!", price
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end

config.chargeBack = function(source,user_id, price)
	if source and user_id and price then
		rEVOLT.giveMoney(user_id,price)
		TriggerClientEvent("Notify",source,"aviso", "Você recebeu seus <b>$ "..rEVOLT.format(price).."</b> de volta.", 3000)
	end
end

config.tryRentVehicle = function(source, user_id, info)
	if source and user_id and info then
		local hasVehicle = #rEVOLT.Query("revolt_conce/hasVehicle", {user_id = user_id, vehicle = info.name}) > 0
		if hasVehicle then
			return false, "veículo já possuído"
		end
		local price = parseInt(info.price * (config.porcentagem_aluguel / 100))
		return true, "deseja pagar <b>$ "..rEVOLT.format(price).."</b> para alugar um(a) <b>"..info.modelo.."</b> por 1 dia?"
	end
	return false, "erro inesperado"
end

config.tryPayRent = function(source,user_id, info)
	if source and user_id and info then
		local price = parseInt(info.price * (config.porcentagem_aluguel / 100))
		if rEVOLT.tryFullPayment(user_id, price) then
			Citizen.CreateThread(function()
				rEVOLT.Execute("revolt_conce/addUserRentedVehicle", {
					user_id = user_id, vehicle = info.name, detido = 0, time = 0, engine = 1000, body = 1000, fuel = 100, ipva = os.time(), data_alugado = os.date("%d/%m/%Y")
				})
			end)
			return true, "sucesso!"
		else
			return false, "falha no pagamento"
		end
	end
	return false, "erro inesperado"
end

getTopList()

config.locais = {
	{ 
		conce = vec3(-40.08,-1097.21,26.42), 
		test_locais = {
			{ coords = vec3(-11.25,-1080.46,26.68), h = 129.4 },
			{ coords = vec3(-14.11,-1079.84,26.67), h = 122.02 },
			{ coords = vec3(-16.43,-1078.62,26.67), h = 126.74 },
			{ coords = vec3(-8.45,-1081.58,26.67), h = 117.45 },
		}
	},
	{ 
		conce = vec3(-1123.49,-1708.12,4.45),
		test_locais = {
			{ coords = vec3(-1177.30,-1743.51,4.04), h = 204.54 },
			{ coords = vec3(-1173.95,-1741.34,4.05), h = 212.41 },
			{ coords = vec3(-1171.41,-1739.55,4.07), h = 210.01 },
		} 
	},
}

