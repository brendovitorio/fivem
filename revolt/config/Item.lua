-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
local List = {
	["dmvdocs"] = {
		["Index"] = "dmvdocs",
		["Name"] = "Documentos Dmv",
		["Description"] = "Departamento de Veículos Motorizados",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["newspaper"] = {
		["Index"] = "newspaper",
		["Name"] = "Jornal",
		["Description"] = "Notícias em mãos",
		["Type"] = "Usável",
		["Weight"] = 0.10,
		["Economy"] = 0
	},

	["deerration"] = {
		["Index"] = "deerration",
		["Name"] = "Isca de caça",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 125
	},
	["deerantlers"] = {
		["Index"] = "deerantlers",
		["Name"] = "Chifres de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 225
	},
	["deerpelt"] = {
		["Index"] = "deerpelt",
		["Name"] = "Couro de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 225
	},
	["deerpelt2"] = {
		["Index"] = "deerpelt2",
		["Name"] = "Couro de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 375
	},
	["deerpelt3"] = {
		["Index"] = "deerpelt3",
		["Name"] = "Couro de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 575
	},
	["deerpelt4"] = {
		["Index"] = "deerpelt4",
		["Name"] = "Couro de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 575
	},
	["deerpelt5"] = {
		["Index"] = "deerpelt5",
		["Name"] = "Couro de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 575
	},
	["deermeat"] = {
		["Index"] = "deermeat",
		["Name"] = "Carne de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 16
	},
	["deermeat2"] = {
		["Index"] = "deermeat2",
		["Name"] = "Carne de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 16
	},
	["deermeat3"] = {
		["Index"] = "deermeat3",
		["Name"] = "Carne de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 16
	},
	["deermeat4"] = {
		["Index"] = "deermeat4",
		["Name"] = "Carne de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 16
	},
	["deermeat5"] = {
		["Index"] = "deermeat5",
		["Name"] = "Carne de Cervo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 16
	},

	["postcard"] = {
		["Index"] = "postcard",
		["Name"] = "Cartão Postal",
		["Description"] = "Um cartão ilustrado para enviar mensagens rápidas.",
		["Type"] = "Usável",
		["Weight"] = 0.5,
		["Economy"] = 0
	},
	["postenvelope"] = {
		["Index"] = "postenvelope",
		["Name"] = "Envelope Postal",
		["Description"] = "Recipiente de papel para enviar documentos.",
		["Type"] = "Usável",
		["Weight"] = 0.10,
		["Economy"] = 0
	},
	["postbox"] = {
		["Index"] = "postbox",
		["Name"] = "Caixa Postal",
		["Description"] = "Caixa para armazenar e enviar itens variados.",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	

	["gift"] = {
		["Index"] = "gift",
		["Name"] = "Presente",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0,
		["Block"] = true
	},
	["medicplan"] = {
		["Index"] = "medicplan",
		["Name"] = "Plano de Saúde",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["creditcard"] = {
		["Index"] = "creditcard",
		["Name"] = "Cartão de Crédito",
		["Description"] = "A chave para o reino das compras impulsivas!",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["debitcard"] = {
		["Index"] = "debitcard",
		["Name"] = "Cartão de Débito",
		["Description"] = "Você só gasta o que tem. Sem dramas!",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["diagram"] = {
		["Index"] = "diagram",
		["Name"] = "Diagrama",
		["Type"] = "Comum",
		["Weight"] = 0.75
	},
	["propertys"] = {
		["Index"] = "propertys",
		["Name"] = "Cartão de Segurança",
		["Type"] = "Comum",
		["Weight"] = 0.35
	},
	["megaphone"] = {
		["Index"] = "megaphone",
		["Name"] = "Megafone",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 3.25
	},
	["sprays01"] = {
		["Index"] = "sprays",
		["Name"] = "Spray",
		["Type"] = "Usável",
		["Weight"] = 0.75
	},
	["enginea"] = {
		["Index"] = "enginea",
		["Name"] = "Motor",
		["Type"] = "Usável",
		["Economy"] = 15000,
		["Weight"] = 9.25
	},
	["engineb"] = {
		["Index"] = "engineb",
		["Name"] = "Motor",
		["Type"] = "Usável",
		["Economy"] = 17500,
		["Weight"] = 10.25
	},
	["enginec"] = {
		["Index"] = "enginec",
		["Name"] = "Motor",
		["Type"] = "Usável",
		["Economy"] = 20000,
		["Weight"] = 11.25
	},
	["engined"] = {
		["Index"] = "engined",
		["Name"] = "Motor",
		["Type"] = "Usável",
		["Economy"] = 22500,
		["Weight"] = 12.25
	},
	["enginee"] = {
		["Index"] = "enginee",
		["Name"] = "Motor",
		["Type"] = "Usável",
		["Economy"] = 25000,
		["Weight"] = 13.25
	},
	["transmissiona"] = {
		["Index"] = "transmissiona",
		["Name"] = "Transmissão",
		["Type"] = "Usável",
		["Economy"] = 15000,
		["Weight"] = 9.25
	},
	["transmissionb"] = {
		["Index"] = "transmissionb",
		["Name"] = "Transmissão",
		["Type"] = "Usável",
		["Economy"] = 17500,
		["Weight"] = 10.25
	},
	["transmissionc"] = {
		["Index"] = "transmissionc",
		["Name"] = "Transmissão",
		["Type"] = "Usável",
		["Economy"] = 20000,
		["Weight"] = 11.25
	},
	["transmissiond"] = {
		["Index"] = "transmissiond",
		["Name"] = "Transmissão",
		["Type"] = "Usável",
		["Economy"] = 22500,
		["Weight"] = 12.25
	},
	["transmissione"] = {
		["Index"] = "transmissione",
		["Name"] = "Transmissão",
		["Type"] = "Usável",
		["Economy"] = 25000,
		["Weight"] = 13.25
	},
	["brakea"] = {
		["Index"] = "brakea",
		["Name"] = "Freios",
		["Type"] = "Usável",
		["Economy"] = 15000,
		["Weight"] = 7.25
	},
	["brakeb"] = {
		["Index"] = "brakeb",
		["Name"] = "Freios",
		["Type"] = "Usável",
		["Economy"] = 17500,
		["Weight"] = 8.25
	},
	["brakec"] = {
		["Index"] = "brakec",
		["Name"] = "Freios",
		["Type"] = "Usável",
		["Economy"] = 20000,
		["Weight"] = 9.25
	},
	["braked"] = {
		["Index"] = "braked",
		["Name"] = "Freios",
		["Type"] = "Usável",
		["Economy"] = 22500,
		["Weight"] = 10.25
	},
	["brakee"] = {
		["Index"] = "brakee",
		["Name"] = "Freios",
		["Type"] = "Usável",
		["Economy"] = 25000,
		["Weight"] = 11.25
	},
	["suspensiona"] = {
		["Index"] = "suspensiona",
		["Name"] = "Suspensão",
		["Type"] = "Usável",
		["Economy"] = 15000,
		["Weight"] = 7.25
	},
	["suspensionb"] = {
		["Index"] = "suspensionb",
		["Name"] = "Suspensão",
		["Type"] = "Usável",
		["Economy"] = 17500,
		["Weight"] = 8.25
	},
	["suspensionc"] = {
		["Index"] = "suspensionc",
		["Name"] = "Suspensão",
		["Type"] = "Usável",
		["Economy"] = 20000,
		["Weight"] = 9.25
	},
	["suspensiond"] = {
		["Index"] = "suspensiond",
		["Name"] = "Suspensão",
		["Type"] = "Usável",
		["Economy"] = 22500,
		["Weight"] = 10.25
	},
	["suspensione"] = {
		["Index"] = "suspensione",
		["Name"] = "Suspensão",
		["Type"] = "Usável",
		["Economy"] = 25000,
		["Weight"] = 11.25
	},
	["dismantle"] = {
		["Index"] = "dismantle",
		["Name"] = "Contrato",
		["Description"] = "Ativando o mesmo você assume a responsabilidade com o <b>Lester</b> de desmanchar um veículo.",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 200
	},
	["repairkit01"] = {
		["Index"] = "repairkit01",
		["Name"] = "Kit de Reparos - Comum",
		["Type"] = "Comum",
		["Weight"] = 3.25,
		["Economy"] = 525
	},
	["repairkit02"] = {
		["Index"] = "repairkit02",
		["Name"] = "Kit de Reparos - Raro",
		["Type"] = "Comum",
		["Weight"] = 3.75,
		["Economy"] = 3225
	},
	["repairkit03"] = {
		["Index"] = "repairkit03",
		["Name"] = "Kit de Reparos - Épico",
		["Type"] = "Comum",
		["Weight"] = 4.25,
		["Economy"] = 7225
	},
	["repairkit04"] = {
		["Index"] = "repairkit04",
		["Name"] = "Kit de Reparos - Lendário",
		["Type"] = "Comum",
		["Weight"] = 5.75,
		["Economy"] = 15225
	},
	["receipt"] = {
		["Index"] = "receipt",
		["Name"] = "Recibo",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 120
	},
	["paper"] = {
		["Index"] = "paper",
		["Name"] = "Papel",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 120
	},
	["oilbarrel"] = {
		["Index"] = "oilbarrel",
		["Name"] = "Barril de Petróleo",
		["Type"] = "Comum",
		["Weight"] = 17.25,
		["Economy"] = 1875,
		["Max"] = 1
	},
	["oilgallon"] = {
		["Index"] = "oilgallon",
		["Name"] = "Galão de Petróleo",
		["Type"] = "Comum",
		["Durability"] = 7,
		["Weight"] = 5.25,
		["Economy"] = 875,
		["Max"] = 3
	},

	["backpackp"] = {
		["Index"] = "backpackp",
		["Name"] = "Mochila Pequena",
		["Description"] = "Aumenta <b>15 Kg</b> de capacidade.",
		["Type"] = "Usável",
		["Weight"] = 7.5,
		["Economy"] = 50000
	},
	["backpackm"] = {
		["Index"] = "backpackm",
		["Name"] = "Mochila Média",
		["Description"] = "Aumenta <b>25 Kg</b> de capacidade.",
		["Type"] = "Usável",
		["Weight"] = 10.0,
		["Economy"] = 75000
	},
	["backpackg"] = {
		["Index"] = "backpackg",
		["Name"] = "Mochila Grande",
		["Description"] = "Aumenta <b>30 Kg</b> de capacidade.",
		["Type"] = "Usável",
		["Weight"] = 12.5,
		["Economy"] = 100000
	},

	["luckywheelpass"] = {
		["Index"] = "luckywheelpass",
		["Name"] = "Vale - Roda da Fortuna",
		["Description"] = "Leve até o cassino para usa-lo.",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 5000
	},
	["c4"] = {
		["Index"] = "c4",
		["Name"] = "C4",
		["Type"] = "Usável",
		["Weight"] = 2.75,
		["Economy"] = 625
	},
	["geode"] = {
		["Index"] = "geode",
		["Name"] = "Geodo",
		["Type"] = "Usável",
		["Weight"] = 1.00,
		["Economy"] = 10
	},
	["WEAPON_CHAINSAW"] = {
		["Index"] = "chainsaw",
		["Name"] = "Motosserra",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 2.25,
		["Economy"] = 525
	},
	["pickaxe"] = {
		["Index"] = "pickaxe",
		["Name"] = "Picareta",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 2.25,
		["Economy"] = 525
	},
	["WEAPON_PICKAXE"] = {
		["Index"] = "pickaxe",
		["Name"] = "Picareta",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 2.25,
		["Economy"] = 725
	},
	["WEAPON_FLAMETHROWER"] = {
		["Index"] = "flamethrower",
		["Name"] = "Lança-Chamas",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "WEAPON_FLAMETHROWER_AMMO",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25250
	},
	["WEAPON_SHOVEL"] = {
		["Index"] = "shovel",
		["Name"] = "Pá",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 2.25,
		["Economy"] = 725
	},
	["jackham"] = {
		["Index"] = "jackham",
		["Name"] = "Britadeira",
		["Repair"] = "repairkit02",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 8.25,
		["Economy"] = 9525
	},
	["drillbit"] = {
		["Index"] = "drillbit",
		["Name"] = "Broca",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 75
	},
	["sewingkit"] = {
		["Index"] = "sewingkit",
		["Name"] = "Kit de Costura",
		["Description"] = "Utilizado para reparar mochilas <b>Pequenas</b>, <b>Médias</b> e <b>Grandes</b>.",
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 50000,
		["Clear"] = true
	},
	["skateboard"] = {
		["Index"] = "skateboard",
		["Name"] = "Skate",
		["Type"] = "Comum",
		["Weight"] = 2.25,
	},
	["boombox"] = {
		["Index"] = "boombox",
		["Name"] = "Boombox",
		["Type"] = "Comum",
		["Weight"] = 1.0,
		["Economy"] = 275,
	},
	["suitcase"] = {
		["Index"] = "suitcase",
		["Name"] = "Maleta",
		["Type"] = "Usável",
		["Weight"] = 1.0,
		["Economy"] = 275,
	},
	["badge01"] = {
		["Index"] = "badge01",
		["Name"] = "Distintivo",
		["Description"] = "Departamento de Polícia",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 10
	},
	["badge02"] = {
		["Index"] = "badge02",
		["Name"] = "Distintivo",
		["Description"] = "Centro Médico",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 10
	},
	["badge04"] = {
		["Index"] = "bluecard",
		["Name"] = "OAB",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 5000
	},
	["mushroomtea"] = {
		["Index"] = "mushroomtea",
		["Name"] = "Chá de Cogumelo",
		-- ["Description"] = "Tempo pedalando reduzido para <green>10 minutos</green> por <green>60 minutos</green>, lembrando que o efeito passa desconectando da cidade.",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 10,
		["Economy"] = 325
	},
	["nigirizushi"] = {
		["Index"] = "nigirizushi",
		["Name"] = "Nigirizushi",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.65,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 75
	},
	["sushi"] = {
		["Index"] = "sushi",
		["Name"] = "Sushi",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.65,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 75
	},
	["cupcake"] = {
		["Index"] = "cupcake",
		["Name"] = "Cupcake",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 75
	},
	["milkshake"] = {
		["Index"] = "milkshake",
		["Name"] = "Milk Shake",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.8555,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["cappuccino"] = {
		["Index"] = "cappuccino",
		["Name"] = "Cappuccino",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.65,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["applelove"] = {
		["Index"] = "applelove",
		["Name"] = "Maça do Amor",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Scape"] = true,
		["Max"] = 2,
		["Economy"] = 75
	},
	["credential"] = {
		["Index"] = "credential",
		["Name"] = "Credencial",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 800
	},
	["racetrophy"] = {
		["Index"] = "racetrophy",
		["Name"] = "Troféu",
		["Type"] = "Comum",
		["Weight"] = 7.25,
		["Economy"] = 2250
	},
	["scanner"] = {
		["Index"] = "scanner",
		["Name"] = "Scanner",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 4.75,
		["Economy"] = 6750
	},
	["nitro"] = {
		["Index"] = "nitro",
		["Name"] = "Nitro",
		["Type"] = "Usável",
		["Weight"] = 7.25,
		["Economy"] = 15000
	},
	["postit"] = {
		["Index"] = "postit",
		["Name"] = "Post-It",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 20
	},
	["ATTACH_FLASHLIGHT"] = {
		["Index"] = "attachsFlashlight",
		["Name"] = "Lanterna Tatica",
		["Type"] = "Usável",
		["Weight"] = 1.15,
		["Economy"] = 1750
	},
	["ATTACH_CROSSHAIR"] = {
		["Index"] = "attachsCrosshair",
		["Name"] = "Mira Holográfica",
		["Type"] = "Usável",
		["Weight"] = 1.15,
		["Economy"] = 1750
	},
	["ATTACH_SILENCER"] = {
		["Index"] = "attachsSilencer",
		["Name"] = "Silenciador",
		["Type"] = "Usável",
		["Weight"] = 1.15,
		["Economy"] = 12500
	},
	["ATTACH_MAGAZINE"] = {
		["Index"] = "attachsMagazine",
		["Name"] = "Pente Estendido",
		["Type"] = "Usável",
		["Weight"] = 1.15,
		["Economy"] = 1750
	},
	["ATTACH_GRIP"] = {
		["Index"] = "attachsGrip",
		["Name"] = "Empunhadura",
		["Type"] = "Usável",
		["Weight"] = 1.15,
		["Economy"] = 1750
	},
	-- ["attachsMazzleBrake"] = {
	-- 	["Index"] = "attachsMazzleBrake",
	-- 	["Name"] = "Quebra Chamas",
	-- 	["Type"] = "Usável",
	-- 	["Weight"] = 1.15,
	-- 	["Economy"] = 1750
	-- },
	-- ["attachsMazzleBoost"] = {
	-- 	["Index"] = "attachsMazzleBoost",
	-- 	["Name"] = "Compensador",
	-- 	["Type"] = "Usável",
	-- 	["Weight"] = 1.15,
	-- 	["Economy"] = 1750
	-- },
	["silk"] = {
		["Index"] = "silk",
		["Name"] = "Seda",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 5
	},
	["tablecoke"] = {
		["Index"] = "tablecoke",
		["Name"] = "Mesa de Criação",
		["Description"] = "Utilizada para criação de Cocaína.",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 12.75,
		["Economy"] = 1750
	},
	["lostfy"] = {
		["Index"] = "lostfy",
		["Name"] = "caixa de som",
		["Description"] = "Utilizada para escutar musica .",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 4,
		["Weight"] = 5.75,
		["Economy"] = 1750
	},
	["tablemeth"] = {
		["Index"] = "tablemeth",
		["Name"] = "Mesa de Criação",
		["Description"] = "Utilizada para criação de Metanfetamina.",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 12.75,
		["Economy"] = 1750
	},
	["tableweed"] = {
		["Index"] = "tableweed",
		["Name"] = "Mesa de Criação",
		["Description"] = "Utilizada para criação de Baseados.",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 12.75,
		["Economy"] = 1750
	},
	["campfire"] = {
		["Index"] = "campfire",
		["Name"] = "Fogueira",
		["Type"] = "Usável",
		["Weight"] = 5.75,
		["Economy"] = 675
	},
	["carwheelclamp"] = {
		["Index"] = "carwheelclamp",
		["Name"] = "Braçadeira de Roda",
		["Type"] = "Usável",
		["Weight"] = 1.25,
		["Economy"] = 250
	},
	["motorcyclewheelclamp"] = {
		["Index"] = "motorcyclewheelclamp",
		["Name"] = "Braçadeira de Roda",
		["Type"] = "Usável",
		["Weight"] = 1.05,
		["Economy"] = 250
	},
	["barrier"] = {
		["Index"] = "barrier",
		["Name"] = "Barreira",
		["Type"] = "Usável",
		["Weight"] = 1.75,
		["Economy"] = 250
	},
	["cone"] = {
		["Index"] = "cone",
		["Name"] = "Cone",
		["Type"] = "Usável",
		["Weight"] = 1.75,
		["Economy"] = 250
	},
	["spikes"] = {
		["Index"] = "spikes",
		["Name"] = "Spikes",
		["Type"] = "Usável",
		["Weight"] = 1.75,
		["Economy"] = 250
	},
	["medicbag"] = {
		["Index"] = "medicbag",
		["Name"] = "Bolsa Médica",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 2.75,
		["Economy"] = 425
	},
	["medicbed"] = {
		["Index"] = "medicbed",
		["Name"] = "Maca Médica",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 7.25,
		["Economy"] = 725
	},
	["metalscrap"] = {
		["Index"] = "metalscrap",
		["Name"] = "Sucata",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 125
	},
	["screen"] = {
		["Index"] = "screen",
		["Name"] = "Tela",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 125
	},
	["techtrash"] = {
		["Index"] = "techtrash",
		["Name"] = "Lixo Eletrônico",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 125
	},
	["tarp"] = {
		["Index"] = "tarp",
		["Name"] = "Lona",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 50
	},
	["ironfragment"] = {
		["Index"] = "ironfragment",
		["Name"] = "Fragmento de Ferro",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 50
	},
	["sheetmetal"] = {
		["Index"] = "sheetmetal",
		["Name"] = "Chapa de Metal",
		["Type"] = "Comum",
		["Weight"] = 0.65,
		["Economy"] = 50
	},
	["screws"] = {
		["Index"] = "screws",
		["Name"] = "Parafusos",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 50
	},
	["roadsigns"] = {
		["Index"] = "roadsigns",
		["Name"] = "Placas de Trânsito",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 50
	},
	["explosives"] = {
		["Index"] = "explosives",
		["Name"] = "Explosivos",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 75
	},
	["animalfat"] = {
		["Index"] = "animalfat",
		["Name"] = "Gordura Animal",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 10
	},
	["wallet"] = {
		["Index"] = "wallet",
		["Name"] = "Carteira",
		["Type"] = "Comum",
		["Weight"] = 0.2,
		["Economy"] = 5000
	},
	["fidentity"] = {
		["Index"] = "identity",
		["Name"] = "Identidade",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 10000
	},
	["identity"] = {
		["Index"] = "identity",
		["Name"] = "Identidade",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 5000
	},
	["driverlicense"] = {
		["Index"] = "driverlicense",
		["Name"] = "Habilitação",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 5000
	},
	["weaponlicense"] = {
		["Index"] = "weaponlicense",
		["Name"] = "Licença de Arma",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 5000
	},
	["blocksignal"] = {
		["Index"] = "blocksignal",
		["Name"] = "Bloqueador de Sinal",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["pistolbody"] = {
		["Index"] = "pistolbody",
		["Name"] = "Corpo de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolslide"] = {
		["Index"] = "pistolslide",
		["Name"] = "Ferrolho de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolpipe"] = {
		["Index"] = "pistolpipe",
		["Name"] = "Cano de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolspring"] = {
		["Index"] = "pistolspring",
		["Name"] = "Mola de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistoltrigger"] = {
		["Index"] = "pistoltrigger",
		["Name"] = "Gatilho de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolhammer"] = {
		["Index"] = "pistolhammer",
		["Name"] = "Cão de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolstriker"] = {
		["Index"] = "pistolstriker",
		["Name"] = "Percussor de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolgrip"] = {
		["Index"] = "pistolgrip",
		["Name"] = "Punho de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["pistolejector"] = {
		["Index"] = "pistolejector",
		["Name"] = "Ejetor de Pistola",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	
	["smgbody"] = {
		["Index"] = "smgbody",
		["Name"] = "Corpo de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 525
	},
	["smgstock"] = {
		["Index"] = "smgstock",
		["Name"] = "Coronha de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 525
	},
	["smgspring"] = {
		["Index"] = "smgspring",
		["Name"] = "Mola de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["smgbarrel"] = {
		["Index"] = "smgbarrel",
		["Name"] = "Cano de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 525
	},
	["smgreceiver"] = {
		["Index"] = "smgreceiver",
		["Name"] = "Culatra de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 525
	},
	["smgbolt"] = {
		["Index"] = "smgbolt",
		["Name"] = "Ferrolho de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["smgtrigger"] = {
		["Index"] = "smgtrigger",
		["Name"] = "Gatilho de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["smgmuzzle"] = {
		["Index"] = "smgmuzzle",
		["Name"] = "Boca do Cano de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["smgroregrip"] = {
		["Index"] = "smgroregrip",
		["Name"] = "Empunhadura Frontal de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["smgswitch"] = {
		["Index"] = "smgswitch",
		["Name"] = "Seletor de Sub-Metralhadora",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},

	["riflebody"] = {
		["Index"] = "riflebody",
		["Name"] = "Corpo de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflestock"] = {
		["Index"] = "riflestock",
		["Name"] = "Coronha de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflespring"] = {
		["Index"] = "riflespring",
		["Name"] = "Mola de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 425
	},
	["riflebarrel"] = {
		["Index"] = "riflebarrel",
		["Name"] = "Cano de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflereceiver"] = {
		["Index"] = "riflereceiver",
		["Name"] = "Culatra de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflebolt"] = {
		["Index"] = "riflebolt",
		["Name"] = "Ferrolho de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["rifletrigger"] = {
		["Index"] = "rifletrigger",
		["Name"] = "Gatilho de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflemuzzle"] = {
		["Index"] = "riflemuzzle",
		["Name"] = "Boca do Cano de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflehandguard"] = {
		["Index"] = "riflehandguard",
		["Name"] = "Protetor de Mão de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	["riflebuttplate"] = {
		["Index"] = "riflebuttplate",
		["Name"] = "Placa da Coronha de Rifle",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 625
	},
	
	 
	["cotton"] = {
		["Index"] = "cotton",
		["Name"] = "Algodão",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 45
	},
	["plaster"] = {
		["Index"] = "plaster",
		["Name"] = "Esparadrapo",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 35
	},
	["wheatflour"] = {
		["Index"] = "wheatflour",
		["Name"] = "",
		["Type"] = "Usável",
		["Weight"] = 0.15,
		["Economy"] = 30
	},
	["sulfuric"] = {
		["Index"] = "sulfuric",
		["Name"] = "Ácido Sulfúrico",
		["Type"] = "Usável",
		["Weight"] = 0.15,
		["Economy"] = 30
	},
	["salitre"] = {
		["Index"] = "salitre",
		["Name"] = "Nitrato de Potássio",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 25
	},
	["saline"] = {
		["Index"] = "saline",
		["Name"] = "Soro Fisiológico",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 25
	},
	["defibrillator"] = {
		["Index"] = "defibrillator",
		["Name"] = "Desfibrilador",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 3.75,
		["Economy"] = 325
	},
	["alcohol"] = {
		["Index"] = "alcohol",
		["Name"] = "Álcool",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 40
	},
	["notebook"] = {
		["Index"] = "notebook",
		["Name"] = "Notebook",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 7.25,
		["Economy"] = 4250
	},
	["laptop"] = {
		["Index"] = "laptop",
		["Name"] = "Laptop",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 7.25,
		["Economy"] = 4250
	},
	["gpstracker"] = {
		["Index"] = "gpstracker",
		["Name"] = "Gps Tracker",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["gpslocator"] = {
		["Index"] = "gpslocator",
		["Name"] = "Gps Locator",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["gpsjammer"] = {
		["Index"] = "gpsjammer",
		["Name"] = "Gps Jammer",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["gpu"] = {
		["Index"] = "gpu",
		["Name"] = "Gpu",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["drone"] = {
		["Index"] = "drone",
		["Name"] = "Drone",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["dronecontrol"] = {
		["Index"] = "dronecontrol",
		["Name"] = "Drone Control",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["djstand"] = {
		["Index"] = "djstand",
		["Name"] = "Dj stand",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["deafeners"] = {
		["Index"] = "deafeners",
		["Name"] = "Deafeners",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["dashcam"] = {
		["Index"] = "dashcam",
		["Name"] = "Dashcam",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["digiscanner"] = {
		["Index"] = "digiscanner",
		["Name"] = "Digi Scanner",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["keyfob"] = {
		["Index"] = "keyfob",
		["Name"] = "Keyfob",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["psp"] = {
		["Index"] = "psp",
		["Name"] = "Psp",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["sensor"] = {
		["Index"] = "sensor",
		["Name"] = "Sensor",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["boomerphone"] = {
		["Index"] = "boomerphone",
		["Name"] = "Boomerphone",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},
	["microphoneblack"] = {
		["Index"] = "microphoneblack",
		["Name"] = "Microphone Black",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 2.25,
		["Economy"] = 4250
	},

	["syringe"] = {
		["Index"] = "syringe",
		["Name"] = "Seringa",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 2
	},
	["syringe01"] = {
		["Index"] = "syringe2",
		["Name"] = "Seringa A+",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 10
	},
	["syringe02"] = {
		["Index"] = "syringe2",
		["Name"] = "Seringa B+",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 10
	},
	["syringe03"] = {
		["Index"] = "syringe2",
		["Name"] = "Seringa A-",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 10
	},
	["syringe04"] = {
		["Index"] = "syringe2",
		["Name"] = "Seringa B-",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 10
	},

	["bfsandwich"] = {
		["Type"] = "Comum",
		["Index"] = "bfsandwich",
		["Name"] = "Breakfast Sandwich",
		["Description"] = "Levante-se e brilhe",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},


	["bsfries"] = {
		["Type"] = "Comum",
		["Index"] = "bsfries",
		["Name"] = "Fries Shot",
		["Description"] = "Sacia a fome e engrossa o sangue",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["bsdrink"] = {
		["Type"] = "Comum",
		["Index"] = "bsdrink",
		["Name"] = "Drink Shot",
		["Description"] = "Sacia a sede e dá uma dose de açúcar",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},
	["softdrink"] = {
		["Type"] = "Comum",
		["Index"] = "softdrink",
		["Name"] = "Soft Drink",
		["Description"] = "Sacia a sede e dá uma dose de açúcar",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},
	["bscoffee"] = {
		["Type"] = "Comum",
		["Index"] = "bscoffee",
		["Name"] = "Café barato",
		["Description"] = "Tem gosto de sujeira, mas contém a cafeína que você precisa",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},
	["bsmoneyshot"] = {
		["Type"] = "Comum",
		["Index"] = "bsmoneyshot",
		["Name"] = "Money Shot",
		["Description"] = "Sacia a fome e reduz o estresse",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Max"] = 1,
	},
	["bsheartstopper"] = {
		["Type"] = "Comum",
		["Index"] = "bsheartstopper",
		["Name"] = "The Heart Stopper",
		["Description"] = "Sacia a fome e reduz o estresse",
		["Durability"] = 36,
		["Weight"] = 1.0,
		["Max"] = 1,
	},
	["bsbleederburger"] = {
		["Type"] = "Comum",
		["Index"] = "bsbleederburger",
		["Name"] = "The Bleeder",
		["Description"] = "Sacia a fome e reduz o estresse",
		["Durability"] = 36,
		["Weight"] = 1.0,
		["Max"] = 1,
	},
	["bsnuggets"] = {
		["Type"] = "Comum",
		["Index"] = "bsnuggets",
		["Name"] = "Nuggets Shot",
		["Description"] = "Sacia a fome e reduz o estresse",
		["Durability"] = 36,
		["Weight"] = 1.0,
		["Max"] = 1,
	},
	["bsrings"] = {
		["Type"] = "Comum",
		["Index"] = "bsrings",
		["Name"] = "Rings Shot",
		["Description"] = "Suffering never tasted so good! 850Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},

	["cbballs"] = {
		["Type"] = "Comum",
		["Index"] = "cbballs",
		["Name"] = "Cluckin Balls",
		["Description"] = "Ooh..salgado. 440Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbbucket"] = {
		["Type"] = "Comum",
		["Index"] = "cbbucket",
		["Name"] = "Cluckin Bucket",
		["Description"] = "eu gosto de frango! 2350Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbclucker"] = {
		["Type"] = "Comum",
		["Index"] = "cbclucker",
		["Name"] = "Little Clucker",
		["Description"] = "Brinquedo Cluckin não incluído",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbdrink"] = {
		["Type"] = "Comum",
		["Index"] = "cbdrink",
		["Name"] = "Cluckin Drink",
		["Description"] = "Inferno Cluckin Sim",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},
	["cbfarmers"] = {
		["Type"] = "Comum",
		["Index"] = "cbfarmers",
		["Name"] = "Farmer's Surprise",
		["Description"] = "Os pedaços mastigáveis ​​​​não são prejudiciais",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbfowl"] = {
		["Type"] = "Comum",
		["Index"] = "cbfowl",
		["Name"] = "Hambúrguer de Frango",
		["Description"] = "Se você gostou, a galinha não morreu em vão! 900Cal",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 1,
	},
	["cbfries"] = {
		["Type"] = "Comum",
		["Index"] = "cbfries",
		["Name"] = "Cluckin Fries",
		["Description"] = "Cluckinsize included. 680Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbrings"] = {
		["Type"] = "Comum",
		["Index"] = "cbrings",
		["Name"] = "Cluckin Rings",
		["Description"] = "Suffering never tasted so good! 850Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbrownie"] = {
		["Type"] = "Comum",
		["Index"] = "cbrownie",
		["Name"] = "Cannabis Brownie",
		["Description"] = "Dude...",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},
	["cbveggy"] = {
		["Type"] = "Comum",
		["Index"] = "cbveggy",
		["Name"] = "Salada Vegetariana",
		["Description"] = "Mystery chewy bits included. 750Cal",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Max"] = 1,
	},

	["foodingredient"] = {
		["Type"] = "Usável",
		["Index"] = "ingredients",
		["Name"] = "Ingredients",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 5.0,
	},
	["hamburgermeat"] = {
		["Type"] = "Usável",
		["Index"] = "hamburgermeat",
		["Name"] = "Carne de hambúrguer",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["hamburgerbuns"] = {
		["Type"] = "Usável",
		["Index"] = "hamburgerbuns",
		["Name"] = "Pão de hambúrguer",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["lettuce"] = {
		["Type"] = "Usável",
		["Index"] = "lettuce",
		["Name"] = "Alface",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["hamburgerpatty"] = {
		["Type"] = "Usável",
		["Index"] = "hamburgerpatty",
		["Name"] = "Hambúrguer",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["cheese"] = {
		["Type"] = "Usável",
		["Index"] = "cheese",
		["Name"] = "Queijo",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["potato"] = {
		["Type"] = "Usável",
		["Index"] = "potato",
		["Name"] = "Batata",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["potatoes"] = {
		["Type"] = "Usável",
		["Index"] = "potatoes",
		["Name"] = "Batatas",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 5.0,
	},
	["milk"] = {
		["Type"] = "Usável",
		["Index"] = "milk",
		["Name"] = "Leite",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["icecreamingred"] = {
		["Type"] = "Usável",
		["Index"] = "icecreamingred",
		["Name"] = "Sorvete",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Weight"] = 1.0,
	},
	["coffeebeans"] = {
		["Type"] = "Usável",
		["Index"] = "coffeebeans",
		["Name"] = "Grãos de café",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["hfcs"] = {
		["Type"] = "Usável",
		["Index"] = "hfcs",
		["Name"] = "High-Fructose Syrup",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["tomato"] = {
		["Type"] = "Usável",
		["Index"] = "tomato",
		["Name"] = "Tomate",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["cucumber"] = {
		["Type"] = "Usável",
		["Index"] = "cucumber",
		["Name"] = "Pepino",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["carrot"] = {
		["Type"] = "Usável",
		["Index"] = "carrot",
		["Name"] = "Cenoura",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["radish"] = {
		["Type"] = "Usável",
		["Index"] = "radish",
		["Name"] = "Rabanete",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["beetroot"] = {
		["Type"] = "Usável",
		["Index"] = "beetroot",
		["Name"] = "Beterraba",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["cabbage"] = {
		["Type"] = "Usável",
		["Index"] = "cabbage",
		["Name"] = "Repolho",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["chives"] = {
		["Type"] = "Usável",
		["Index"] = "chives",
		["Name"] = "Cebolinha",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "seasoning"
	},
	["pumpkin"] = {
		["Type"] = "Usável",
		["Index"] = "pumpkin",
		["Name"] = "Abóbora",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "sugar"
	},
	["corn"] = {
		["Type"] = "Usável",
		["Index"] = "corn",
		["Name"] = "Milho",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "grain"
	},
	["oregano"] = {
		["Type"] = "Usável",
		["Index"] = "oregano",
		["Name"] = "Oregano",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "seasoning"
	},
	["garlic"] = {
		["Type"] = "Usável",
		["Index"] = "garlic",
		["Name"] = "Alho",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "seasoning"
	},
	["mushrooms"] = {
		["Type"] = "Usável",
		["Index"] = "mushrooms",
		["Name"] = "Cogumelos",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["onion"] = {
		["Type"] = "Usável",
		["Index"] = "onion",
		["Name"] = "Cebola",
		["Description"] = "Are your eyes watering?",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Category"] = "vegetables"
	},
	["rawchickenthighs"] = {
		["Type"] = "Usável",
		["Index"] = "rawchickenthighs",
		["Name"] = "Coxas de Frango Cru",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 1.0,
	},
	["rawchicken"] = {
		["Type"] = "Usável",
		["Index"] = "rawchicken",
		["Name"] = "Frango Cru",
		["Description"] = "Usado para preparar comida - esteja ciente, comida não dura para sempre!",
		["Durability"] = 36,
		["Weight"] = 3.0,
	},

	["lockcore"] = {
		["Index"] = "lockcore",
		["Name"] = "Kit Fechadura",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 0
	},
	["homekey"] = {
		["Index"] = "homekey",
		["Name"] = "Chave",
		["Type"] = "Usável",
		["Weight"] = 0.15,
		["Economy"] = 0
	},
	["vehkey"] = {
		["Index"] = "vehkey",
		["Name"] = "Chave",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["evidence01"] = {
		["Index"] = "evidence01",
		["Name"] = "Evidência",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["evidence02"] = {
		["Index"] = "evidence02",
		["Name"] = "Evidência",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["evidence03"] = {
		["Index"] = "evidence03",
		["Name"] = "Evidência",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["evidence04"] = {
		["Index"] = "evidence04",
		["Name"] = "Evidência",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["rottweiler"] = {
		["Index"] = "rottweiler",
		["Name"] = "Coleira de Rottweiler",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["husky"] = {
		["Index"] = "husky",
		["Name"] = "Coleira de Husky",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["shepherd"] = {
		["Index"] = "shepherd",
		["Name"] = "Coleira de Shepherd",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["retriever"] = {
		["Index"] = "retriever",
		["Name"] = "Coleira de Retriever",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["poodle"] = {
		["Index"] = "poodle",
		["Name"] = "Coleira de Poodle",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["pug"] = {
		["Index"] = "pug",
		["Name"] = "Coleira de Pug",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["westy"] = {
		["Index"] = "westy",
		["Name"] = "Coleira de Westy",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["cat"] = {
		["Index"] = "cat",
		["Name"] = "Coleira de Gato",
		["Type"] = "Animal",
		["Weight"] = 1.25,
		["Economy"] = 25000
	},
	["card01"] = {
		["Index"] = "card01",
		["Name"] = "Cartão Comum",
		["Description"] = "Roubar Lojas de Departamento.",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.25,
		["Economy"] = 325
	},
	["card02"] = {
		["Index"] = "card02",
		["Name"] = "Cartão In-Comum",
		["Description"] = "Roubar Lojas de Armas.",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.25,
		["Economy"] = 325
	},
	["card03"] = {
		["Index"] = "card03",
		["Name"] = "Cartão Épico",
		["Description"] = "Roubar Bancos Fleeca.",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.25,
		["Economy"] = 375
	},
	["card04"] = {
		["Index"] = "card04",
		["Name"] = "Cartão Raro",
		["Description"] = "Roubar Barbearias.",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.25,
		["Economy"] = 275
	},
	["card05"] = {
		["Index"] = "card05",
		["Name"] = "Cartão Lendário",
		["Description"] = "Roubar Bancos.",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.25,
		["Economy"] = 425
	},
	["radio"] = {
		["Index"] = "radio",
		["Name"] = "Rádio",
		["Type"] = "Usável",
		["Repair"] = "repairkit01",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 975
	},
	["radioscanner"] = {
		["Index"] = "radioscanner",
		["Name"] = "Scanner de rádio",
		["Type"] = "Usável",
		["Repair"] = "repairkit01",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 975
	},
	["vest"] = {
		["Index"] = "vest",
		["Name"] = "Colete",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 3.75,
		["Economy"] = 1000
	},
	["bandage"] = {
		["Index"] = "bandage",
		["Name"] = "Bandagem",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 3,
		["Economy"] = 225
	},
	["medkit"] = {
		["Index"] = "medkit",
		["Name"] = "Kit Médico",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Max"] = 2,
		["Economy"] = 575
	},
	["adrenaline"] = {
		["Index"] = "adrenaline",
		["Name"] = "Adrenaline",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 600
	},
	["pouch"] = {
		["Index"] = "pouch",
		["Name"] = "Malote",
		["Type"] = "Comum",
		["Weight"] = 1.25,
		["Economy"] = 80
	},
	["woodlog"] = {
		["Index"] = "woodlog",
		["Name"] = "Tora de Madeira",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 40
	},
	["gunpowder"] = {
		["Index"] = "gunpowder",
		["Name"] = "Pólvora",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 50
	},
	["treasurebox"] = {
		["Index"] = "treasurebox",
		["Name"] = "Baú do Tesouro",
		["Type"] = "Caixa",
		["Weight"] = 4.25,
		["Economy"] = 3000,
	},
	["fishingrod"] = {
		["Index"] = "fishingrod",
		["Name"] = "Vara de Pescar",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 2.75,
		["Economy"] = 725
	},
	["octopus"] = {
		["Index"] = "octopus",
		["Name"] = "Polvo",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 14
	},
	["shrimp"] = {
		["Index"] = "shrimp",
		["Name"] = "Camarão",
		["Type"] = "Comum",
		["Weight"] = 0.50,
		["Economy"] = 14
	},
	["carp"] = {
		["Index"] = "carp",
		["Name"] = "Carpa",
		["Type"] = "Usável",
		["Weight"] = 0.50,
		["Economy"] = 12
	},
	["codfish"] = {
		["Index"] = "codfish",
		["Name"] = "Bacalhau",
		["Type"] = "Usável",
		["Weight"] = 0.50,
		["Economy"] = 16
	},
	["catfish"] = {
		["Index"] = "catfish",
		["Name"] = "Bagre",
		["Type"] = "Usável",
		["Weight"] = 0.50,
		["Economy"] = 16
	},
	["goldenfish"] = {
		["Index"] = "goldenfish",
		["Name"] = "Dourado",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 30
	},
	["horsefish"] = {
		["Index"] = "horsefish",
		["Name"] = "Cavala",
		["Type"] = "Usável",
		["Weight"] = 0.50,
		["Economy"] = 12
	},
	["tilapia"] = {
		["Index"] = "tilapia",
		["Name"] = "Tilápia",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 14
	},
	["pacu"] = {
		["Index"] = "pacu",
		["Name"] = "Pacu",
		["Type"] = "Usável",
		["Weight"] = 0.50,
		["Economy"] = 24
	},
	["pirarucu"] = {
		["Index"] = "pirarucu",
		["Name"] = "Pirarucu",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 26
	},
	["tambaqui"] = {
		["Index"] = "tambaqui",
		["Name"] = "Tambaqui",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 28
	},
	["bait"] = {
		["Index"] = "bait",
		["Name"] = "Isca",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 5
	},
	["animalpelt"] = {
		["Index"] = "animalpelt",
		["Name"] = "Pele Animal",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 25
	},
	["weedclone"] = {
		["Index"] = "weedclone",
		["Name"] = "Clonagem de Maconha",
		["Type"] = "Usável",
		["Weight"] = 0.15
	},
	["weedleaf"] = {
		["Index"] = "weedleaf",
		["Name"] = "Folha de Maconha",
		["Type"] = "Comum",
		["Weight"] = 0.30
	},
	["joint"] = {
		["Index"] = "joint",
		["Name"] = "Baseado",
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["codeine"] = {
		["Index"] = "codeine",
		["Name"] = "Codeína",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 35
	},
	["amphetamine"] = {
		["Index"] = "amphetamine",
		["Name"] = "Anfetamina",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 45
	},
	["cocaine"] = {
		["Index"] = "cocaine",
		["Name"] = "Cocaína",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 35
	},
	["cokeleaf"] = {
		["Index"] = "cokeleaf",
		["Name"] = "Folha de Coca",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 5
	},
	["cokeclone"] = {
		["Index"] = "weedclone",
		["Name"] = "Clonagem de Cocaína",
		["Type"] = "Usável",
		["Weight"] = 0.15
	},
	["meth"] = {
		["Index"] = "meth",
		["Name"] = "Metanfetamina",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 35
	},
	["acetone"] = {
		["Index"] = "acetone",
		["Name"] = "Acetona",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 40
	},
	["keymaster"] = {
		["Index"] = "keymaster",
		["Name"] = "keymaster",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 100
	},
	["drugtoy"] = {
		["Index"] = "drugtoy",
		["Name"] = "Brinquedo",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 100
	},
	["platepremium"] = {
		["Index"] = "platepremium",
		["Name"] = "Placa Premium",
		["Type"] = "Usável",
		["Description"] = "Personaliza a placa do veículo.",
		["Weight"] = 0.75,
		["Economy"] = 50000,
		["Block"] = true
	},
	["newchars"] = {
		["Index"] = "newchars",
		["Name"] = "+1 Personagem",
		["Type"] = "Usável",
		["Description"] = "Limite de personagem em +1.",
		["Weight"] = 0.25,
		["Economy"] = 75000,
		["Block"] = true
	},
	["chip"] = {
		["Index"] = "chip",
		["Name"] = "Chip Telefônico",
		["Type"] = "Usável",
		["Description"] = "Troca o número telefônico.",
		["Weight"] = 0.00,
		["Economy"] = 60000,
		["Block"] = true
	},
	["namechange"] = {
		["Index"] = "namechange",
		["Name"] = "Troca de Nome",
		["Type"] = "Usável",
		["Description"] = "Troca o nome do personagem.",
		["Weight"] = 0.25,
		["Economy"] = 50000,
		["Block"] = true
	},
	["facechange"] = {
		["Index"] = "greencard",
		["Name"] = "Troca de Rosto",
		["Type"] = "Usável",
		["Description"] = "Troca o rosto do personagem.",
		["Weight"] = 0.25,
		["Economy"] = 25000
	},
	["energetic"] = {
		["Index"] = "energetic",
		["Name"] = "Energético",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 5,
		["Economy"] = 15
	},
	
	["milkbottle"] = {
		["Index"] = "milkbottle",
		["Name"] = "Garrafa de Leite",
		["Type"] = "Usável",
		["Weight"] = 0.45,
		["Scape"] = true,
		["Max"] = 15,
		["Economy"] = 35
	},
	["guarananatural"] = {
		["Index"] = "guarananatural",
		["Name"] = "Guaraná Natural",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 100
	},
	["water"] = {
		["Index"] = "water",
		["Name"] = "Água",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Scape"] = true,
		["Max"] = 5,
		["Economy"] = 10
	},
	["coffee"] = {
		["Index"] = "coffee",
		["Name"] = "Café",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 3,
		["Economy"] = 20
	},
	["coffeemilk"] = {
		["Index"] = "coffeemilk",
		["Name"] = "Café com Leite",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.35,
		["Max"] = 3,
		["Economy"] = 95
	},
	["cola"] = {
		["Index"] = "cola",
		["Name"] = "Cola",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 3,
		["Economy"] = 15
	},
	["tacos"] = {
		["Index"] = "tacos",
		["Name"] = "Tacos",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 3,
		["Economy"] = 25
	},
	["fries"] = {
		["Index"] = "fries",
		["Name"] = "Fritas",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 95
	},
	["soda"] = {
		["Index"] = "soda",
		["Name"] = "Sprunk",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Max"] = 3,
		["Economy"] = 15
	},
	["apple"] = {
		["Index"] = "apple",
		["Name"] = "Maça",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["orange"] = {
		["Index"] = "orange",
		["Name"] = "Laranja",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["strawberry"] = {
		["Index"] = "strawberry",
		["Name"] = "Morango",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["coffee2"] = {
		["Index"] = "coffee2",
		["Name"] = "Grão de Café",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["grape"] = {
		["Index"] = "grape",
		["Name"] = "Uva",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["tange"] = {
		["Index"] = "tange",
		["Name"] = "Tangerina",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["banana"] = {
		["Index"] = "banana",
		["Name"] = "Banana",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["guarana"] = {
		["Index"] = "guarana",
		["Name"] = "Guaraná",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["acerola"] = {
		["Index"] = "acerola",
		["Name"] = "Acerola",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["passion"] = {
		["Index"] = "passion",
		["Name"] = "Maracujá",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["mushroom"] = {
		["Index"] = "mushroom",
		["Name"] = "Cogumelo",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["cocoa"] = {
		["Index"] = "cocoa",
		["Name"] = "Cacau",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["sugar"] = {
		["Index"] = "sugar",
		["Name"] = "Açucar",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 5
	},
	["cookies"] = {
		["Index"] = "cookies",
		["Name"] = "Cookies",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 60
	},
	["orangejuice"] = {
		["Index"] = "orangejuice",
		["Name"] = "Suco de Laranja",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["tangejuice"] = {
		["Index"] = "tangejuice",
		["Name"] = "Suco de Tangerina",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["grapejuice"] = {
		["Index"] = "grapejuice",
		["Name"] = "Suco de Uva",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["strawberryjuice"] = {
		["Index"] = "strawberryjuice",
		["Name"] = "Suco de Morango",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["bananajuice"] = {
		["Index"] = "bananajuice",
		["Name"] = "Suco de Banana",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["acerolajuice"] = {
		["Index"] = "acerolajuice",
		["Name"] = "Suco de Acerola",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["passionjuice"] = {
		["Index"] = "passionjuice",
		["Name"] = "Suco de Maracujá",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["bread"] = {
		["Index"] = "bread",
		["Name"] = "Pão",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 5
	},
	["ketchup"] = {
		["Index"] = "ketchup",
		["Name"] = "Ketchup",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 75
	},
	["spaghetti"] = {
		["Index"] = "spaghetti",
		["Name"] = "Espaguete",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Economy"] = 55
	},
	["cannedsoup"] = {
		["Index"] = "cannedsoup",
		["Name"] = "Sopa em Lata",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Economy"] = 55
	},
	["canofcorn"] = {
		["Index"] = "canofcorn",
		["Name"] = "Lata de Milho",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Economy"] = 55
	},
	["canofbeans"] = {
		["Index"] = "canofbeans",
		["Name"] = "Lata de Feijão",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Economy"] = 55
	},
	["spoon"] = {
		["Index"] = "spoon",
		["Name"] = "Colher",
		["Type"] = "Comum",
		["Weight"] = 0.02,
		["Economy"] = 55
	},
	["canopener"] = {
		["Index"] = "canopener",
		["Name"] = "Abridor de Lata",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 55
	},
	["jailfood"] = {
		["Index"] = "jailfood",
		["Name"] = "Comida de prisão",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.95,
		["Economy"] = 55
	},
	["fishfillet"] = {
		["Index"] = "fishfillet",
		["Name"] = "Filé de Peixe",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 10
	},
	["marshmallow"] = {
		["Index"] = "marshmallow",
		["Name"] = "Marshmallow",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 35
	},
	["cookedfishfillet"] = {
		["Index"] = "cookedfishfillet",
		["Name"] = "Filé de Peixe Cozido",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.15,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 35
	},
	["hamburger"] = {
		["Index"] = "hamburger",
		["Name"] = "Hambúrguer",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 25
	},
	["hamburger2"] = {
		["Index"] = "hamburger2",
		["Name"] = "Hambúrguer Artesanal",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["onionrings"] = {
		["Index"] = "onionrings",
		["Name"] = "Anéis de Cebola",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["chickenfries"] = {
		["Index"] = "chickenfries",
		["Name"] = "Frango Frito",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 125
	},
	["pizzamozzarella"] = {
		["Index"] = "pizzamozzarella",
		["Name"] = "Pizza de Muçarela",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["pizzamushroom"] = {
		["Index"] = "pizzamushroom",
		["Name"] = "Pizza de Cogumelo",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["pizzabanana"] = {
		["Index"] = "pizzabanana",
		["Name"] = "Pizza de Banana",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["pizzachocolate"] = {
		["Index"] = "pizzachocolate",
		["Name"] = "Pizza de Chocolate",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.75,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["calzone"] = {
		["Index"] = "calzone",
		["Name"] = "Calzone",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 150
	},
	["box6"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Peças - Munição",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["box5"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Materiais - Favela4",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["box4"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Materiais - Favela3",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["box3"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Materiais - Favela2",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["box2"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Materiais - Favela1",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["box1"] = {
		["Index"] = "box",
		["Name"] = "Pacote de Peças - Armas",
		["Durability"] = 36,
		["Type"] = "Usável",
		["Weight"] = 0.25
	},
	["hotdog"] = {
		["Index"] = "hotdog",
		["Name"] = "Cachorro-Quente",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.45,
		["Economy"] = 15,
		["Max"] = 3
	},
	["donut"] = {
		["Index"] = "donut",
		["Name"] = "Rosquinha",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Economy"] = 15,
		["Max"] = 3
	},
	["plate"] = {
		["Index"] = "plate",
		["Name"] = "Placa",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["lockpick"] = {
		["Index"] = "lockpick",
		["Name"] = "Lockpick de Alumínio",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 72,
		["Weight"] = 1.25,
		["Economy"] = 575
	},
	["toolbox"] = {
		["Index"] = "toolbox",
		["Name"] = "Ferramentas Básicas",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Max"] = 2,
		["Economy"] = 1000
	},
	["advtoolbox"] = {
		["Index"] = "advtoolbox",
		["Name"] = "Ferramentas Avançadas",
		["Type"] = "Usável",
		["Weight"] = 3.25,
		["Charges"] = 3,
		["Max"] = 1,
		["Economy"] = 2440
	},
	["notepad"] = {
		["Index"] = "notepad",
		["Name"] = "Bloco de Notas",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 10
	},
	["tyres"] = {
		["Index"] = "tyres",
		["Name"] = "Pneu",
		["Type"] = "Usável",
		["Weight"] = 2.75,
		["Max"] = 4,
		["Economy"] = 360
	},
	["paymentterminal"] = {
		["Index"] = "paymentterminal",
		["Name"] = "Máquina de cartão",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 725
	},
	["cellphone"] = {
		["Index"] = "cellphone",
		["Name"] = "Celular",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 725
	},
	["scuba"] = {
		["Index"] = "scuba",
		["Name"] = "Roupa de Mergulho",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 4.75,
		["Economy"] = 975
	},
	["handcuff"] = {
		["Index"] = "handcuff",
		["Name"] = "Algemas",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 1.25,
		["Economy"] = 5750
	},
	["handcuffkey"] = {
		["Index"] = "handcuffkey",
		["Name"] = "Chave de Algema",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 0
	},
	["rope"] = {
		["Index"] = "rope",
		["Name"] = "Cordas",
		["Repair"] = "repairkit01",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 875
	},
	["hood"] = {
		["Index"] = "hood",
		["Name"] = "Capuz",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 5750
	},
	["plastic"] = {
		["Index"] = "plastic",
		["Name"] = "Plástico",
		["Type"] = "Comum",
		["Weight"] = 0.06,
		["Economy"] = 20
	},
	["glass"] = {
		["Index"] = "glass",
		["Name"] = "Vidro",
		["Type"] = "Comum",
		["Weight"] = 0.06,
		["Economy"] = 20
	},
	["rubber"] = {
		["Index"] = "rubber",
		["Name"] = "Borracha",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["coal"] = {
		["Index"] = "coal",
		["Name"] = "Carvão Mineral",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 20
	},
	["charcoal"] = {
		["Index"] = "coal",
		["Name"] = "Carvão Vergetal",
		["Type"] = "Comum",
		["Weight"] = 0.10,
		["Economy"] = 20
	},
	["aluminum"] = {
		["Index"] = "aluminum",
		["Name"] = "Alumínio",
		["Type"] = "Comum",
		["Weight"] = 0.07,
		["Economy"] = 20
	},
	["copper"] = {
		["Index"] = "copper",
		["Name"] = "Cobre",
		["Type"] = "Comum",
		["Weight"] = 0.09,
		["Economy"] = 20
	},
	["ritmoneury"] = {
		["Index"] = "ritmoneury",
		["Name"] = "Ritmoneury",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Max"] = 2,
		["Economy"] = 475
	},
	["sinkalmy"] = {
		["Index"] = "sinkalmy",
		["Name"] = "Sinkalmy",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Max"] = 2,
		["Economy"] = 375
	},
	["cigar"] = {
		["Index"] = "cigar",
		["Name"] = "Charuto",
		["Type"] = "Usável",
		["Weight"] = 0.09,
		["Max"] = 5,
		["Economy"] = 10
	},
	["cigarette"] = {
		["Index"] = "cigarette",
		["Name"] = "Cigarro",
		["Type"] = "Usável",
		["Weight"] = 0.03,
		["Max"] = 5,
		["Economy"] = 10
	},
	["ciggypack"] = {
		["Index"] = "ciggypack",
		["Name"] = "Cigarros",
		["Description"] = "Um maço de cigarros, cheiram e têm gosto de merda, mas aliviam o estresse, o estresse criado pelo vício com certeza, mas aliviam o estresse.",
		["Type"] = "Usável",
		["Weight"] = 0.95,
		["Max"] = 5,
		["Economy"] = 10
	},
	["ollyrancher"] = {
		["Index"] = "ollyrancher",
		["Name"] = "Olly Rancher",
		["Description"] = "Adere aos dentes.",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.05,
		["Max"] = 5,
		["Economy"] = 10
	},
	["ollyrancherbag"] = {
		["Index"] = "ollyrancherbag",
		["Name"] = "Bag Of Olly Rancher",
		["Type"] = "Usável",
		["Weight"] = 1.50,
		["Max"] = 5,
		["Economy"] = 10
	},
	["lighter"] = {
		["Index"] = "lighter",
		["Name"] = "Isqueiro",
		["Repair"] = "repairkit01",
		["Durability"] = 240,
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 175
	},
	["vape"] = {
		["Index"] = "vape",
		["Name"] = "Vape",
		["Repair"] = "repairkit02",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 4750
	},
	["dollars"] = {
		["Index"] = "dollars",
		["Name"] = "Dólares",
		["Type"] = "Comum",
		["Weight"] = 0.0,
		["Economy"] = 1
	},
	["dollars2"] = {
		["Index"] = "dollars2",
		["Name"] = "Dólares Marcados",
		["Type"] = "Comum",
		["Weight"] = 0.0,
		["Economy"] = 1
	},
	["dollars100"] = {
		["Index"] = "packdollars",
		["Name"] = "Entrega Frágil",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 1000
	},
	["dollars500"] = {
		["Index"] = "packdollars",
		["Name"] = "Entrega Frágil",
		["Type"] = "Comum",
		["Weight"] = 0.50,
		["Economy"] = 5000
	},
	["dollars1000"] = {
		["Index"] = "packdollars",
		["Name"] = "Entrega Frágil",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 10000
	},
	["battery"] = {
		["Index"] = "battery",
		["Name"] = "Bateria",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 90
	},
	["cellbattery"] = {
		["Index"] = "cellbattery",
		["Name"] = "Bateria de Celular",
		["Type"] = "Comum",
		["Weight"] = 0.40,
		["Economy"] = 90
	},
	["pile"] = {
		["Index"] = "pile",
		["Name"] = "Pilhas",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 90
	},
	["carbattery"] = {
		["Index"] = "carbattery",
		["Name"] = "Bateria de Carro",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 90
	},
	["elastic"] = {
		["Index"] = "elastic",
		["Name"] = "Elástico",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 60
	},
	["plasticbottle"] = {
		["Index"] = "plasticbottle",
		["Name"] = "Garrafa Plástica",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 60
	},
	["glassbottle"] = {
		["Index"] = "glassbottle",
		["Name"] = "Garrafa de Vidro",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 60
	},
	["metalcan"] = {
		["Index"] = "metalcan",
		["Name"] = "Lata de Metal",
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 90
	},
	["can"] = {
		["Index"] = "can",
		["Name"] = "Latinha",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 90
	},
	["chocolate"] = {
		["Index"] = "chocolate",
		["Name"] = "Chocolate",
		["Type"] = "Usável",
		["Weight"] = 0.15,
		["Scape"] = true,
		["Max"] = 3,
		["Economy"] = 15
	},
	["sandwich"] = {
		["Index"] = "sandwich",
		["Name"] = "Sanduiche",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.25,
		["Economy"] = 15,
		["Max"] = 3
	},
	["rose"] = {
		["Index"] = "rose",
		["Name"] = "Rosa",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 25
	},
	["teddy"] = {
		["Index"] = "teddy",
		["Name"] = "Teddy",
		["Type"] = "Usável",
		["Weight"] = 1.25,
		["Economy"] = 75
	},
	["absolut"] = {
		["Index"] = "absolut",
		["Name"] = "Absolut",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Economy"] = 15
	},
	["chandon"] = {
		["Index"] = "chandon",
		["Name"] = "Chandon",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Economy"] = 15
	},
	["dewars"] = {
		["Index"] = "dewars",
		["Name"] = "Dewars",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Economy"] = 15
	},
	["hennessy"] = {
		["Index"] = "hennessy",
		["Name"] = "Hennessy",
		["Type"] = "Usável",
		["Durability"] = 36,
		["Weight"] = 0.55,
		["Economy"] = 15
	},
	["wine"] = {
		["Index"] = "wine",
		["Name"] = "Vinho",
		["Type"] = "Usável",
		["Durability"] = 240,
		["Weight"] = 0.55,
		["Economy"] = 15
	},
	["goldbar"] = {
		["Index"] = "goldbar",
		["Name"] = "Barra de Ouro",
		["Type"] = "Comum",
		["Stack"] = 64,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["binoculars"] = {
		["Index"] = "binoculars",
		["Name"] = "Binóculos",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 275
	},
	["camera"] = {
		["Index"] = "camera",
		["Name"] = "Câmera",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Economy"] = 275
	},
	["camera2"] = {
		["Index"] = "camera2",
		["Name"] = "Câmera",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Economy"] = 275
	},
	["ammo9box"] = {
		["Index"] = "pistolammobox",
		["Name"] = "Caixa 9×19mm",
		["Type"] = "Usável",
		["Weight"] = 0.95,
		["Economy"] = 35,
		["Stack"] = 1,
	},
	["ammo45box"] = {
		["Index"] = "subammobox",
		["Name"] = "Caixa .45 ACP",
		["Type"] = "Usável",
		["Weight"] = 1.08,
		["Economy"] = 35,
		["Stack"] = 1,
	},
	["ammo556box"] = {
		["Index"] = "ammo556box",
		["Name"] = "Caixa 5,56×45mm",
		["Type"] = "Usável",
		["Weight"] = 1.20,
		["Economy"] = 35,
		["Stack"] = 1,
	},
	["ammo12box"] = {
		["Index"] = "shotgunammobox",
		["Name"] = "Caixa 12",
		["Type"] = "Usável",
		["Weight"] = 1.35,
		["Economy"] = 35,
		["Stack"] = 1,
	},

	["WEAPON_HATCHET"] = {
		["Index"] = "hatchet",
		["Name"] = "Machado",
		["Type"] = "Armamento",
		["Repair"] = "repairkit01",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 975
	},
	["WEAPON_BAT"] = {
		["Index"] = "bat",
		["Name"] = "Bastão de Beisebol",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 975
	},
	["WEAPON_KATANA"] = {
		["Index"] = "katana",
		["Name"] = "Katana",
		["Type"] = "Armamento",
		["Repair"] = "repairkit01",
		["Durability"] = 36,
		["Weight"] = 1.75,
		["Economy"] = 975
	},
	["WEAPON_KARAMBIT"] = {
		["Index"] = "karambit",
		["Name"] = "Karambit",
		["Type"] = "Armamento",
		["Repair"] = "repairkit01",
		["Durability"] = 36,
		["Weight"] = 1.25,
		["Economy"] = 975
	},

	["WEAPON_SWITCHBLADE"] = {
		["Index"] = "switchblade",
		["Name"] = "Canivete",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Description"] = "Utilizada para remoção de carne.",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_DAGGER"] = {
		["Index"] = "dagger",
		["Name"] = "Adaga de Cavalaria Antiga",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_KNIFE"] = {
		["Index"] = "knife",
		["Name"] = "Faca",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_BOTTLE"] = {
		["Index"] = "brokenbottle",
		["Name"] = "Garrafa quebrada",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_BATTLEAXE"] = {
		["Index"] = "battleaxe",
		["Name"] = "Machado de Batalha",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.75,
		["Economy"] = 975
	},
	["WEAPON_CROWBAR"] = {
		["Index"] = "crowbar",
		["Name"] = "Pé de Cabra",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.35,
		["Economy"] = 1450
	},
	["WEAPON_GOLFCLUB"] = {
		["Index"] = "golfclub",
		["Name"] = "Taco de Golf",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.65,
		["Economy"] = 975
	},
	["WEAPON_HAMMER"] = {
		["Index"] = "hammer",
		["Name"] = "Martelo",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.45,
		["Economy"] = 975
	},
	["WEAPON_MACHETE"] = {
		["Index"] = "machete",
		["Name"] = "Facão",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.35,
		["Economy"] = 975
	},
	["WEAPON_POOLCUE"] = {
		["Index"] = "poolcue",
		["Name"] = "Taco de Sinuca",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.25,
		["Economy"] = 975
	},
	["WEAPON_STONE_HATCHET"] = {
		["Index"] = "stonehatchet",
		["Name"] = "Machado de Pedra",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.55,
		["Economy"] = 975
	},
	["WEAPON_WRENCH"] = {
		["Index"] = "wrench",
		["Name"] = "Chave Inglesa",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.45,
		["Economy"] = 1450
	},
	["WEAPON_KNUCKLE"] = {
		["Index"] = "knuckle",
		["Name"] = "Soco Inglês",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.15,
		["Economy"] = 975
	},
	["WEAPON_FLASHLIGHT"] = {
		["Index"] = "flashlight",
		["Name"] = "Lanterna",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.15,
		["Economy"] = 975
	},
	["WEAPON_NIGHTSTICK"] = {
		["Index"] = "nightstick",
		["Name"] = "Cassetete",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Durability"] = 240,
		["Weight"] = 1.15,
		["Economy"] = 125
	},
	["WEAPON_PISTOLXM3"] = {
		["Index"] = "pistolxm3",
		["Name"] = "WM 29 Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.25,
		["Economy"] = 5750
	},
	["WEAPON_CERAMICPISTOL"] = {
		["Index"] = "ceramicpistol",
		["Name"] = "Ceramic Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.25,
		["Economy"] = 5750
	},
	["WEAPON_PISTOL"] = {
		["Index"] = "pistol",
		["Name"] = "Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.25,
		["Economy"] = 5750
	},
	["WEAPON_PISTOL_MK2"] = {
		["Index"] = "pistolmk2",
		["Name"] = "Pistol Mk II",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},
	["WEAPON_COMPACTRIFLE"] = {
		["Index"] = "akcompact",
		["Name"] = "AK Compact",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 240,
		["Weight"] = 4.25,
		["Economy"] = 13250
	},
	["WEAPON_APPISTOL"] = {
		["Index"] = "appistol",
		["Name"] = "AP Pistol",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 6250
	},
	["WEAPON_HEAVYPISTOL"] = {
		["Index"] = "heavypistol",
		["Name"] = "Heavy Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 725
	},
	["WEAPON_MACHINEPISTOL"] = {
		["Index"] = "machinepistol",
		["Name"] = "Machine Pistol",
		["Type"] = "Armamento",
		["Repair"] = "repairkit03",
		["Ammo"] = "AMMO_45",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 8250
	},
	["WEAPON_MICROSMG"] = {
		["Index"] = "microsmg",
		["Name"] = "Micro SMG",
		["Type"] = "Armamento",
		["Repair"] = "repairkit03",
		["Ammo"] = "AMMO_45",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 13250
	},
	["WEAPON_NAILGUN"] = {
		["Index"] = "nailgun",
		["Name"] = "Arma de Prego",
		["Repair"] = "repairkit01",
		["Type"] = "Armamento",
		["Ammo"] = "WEAPON_NAIL_AMMO",
		["Durability"] = 240,
		["Vehicle"] = false,
		["Weight"] = 4.25,
		["Economy"] = 3250
	},
	["WEAPON_MINISMG"] = {
		["Index"] = "minismg",
		["Name"] = "Mini SMG",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 5.25,
		["Economy"] = 13250
	},
	["WEAPON_SNSPISTOL"] = {
		["Index"] = "snspistol",
		["Name"] = "SNS Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.25,
		["Economy"] = 4750
	},
	["WEAPON_SNSPISTOL_MK2"] = {
		["Index"] = "snspistolmk2",
		["Name"] = "SNS Pistol Mk II",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 5250
	},
	["WEAPON_VINTAGEPISTOL"] = {
		["Index"] = "vintagepistol",
		["Name"] = "Vintage Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 4750
	},
	["WEAPON_PISTOL50"] = {
		["Index"] = "pistol50",
		["Name"] = "Pistol .50",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.75,
		["Economy"] = 8250
	},
	["WEAPON_REVOLVER"] = {
		["Index"] = "revolver",
		["Name"] = "Heavy Revolver",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_REVOLVER_MK2"] = {
		["Index"] = "revolvermk2",
		["Name"] = "Heavy Revolver Mk II",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_MARKSMANPISTOL"] = {
		["Index"] = "marksmanpistol",
		["Name"] = "Marksman Pistol",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_DOUBLEACTION"] = {
		["Index"] = "doubleaction",
		["Name"] = "Double Action Revolver",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_NAVYREVOLVER"] = {
		["Index"] = "navyrevolver",
		["Name"] = "Navy Revolver",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_GADGETPISTOL"] = {
		["Index"] = "gadgetpistol",
		["Name"] = "Perico Pistol",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 4.25,
		["Economy"] = 8250
	},
	["WEAPON_COMBATPISTOL"] = {
		["Index"] = "combatpistol",
		["Name"] = "Combat Pistol",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 625
	},
	["WEAPON_PARAFAL"] = {
		["Index"] = "parafal",
		["Name"] = "PARA-FAL M964A1",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25250
	},
	["WEAPON_FNFAL"] = {
		["Index"] = "fnfal",
		["Name"] = "FN FAL",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 775
	},
	["WEAPON_FNL1A1"] = {
		["Index"] = "fnl1a1",
		["Name"] = "FN L1A1",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 775
	},
	["WEAPON_COLTXM177"] = {
		["Index"] = "coltxm177",
		["Name"] = "Colt XM177",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 775
	},
	["WEAPON_CARBINERIFLE"] = {
		["Index"] = "carbinerifle",
		["Name"] = "Carbine Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 775
	},
	["WEAPON_CARBINERIFLE_MK2"] = {
		["Index"] = "carbineriflemk2",
		["Name"] = "Carbine Rifle Mk II",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 925
	},
	["WEAPON_ADVANCEDRIFLE"] = {
		["Index"] = "advancedrifle",
		["Name"] = "Advanced Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_BULLPUPRIFLE"] = {
		["Index"] = "bullpuprifle",
		["Name"] = "Bullpup Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_BULLPUPRIFLE_MK2"] = {
		["Index"] = "bullpupriflemk2",
		["Name"] = "Bullpup Rifle Mk II",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_SPECIALCARBINE"] = {
		["Index"] = "specialcarbine",
		["Name"] = "Special Carbine",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25000
	},
	["WEAPON_SPECIALCARBINE_MK2"] = {
		["Index"] = "specialcarbinemk2",
		["Name"] = "Special Carbine Mk II",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25000
	},
	["WEAPON_MILITARYRIFLE"] = {
		["Index"] = "militaryrifle",
		["Name"] = "Military Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25000
	},
	["WEAPON_HEAVYRIFLE"] = {
		["Index"] = "heavyrifle",
		["Name"] = "Heavy Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25000
	},
	["WEAPON_TACTICALRIFLE"] = {
		["Index"] = "tacticalrifle",
		["Name"] = "Tactical Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 25000
	},
	["WEAPON_PUMPSHOTGUN"] = {
		["Index"] = "pumpshotgun",
		["Name"] = "Pump Shotgun",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_12",
		["Durability"] = 480,
		["Weight"] = 7.25,
		["Economy"] = 775
	},
	["WEAPON_PUMPSHOTGUN_MK2"] = {
		["Index"] = "pumpshotgunmk2",
		["Name"] = "Pump Shotgun Mk II",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_12",
		["Durability"] = 480,
		["Weight"] = 7.25,
		["Economy"] = 15250
	},
	["WEAPON_MUSKET"] = {
		["Index"] = "musket",
		["Name"] = "Musket",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "WEAPON_MUSKET_AMMO",
		["Durability"] = 480,
		["Weight"] = 6.25,
		["Economy"] = 3250
	},
	["WEAPON_SAWNOFFSHOTGUN"] = {
		["Index"] = "sawnoffshotgun",
		["Name"] = "Sawed-Off Shotgun",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_12",
		["Durability"] = 480,
		["Weight"] = 5.75,
		["Economy"] = 13250
	},
	["WEAPON_SMG"] = {
		["Index"] = "smg",
		["Name"] = "Smg",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.25,
		["Economy"] = 775
	},
	["WEAPON_SMG_MK2"] = {
		["Index"] = "smgmk2",
		["Name"] = "SMG Mk II",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Vehicle"] = true,
		["Weight"] = 5.25,
		["Economy"] = 15250
	},
	["WEAPON_COMBATPDW"] = {
		["Index"] = "combatpdw",
		["Name"] = "Combat PDW",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Vehicle"] = true,
		["Weight"] = 5.25,
		["Economy"] = 15250
	},
	["WEAPON_ASSAULTRIFLE"] = {
		["Index"] = "assaultrifle",
		["Name"] = "Assault Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_ASSAULTRIFLE_MK2"] = {
		["Index"] = "assaultriflemk2",
		["Name"] = "Assault Rifle Mk II",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_ASSAULTSMG"] = {
		["Index"] = "assaultsmg",
		["Name"] = "Assault SMG",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.75,
		["Economy"] = 15250
	},
	["WEAPON_GUSENBERG"] = {
		["Index"] = "gusenberg",
		["Name"] = "Gusenberg Sweeper",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 6.25,
		["Economy"] = 15250
	},
	["WEAPON_PETROLCAN"] = {
		["Index"] = "gallon",
		["Name"] = "Galão",
		["Type"] = "Armamento",
		["Ammo"] = "WEAPON_PETROLCAN_AMMO",
		["Weight"] = 1.25,
		["Economy"] = 50
	},
	["WEAPON_PRECISIONRIFLE"] = {
		["Index"] = "remington700",
		["Name"] = "Remington 700 PCR",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_308",
		["Durability"] = 480,
		["Weight"] = 8.75,
		["Economy"] = 55000
	},

	["WEAPON_M70"] = {
		["Index"] = "m70",
		["Name"] = "M70",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_762",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_AKS74"] = {
		["Index"] = "aksu74",
		["Name"] = "AKS-74u Zenitco",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_762",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_AK74"] = {
		["Index"] = "ak74",
		["Name"] = "AK 74",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_762",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_HK416"] = {
		["Index"] = "hk416",
		["Name"] = "Hk416",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_AR15"] = {
		["Index"] = "ar15",
		["Name"] = "Ar15",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_SCARH"] = {
		["Index"] = "scarh",
		["Name"] = "SCAR-H",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_MK14"] = {
		["Index"] = "mk14",
		["Name"] = "MK14",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_MP9"] = {
		["Index"] = "mp9",
		["Name"] = "MP9",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.25,
		["Economy"] = 775
	},
	["WEAPON_MP5"] = {
		["Index"] = "mp5",
		["Name"] = "MP5",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.25,
		["Economy"] = 775
	},
	["WEAPON_UZI"] = {
		["Index"] = "uzi",
		["Name"] = "Uzi",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.25,
		["Economy"] = 775
	},
	["WEAPON_MAC10"] = {
		["Index"] = "mac10",
		["Name"] = "Mac10",
		["Repair"] = "repairkit03",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_45",
		["Durability"] = 480,
		["Weight"] = 5.25,
		["Economy"] = 775
	},
	["WEAPON_GROZA"] = {
		["Index"] = "groza",
		["Name"] = "OTs-14 Groza",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "WEAPON_RIFLE_AMMO",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25250
	},
	["WEAPON_M4"] = {
		["Index"] = "m4",
		["Name"] = "M4A1",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_AK47"] = {
		["Index"] = "ak47",
		["Name"] = "AK 47",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_762",
		["Durability"] = 480,
		["Weight"] = 7.75,
		["Economy"] = 25000
	},
	["WEAPON_HUNTINGRIFLE"] = {
		["Index"] = "huntingrifle",
		["Name"] = "Hunting Rifle",
		["Repair"] = "repairkit04",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_556",
		["Durability"] = 480,
		["Weight"] = 11,
		["Economy"] = 25000
	},
	["WEAPON_M1911"] = {
		["Index"] = "m1911",
		["Name"] = "colt 1911",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.25,
		["Economy"] = 5750
	},
	["WEAPON_GLOCK18C"] = {
		["Index"] = "glock18c",
		["Name"] = "Glock 18C",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 625
	},
	["WEAPON_GLOCK22"] = {
		["Index"] = "glock22",
		["Name"] = "Glock 22",
		["Description"] = "Government (PD/EMS/DOC) Issued Equipment",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 3.25,
		["Economy"] = 625
	},
	["WEAPON_BROWNING"] = {
		["Index"] = "browning",
		["Name"] = "Browning Hi-Power",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},
	["WEAPON_DB9"] = {
		["Index"] = "db9",
		["Name"] = "Diamondback FS9",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},
	["WEAPON_FIVESEVEN"] = {
		["Index"] = "fiveseven",
		["Name"] = "FN Five-seven",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},
	["WEAPON_FN57"] = {
		["Index"] = "fn57",
		["Name"] = "FN57",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},
	["WEAPON_M9"] = {
		["Index"] = "m9",
		["Name"] = "Beretta M9",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Ammo"] = "AMMO_9",
		["Durability"] = 240,
		["Vehicle"] = true,
		["Weight"] = 2.75,
		["Economy"] = 7250
	},

	["GADGET_PARACHUTE"] = {
		["Index"] = "parachute",
		["Name"] = "Paraquedas",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Economy"] = 475
	},
	["WEAPON_FLAREGUN"] = {
		["Index"] = "flaregun",
		["Name"] = "Flare Gun",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Durability"] = 480,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_STUNGUN"] = {
		["Index"] = "stungun",
		["Name"] = "Tazer",
		["Repair"] = "repairkit02",
		["Type"] = "Armamento",
		["Durability"] = 480,
		["Weight"] = 0.75,
		["Economy"] = 525
	},
	["WEAPON_NAIL_AMMO"] = {
		["Index"] = "nails",
		["Name"] = "Pregos",
		["Type"] = "Munição",
		["Weight"] = 0.05,
		["Economy"] = 2
	},
	["AMMO_9"] = {
		["Index"] = "pistolammo",
		["Name"] = "Munição 9×19mm",
		["Type"] = "Munição",
		["Weight"] = 0.035,
		["Economy"] = 35,
		["Stack"] = 128,
	},
	["AMMO_45"] = {
		["Index"] = "smgammo",
		["Name"] = "Munição .45 ACP",
		["Type"] = "Munição",
		["Weight"] = 0.045,
		["Economy"] = 40,
		["Stack"] = 128,
	},
	["AMMO_556"] = {
		["Index"] = "ammo556",
		["Name"] = "Munição 5,56×45mm",
		["Type"] = "Munição",
		["Weight"] = 0.055,
		["Economy"] = 45,
		["Stack"] = 128,
	},
	["AMMO_762"] = {
		["Index"] = "ammo762",
		["Name"] = "Munição 7,62×51mm",
		["Type"] = "Munição",
		["Weight"] = 0.055,
		["Economy"] = 45,
		["Stack"] = 128,
	},
	["AMMO_12"] = {
		["Index"] = "shotgunammo",
		["Name"] = "Munição de Escopeta" --[[ "Munição 5,56×45mm" ]],
		["Type"] = "Munição",
		["Weight"] = 0.075,
		["Economy"] = 40,
		["Stack"] = 128,
	},
	["WEAPON_MUSKET_AMMO"] = {
		["Index"] = "musketammo",
		["Name"] = "Munição de Mosquete",
		["Type"] = "Munição",
		["Weight"] = 0.075,
		["Economy"] = 7
	},
	["WEAPON_PETROLCAN_AMMO"] = {
		["Index"] = "fuel",
		["Name"] = "Combustível",
		["Type"] = "Munição",
		["Weight"] = 0.001,
		["Economy"] = 0
	},
	["WEAPON_FLAMETHROWER_AMMO"] = {
		["Index"] = "flamethrowerammo",
		["Name"] = "Combustível",
		["Type"] = "Munição",
		["Weight"] = 0.001,
		["Economy"] = 0
	},
	["AMMO_308"] = {
		["Index"] = "rifleammo",
		["Name"] = "Munição de Sniper",
		["Type"] = "Munição",
		["Weight"] = 0.095,
		["Economy"] = 50
	},
	["WEAPON_BRICK"] = {
		["Index"] = "brick",
		["Name"] = "Tijolo",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["WEAPON_CASH"] = {
		["Index"] = "cash",
		["Name"] = "Cash",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["WEAPON_BOOK"] = {
		["Index"] = "book",
		["Name"] = "Book",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["WEAPON_SNOWBALL"] = {
		["Index"] = "snowball",
		["Name"] = "Bola de Neve",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.55,
		["Economy"] = 6
	},
	["WEAPON_SHOES"] = {
		["Index"] = "shoes",
		["Name"] = "Tênis",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.755,
		["Economy"] = 25
	},
	["WEAPON_MOLOTOV"] = {
		["Index"] = "molotov",
		["Name"] = "Coquetel Molotov",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.95,
		["Economy"] = 225,
		["Max"] = 3
	},
	["WEAPON_GRENADE"] = {
		["Index"] = "grenade",
		["Name"] = "Granada",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.95,
		["Economy"] = 225,
		["Max"] = 3
	},
	["WEAPON_SMOKEGRENADE"] = {
		["Index"] = "smokegrenade",
		["Name"] = "Granada de Fumaça",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.95,
		["Economy"] = 225,
		["Max"] = 3
	},
	["WEAPON_FLASHBANG"] = {
		["Index"] = "flashbang",
		["Name"] = "Granada de Luz",
		["Type"] = "Throwing",
		["Vehicle"] = true,
		["Weight"] = 0.95,
		["Economy"] = 225,
		["Max"] = 3
	},
	["gravel"] = {
		["Index"] = "gravel",
		["Name"] = "Cascalho",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 85
	},
	["sieve"] = {
		["Index"] = "sieve",
		["Name"] = "Peneira",
		["Type"] = "Usável",
		["Weight"] = 0.55,
		["Economy"] = 75
	},
	["miningpan"] = {
		["Index"] = "miningpan",
		["Name"] = "Prato para Mineração",
		["Type"] = "Usável",
		["Weight"] = 0.55,
		["Economy"] = 75
	},
	["pager"] = {
		["Index"] = "pager",
		["Name"] = "Pager",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Economy"] = 125
	},
	["firecracker"] = {
		["Index"] = "firecracker",
		["Name"] = "Fogos de Artificio",
		["Type"] = "Usável",
		["Weight"] = 2.25,
		["Economy"] = 100
	},
	["analgesic"] = {
		["Index"] = "analgesic",
		["Name"] = "Analgésico",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 5,
		["Economy"] = 125
	},
	["oxy"] = {
		["Index"] = "analgesic",
		["Name"] = "Oxy",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 5,
		["Economy"] = 35
	},
	["gauze"] = {
		["Index"] = "gauze",
		["Name"] = "Ataduras",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Max"] = 5,
		["Economy"] = 100
	},
	["gsrkit"] = {
		["Index"] = "gsrkit",
		["Name"] = "Kit Residual",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 20
	},
	["gdtkit"] = {
		["Index"] = "gdtkit",
		["Name"] = "Kit Químico",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 20
	},
	["stone"] = {
		["Index"] = "stone",
		["Name"] = "Pedra",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["goldore"] = {
		["Index"] = "goldore",
		["Name"] = "Minério de Ouro",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["copperore"] = {
		["Index"] = "copperore",
		["Name"] = "Minério de Cobre",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["leadore"] = {
		["Index"] = "leadore",
		["Name"] = "Minério de Chumbo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 85
	},
	["ironore"] = {
		["Index"] = "ironore",
		["Name"] = "Minério de Ferro",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["emeraldore"] = {
		["Index"] = "emeraldore",
		["Name"] = "Minério de Esmeralda",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["emeraldore"] = {
		["Index"] = "emeraldore",
		["Name"] = "Minério de Esmeralda",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["diamondore"] = {
		["Index"] = "diamondore",
		["Name"] = "Minério de Diamante",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 75
	},
	["rubyore"] = {
		["Index"] = "rubyore",
		["Name"] = "Minério de Rubi",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 55
	},
	["sapphireore"] = {
		["Index"] = "sapphireore",
		["Name"] = "Minério de Safira",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 45
	},
	["emerald"] = {
		["Index"] = "emerald",
		["Name"] = "Esmeralda",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 85
	},
	["diamond"] = {
		["Index"] = "diamond",
		["Name"] = "Diamante",
		["Type"] = "Comum",
		["Weight"] = 0.95,
		["Economy"] = 75
	},
	["ruby"] = {
		["Index"] = "ruby",
		["Name"] = "Rubi",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 55
	},
	["sapphire"] = {
		["Index"] = "sapphire",
		["Name"] = "Safira",
		["Type"] = "Comum",
		["Weight"] = 0.85,
		["Economy"] = 45
	},
	["amethyst"] = {
		["Index"] = "amethyst",
		["Name"] = "Ametista",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 35
	},
	["amber"] = {
		["Index"] = "amber",
		["Name"] = "Âmbar",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["goldnugget"] = {
		["Index"] = "goldnugget",
		["Name"] = "Pepita de Ouro",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["jadeite"] = {
		["Index"] = "jadeite",
		["Name"] = "Pedra Jadeíta",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 25
	},
	["turquoise"] = {
		["Index"] = "turquoise",
		["Name"] = "Turquesa",
		["Type"] = "Comum",
		["Weight"] = 0.65,
		["Economy"] = 15
	},
	["lead"] = {
		["Index"] = "lead",
		["Name"] = "Chumbo",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 85
	},
	["sulfur"] = {
		["Index"] = "sulfur",
		["Name"] = "Enxofre",
		["Type"] = "Comum",
		["Weight"] = 0.35
	},
	["keyboard"] = {
		["Index"] = "keyboard",
		["Name"] = "Teclado",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 75
	},
	["mouse"] = {
		["Index"] = "mouse",
		["Name"] = "Mouse",
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 75
	},
	["alianca"] = {
		["Index"] = "goldring",
		["Name"] = "Aliança de casamento ",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["silverring"] = {
		["Index"] = "silverring",
		["Name"] = "Anel de Prata",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["goldring"] = {
		["Index"] = "goldring",
		["Name"] = "Anel de Ouro",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 100
	},
	["silvercoin"] = {
		["Index"] = "silvercoin",
		["Name"] = "Moeda de Prata",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 20
	},
	["goldcoin"] = {
		["Index"] = "goldcoin",
		["Name"] = "Moeda de Ouro",
		["Type"] = "Usável",
		["Weight"] = 0.05,
		["Economy"] = 40
	},
	["watch"] = {
		["Index"] = "watch",
		["Name"] = "Relógio",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 75
	},
	["playstation"] = {
		["Index"] = "playstation",
		["Name"] = "Playstation",
		["Type"] = "Comum",
		["Weight"] = 2.25,
		["Economy"] = 75
	},
	["xbox"] = {
		["Index"] = "xbox",
		["Name"] = "Xbox",
		["Type"] = "Comum",
		["Weight"] = 2.25,
		["Economy"] = 75
	},
	["nintendo"] = {
		["Index"] = "nintendoswitch",
		["Name"] = "Nintendo",
		["Type"] = "Comum",
		["Weight"] = 2.25,
		["Economy"] = 75
	},
	["legos"] = {
		["Index"] = "legos",
		["Name"] = "Legos",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 75
	},
	["ominitrix"] = {
		["Index"] = "ominitrix",
		["Name"] = "Ominitrix",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 75
	},
	["bracelet"] = {
		["Index"] = "bracelet",
		["Name"] = "Bracelete",
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 75
	},
	["dildo"] = {
		["Index"] = "dildo",
		["Name"] = "Vibrador",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 75
	},
	["spray01"] = {
		["Index"] = "spray01",
		["Name"] = "Desodorante 24hrs",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["spray02"] = {
		["Index"] = "spray02",
		["Name"] = "Antisséptico",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["spray03"] = {
		["Index"] = "spray03",
		["Name"] = "Desodorante 48hrs",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["spray04"] = {
		["Index"] = "spray04",
		["Name"] = "Desodorante 72hrs",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["dices"] = {
		["Index"] = "dices",
		["Name"] = "Dados",
		["Type"] = "Usável",
		["Weight"] = 0.35,
		["Economy"] = 45
	},
	["dish"] = {
		["Index"] = "dish",
		["Name"] = "Prato",
		["Type"] = "Comum",
		["Weight"] = 0.55,
		["Economy"] = 75
	},
	["pan"] = {
		["Index"] = "pan",
		["Name"] = "Panela",
		["Type"] = "Usável",
		["Weight"] = 0.55,
		["Economy"] = 100
	},
	["fan"] = {
		["Index"] = "fan",
		["Name"] = "Ventilador",
		["Type"] = "Comum",
		["Weight"] = 1.15,
		["Economy"] = 75
	},
	["rimel"] = {
		["Index"] = "rimel",
		["Name"] = "Rímel",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["blender"] = {
		["Index"] = "blender",
		["Name"] = "Liquidificador",
		["Type"] = "Usável",
		["Weight"] = 0.75,
		["Economy"] = 75
	},
	["switch"] = {
		["Index"] = "switch",
		["Name"] = "Interruptor",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 45
	},
	["horseshoe"] = {
		["Index"] = "horseshoe",
		["Name"] = "Ferradura",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 75
	},
	["brush"] = {
		["Index"] = "brush",
		["Name"] = "Escova",
		["Type"] = "Comum",
		["Weight"] = 0.25,
		["Economy"] = 75
	},
	["domino"] = {
		["Index"] = "domino",
		["Name"] = "Dominó",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 45
	},
	["floppy"] = {
		["Index"] = "floppy",
		["Name"] = "Disquete",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 45
	},
	["cup"] = {
		["Index"] = "cup",
		["Name"] = "Cálice",
		["Type"] = "Comum",
		["Weight"] = 0.45,
		["Economy"] = 100
	},
	["styrofoamcup"] = {
		["Index"] = "styrofoamcup",
		["Name"] = "Copo de Isopor",
		["Type"] = "Comum",
		["Weight"] = 0.05,
		["Economy"] = 100
	},
	["deck"] = {
		["Index"] = "deck",
		["Name"] = "Baralho",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 75
	},
	["eraser"] = {
		["Index"] = "eraser",
		["Name"] = "Apagador",
		["Type"] = "Comum",
		["Weight"] = 0.15,
		["Economy"] = 75
	},
	["pliers"] = {
		["Index"] = "pliers",
		["Name"] = "Alicate",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 55
	},
	["screwdriver"] = {
		["Index"] = "screwdriver",
		["Name"] = "Chave de fenda",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 55
	},
	["lampshade"] = {
		["Index"] = "lampshade",
		["Name"] = "Abajur",
		["Type"] = "Comum",
		["Weight"] = 0.75,
		["Economy"] = 75
	},
	["soap"] = {
		["Index"] = "soap",
		["Name"] = "Sabonete",
		["Type"] = "Usável",
		["Weight"] = 0.25,
		["Economy"] = 75
	},
	["slipper"] = {
		["Index"] = "slipper",
		["Name"] = "Chinelo",
		["Type"] = "Comum",
		["Weight"] = 0.35,
		["Economy"] = 75
	},
	["pendrive"] = {
		["Index"] = "pendrive",
		["Name"] = "Pendrive",
		["Repair"] = "repairkit01",
		["Type"] = "Comum",
		["Durability"] = 240,
		["Weight"] = 0.75,
		["Economy"] = 325
	},
	["chair31"] = {
		["Index"] = "chair31",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 31",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair50"] = {
		["Index"] = "chair50",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 50",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair2"] = {
		["Index"] = "chair2",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 2",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair30"] = {
		["Index"] = "chair30",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 30",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair15"] = {
		["Index"] = "chair15",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 15",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair33"] = {
		["Index"] = "chair33",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 33",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair55"] = {
		["Index"] = "chair55",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 55",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair90"] = {
		["Index"] = "chair90",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 90",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair110"] = {
		["Index"] = "chair110",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 110",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair69"] = {
		["Index"] = "chair69",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 69",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair102"] = {
		["Index"] = "chair102",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 102",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair29"] = {
		["Index"] = "chair29",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 29",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair10"] = {
		["Index"] = "chair10",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 10",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair59"] = {
		["Index"] = "chair59",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 59",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair20"] = {
		["Index"] = "chair20",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 20",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair73"] = {
		["Index"] = "chair73",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 73",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair32"] = {
		["Index"] = "chair32",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 32",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair88"] = {
		["Index"] = "chair88",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 88",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair64"] = {
		["Index"] = "chair64",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 64",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair62"] = {
		["Index"] = "chair62",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 62",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair71"] = {
		["Index"] = "chair71",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 71",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair48"] = {
		["Index"] = "chair48",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 48",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair56"] = {
		["Index"] = "chair56",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 56",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair22"] = {
		["Index"] = "chair22",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 22",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair39"] = {
		["Index"] = "chair39",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 39",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair51"] = {
		["Index"] = "chair51",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 51",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair36"] = {
		["Index"] = "chair36",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 36",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair11"] = {
		["Index"] = "chair11",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 11",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair75"] = {
		["Index"] = "chair75",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 75",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair108"] = {
		["Index"] = "chair108",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 108",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair44"] = {
		["Index"] = "chair44",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 44",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair107"] = {
		["Index"] = "chair107",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 107",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair109"] = {
		["Index"] = "chair109",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 109",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair14"] = {
		["Index"] = "chair14",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 14",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair3"] = {
		["Index"] = "chair3",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 3",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair85"] = {
		["Index"] = "chair85",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 85",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair12"] = {
		["Index"] = "chair12",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 12",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair78"] = {
		["Index"] = "chair78",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 78",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair103"] = {
		["Index"] = "chair103",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 103",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair101"] = {
		["Index"] = "chair101",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 101",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair70"] = {
		["Index"] = "chair70",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 70",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair84"] = {
		["Index"] = "chair84",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 84",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair94"] = {
		["Index"] = "chair94",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 94",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair79"] = {
		["Index"] = "chair79",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 79",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair34"] = {
		["Index"] = "chair34",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 34",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair98"] = {
		["Index"] = "chair98",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 98",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair6"] = {
		["Index"] = "chair6",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 6",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair8"] = {
		["Index"] = "chair8",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 8",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair97"] = {
		["Index"] = "chair97",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 97",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair96"] = {
		["Index"] = "chair96",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 96",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair49"] = {
		["Index"] = "chair49",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 49",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair95"] = {
		["Index"] = "chair95",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 95",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair25"] = {
		["Index"] = "chair25",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 25",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair72"] = {
		["Index"] = "chair72",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 72",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair99"] = {
		["Index"] = "chair99",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 99",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair87"] = {
		["Index"] = "chair87",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 87",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair27"] = {
		["Index"] = "chair27",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 27",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair53"] = {
		["Index"] = "chair53",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 53",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair65"] = {
		["Index"] = "chair65",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 65",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair92"] = {
		["Index"] = "chair92",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 92",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair91"] = {
		["Index"] = "chair91",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 91",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair89"] = {
		["Index"] = "chair89",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 89",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair86"] = {
		["Index"] = "chair86",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 86",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair54"] = {
		["Index"] = "chair54",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 54",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair63"] = {
		["Index"] = "chair63",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 63",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair106"] = {
		["Index"] = "chair106",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 106",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair24"] = {
		["Index"] = "chair24",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 24",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair40"] = {
		["Index"] = "chair40",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 40",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair74"] = {
		["Index"] = "chair74",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 74",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair104"] = {
		["Index"] = "chair104",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 104",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair16"] = {
		["Index"] = "chair16",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 16",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair66"] = {
		["Index"] = "chair66",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 66",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair42"] = {
		["Index"] = "chair42",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 42",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair82"] = {
		["Index"] = "chair82",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 82",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair43"] = {
		["Index"] = "chair43",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 43",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair76"] = {
		["Index"] = "chair76",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 76",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair9"] = {
		["Index"] = "chair9",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 9",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair77"] = {
		["Index"] = "chair77",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 77",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair100"] = {
		["Index"] = "chair100",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 100",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair13"] = {
		["Index"] = "chair13",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 13",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair37"] = {
		["Index"] = "chair37",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 37",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair57"] = {
		["Index"] = "chair57",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 57",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair38"] = {
		["Index"] = "chair38",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 38",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair67"] = {
		["Index"] = "chair67",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 67",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair80"] = {
		["Index"] = "chair80",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 80",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair26"] = {
		["Index"] = "chair26",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 26",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair47"] = {
		["Index"] = "chair47",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 47",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair93"] = {
		["Index"] = "chair93",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 93",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair1"] = {
		["Index"] = "chair1",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 1",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair60"] = {
		["Index"] = "chair60",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 60",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair21"] = {
		["Index"] = "chair21",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 21",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair4"] = {
		["Index"] = "chair4",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 4",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair18"] = {
		["Index"] = "chair18",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 18",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair19"] = {
		["Index"] = "chair19",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 19",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair46"] = {
		["Index"] = "chair46",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 46",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair41"] = {
		["Index"] = "chair41",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 41",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair7"] = {
		["Index"] = "chair7",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 7",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair35"] = {
		["Index"] = "chair35",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 35",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair81"] = {
		["Index"] = "chair81",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 81",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair23"] = {
		["Index"] = "chair23",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 23",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair105"] = {
		["Index"] = "chair105",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 105",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair28"] = {
		["Index"] = "chair28",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 28",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair58"] = {
		["Index"] = "chair58",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 58",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair68"] = {
		["Index"] = "chair68",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 68",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair83"] = {
		["Index"] = "chair83",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 83",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair5"] = {
		["Index"] = "chair5",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 5",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair52"] = {
		["Index"] = "chair52",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 52",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair17"] = {
		["Index"] = "chair17",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 17",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair45"] = {
		["Index"] = "chair45",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 45",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
	["chair61"] = {
		["Index"] = "chair61",
		["Weight"] = 5.25,
		["Name"] = "Cadeira 61",
		["Type"] = "Usável",
		["Economy"] = 2750,
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBODY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBody(Item)
	local Item = SplitOne(Item)
	if List[Item] then
		return List[Item]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMINDEX
-----------------------------------------------------------------------------------------------------------------------------------------
function itemIndex(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Index"] then
		return List[Item]["Index"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMNAME
-----------------------------------------------------------------------------------------------------------------------------------------
function itemName(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Name"] then
		return List[Item]["Name"]
	end
	return "Deletado"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMTYPE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemType(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Type"] then
		return List[Item]["Type"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMAMMO
-----------------------------------------------------------------------------------------------------------------------------------------
function itemAmmo(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Ammo"] then
		return List[Item]["Ammo"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMVEHICLE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemVehicle(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Vehicle"] then
		return List[Item]["Vehicle"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMWEIGHT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemWeight(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Weight"] then
		return List[Item]["Weight"]
	end
	return 0.0
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMMAXAMOUNT
-----------------------------------------------------------------------------------------------------------------------------------------
function itemMaxAmount(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Max"] then
		return List[Item]["Max"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- itemStack
-----------------------------------------------------------------------------------------------------------------------------------------
function itemStack(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Stack"] then
		return List[Item]["Stack"]
	end
	return 100000000000
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMSCAPE
-----------------------------------------------------------------------------------------------------------------------------------------
function itemScape(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Scape"] then
		return List[Item]["Scape"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDESCRIPTION
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDescription(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Description"] then
		return List[Item]["Description"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMDURABILITY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemDurability(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Durability"] then
		return List[Item]["Durability"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMCHARGES
-----------------------------------------------------------------------------------------------------------------------------------------
function itemCharges(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Charges"] then
		return List[Item]["Charges"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMECONOMY
-----------------------------------------------------------------------------------------------------------------------------------------
function itemEconomy(Item,Format)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Economy"] then
		return "$"..parseFormat(List[Item]["Economy"])
	end
	return "S/V"
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMREPAIR
-----------------------------------------------------------------------------------------------------------------------------------------
function itemRepair(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Repair"] then
		return List[Item]["Repair"]
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKCLEAR
-----------------------------------------------------------------------------------------------------------------------------------------
function BlockClear(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Clear"] then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- ITEMBLOCK
-----------------------------------------------------------------------------------------------------------------------------------------
function itemBlock(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Block"] then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- BLOCKDROPS
-----------------------------------------------------------------------------------------------------------------------------------------
function BlockDrops(Item)
	local Item = SplitOne(Item)
	if List[Item] and List[Item]["Drops"] then
		return true
	end
	return false
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------------------------------------------------------------
function itemChest(Item)
	local Item = SplitOne(Item)
	if List[Item] then
		if Item == "ciggypack" then
			return true
		elseif Item == "ollyrancherbag" then
			return true
		elseif Item == "wallet" then
			return true
		elseif Item == "suitcase" then
			return true
		elseif Item == "ammo9box" then
			return true
		elseif Item == "ammo45box" then
			return true
		elseif Item == "ammo556box" then
			return true
		elseif Item == "ammo12box" then
			return true
		end
	end
	return false
end