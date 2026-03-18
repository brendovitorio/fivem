-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	["Admin"] = {
		["Parent"] = {
			["Admin"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.blips"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["Police"] = true,
			["Paramedic"] = true,
			["player.blips"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.noclip"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["player.noclip"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.teleport"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["player.teleport"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.secret"] = {		
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["player.secret"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.spec"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["player.spec"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["spec.permissao"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["spec.permissao"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.wall"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["player.wall"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["mqcu.permissao"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["mqcu.permissao"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},
	["player.som"] = {
		["Parent"] = {
			["Admin"] = true,
			["Moderator"] = true,
			["Suporte"] = true,
			["Favela"] = true,
			["Infinity"] = true,
			["Metralha"] = true,
			["Foguetao"] = true,
			["Magnata"] = true,
			["player.som"] = true
		},
		["Hierarchy"] = { "Administrador","Moderador","Suporte" },
		["Service"] = {}
	},

	["Premium"] = {
		["Parent"] = {
			["Bronze"] = true,
			["Prata"] = true,
			["Ouro"] = true,
			["Platina"] = true,
			["Favela"] = true,
			["Infinity"] = true,
			["Metralha"] = true,
			["Foguetao"] = true,
			["Magnata"] = true,
		},
		["Hierarchy"] = {},
		["Salary"] = {},
		["Service"] = {}
	},
	["Bronze"] = {
		["Parent"] = {
			["Bronze"] = true
		},
		["Hierarchy"] = { "Bronze" },
		["Salary"] = { 150 },
		["Service"] = {}
	},
	["Prata"] = {
		["Parent"] = {
			["Prata"] = true
		},
		["Hierarchy"] = { "Prata" },
		["Salary"] = { 300 },
		["Service"] = {}
	},
	["Ouro"] = {
		["Parent"] = {
			["Ouro"] = true
		},
		["Hierarchy"] = { "Ouro" },
		["Salary"] = { 350 },
		["Service"] = {}
	},
	["Platina"] = {
		["Parent"] = {
			["Platina"] = true
		},
		["Hierarchy"] = { "Platina" },
		["Salary"] = { 400 },
		["Service"] = {}
	},
	["Favela"] = {
		["Parent"] = {
			["Favela"] = true
		},
		["Hierarchy"] = { "Favela" },
		["Salary"] = { 450 },
		["Service"] = {}
	},
	["Infinity"] = {
		["Parent"] = {
			["Infinity"] = true
		},
		["Hierarchy"] = { "Infinity" },
		["Salary"] = { 550 },
		["Service"] = {}
	},
	["Metralha"] = {
		["Parent"] = {
			["Metralha"] = true
		},
		["Hierarchy"] = { "Metralha" },
		["Salary"] = { 700 },
		["Service"] = {}
	},
	["Foguetao"] = {
		["Parent"] = {
			["Foguetao"] = true
		},
		["Hierarchy"] = { "Foguetao" },
		["Salary"] = { 900 },
		["Service"] = {}
	},
	["Magnata"] = {
		["Parent"] = {
			["Magnata"] = true
		},
		["Hierarchy"] = { "Magnata" },
		["Salary"] = { 1100 },
		["Service"] = {}
	},

	["Police"] = {
		["Parent"] = {
			["Police"] = true
		},
		["Hierarchy"] = { "Chefe","Capitão","Tenente","Sargento","Corporal","Oficial","Cadete" },
		["Salary"] = { 10000,8000,7000,4000,3500,3000,2500 }, 
		["Service"] = {},
		["Type"] = "Work"
	},
	["Paramedic"] = {
		["Parent"] = {
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Chefe","Conselheiro","Membro" },
		["Salary"] = { 2500,2250,2000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Emergency"] = {
		["Parent"] = {
			["Police"] = true,
			["Paramedic"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Service"] = {}
	},

	["Mechanic"] = {
		["Parent"] = {
			["AutoSport"] = true,
			["EastCustoms"] = true,
		},
		["Hierarchy"] = { "Membro" },
		["Service"] = {}
	},
	["AutoSport"] = {
		["Parent"] = {
			["AutoSport"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 3500,3250,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},
	["EastCustoms"] = {
		["Parent"] = {
			["EastCustoms"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Membro" },
		["Salary"] = { 3500,3250,3000 },
		["Service"] = {},
		["Type"] = "Work"
	},

	["FastFood"] = {
		["Parent"] = {
			["BurgerShot"] = true,
			["CluckinBell"] = true,
		},
		["Hierarchy"] = { "Membro" },
		["Service"] = {}
	},
	["BurgerShot"] = {
		["Parent"] = {
			["BurgerShot"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Funcionário" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["CluckinBell"] = {
		["Parent"] = {
			["CluckinBell"] = true
		},
		["Hierarchy"] = { "Chefe","Gerente","Funcionário" },
		["Service"] = {},
		["Type"] = "Work"
	},

	
	["Buff"] = {
		["Parent"] = {
			["Buff"] = true
		},
		["Hierarchy"] = { "Chefe" },
		["Salary"] = { 2250 },
		["Service"] = {}
	},

	["Ilegal"] = { -- LAVAGEM
		["Parent"] = {
			["MoneyLaundry"] = true,
			["MoneyLaundry2"] = true,
		},
	},
	["Ilegal2"] = { -- ARMAS
		["Parent"] = {
			["Weapons"] = true,
			["Weapons2"] = true,
		},
	},
	["Ilegal3"] = { -- Munição
		["Parent"] = {
			["Ammos"] = true,
			["Ammos2"] = true,
		},
	},
	["Ilegal4"] = { -- Contrabando
		["Parent"] = {
			["Smuggling"] = true,
			["Smuggling2"] = true,
		},
	},

	["MoneyLaundry"] = {
		["Parent"] = {
			["MoneyLaundry"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["MoneyLaundry2"] = {
		["Parent"] = {
			["MoneyLaundry2"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Weapons"] = {
		["Parent"] = {
			["Weapons"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Weapons2"] = {
		["Parent"] = {
			["Weapons2"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Ammos"] = {
		["Parent"] = {
			["Ammos"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Ammos2"] = {
		["Parent"] = {
			["Ammos2"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Smuggling"] = {
		["Parent"] = {
			["Smuggling"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	["Smuggling2"] = {
		["Parent"] = {
			["Smuggling2"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},

	["Desmanche"] = {
		["Parent"] = {
			["Desmanche"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Work"
	},
	-- Desmanche
	["China"] = {
		["Parent"] = {
			["China"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	
	["Escocia"] = {
		["Parent"] = {
			["ESCOCIA"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Turquia"] = {
		["Parent"] = {
			["Turquia"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Croacia"] = {
		["Parent"] = {
			["Croacia"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Franca"] = {
		["Parent"] = {
			["Franca"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Israel"] = {
		["Parent"] = {
			["Israel"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Brasilandia"] = {
		["Parent"] = {
			["Brasilandia"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Suecia"] = {
		["Parent"] = {
			["Suecia"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
	["Pcc"] = {
		["Parent"] = {
			["Pcc"] = true
		},
		["Hierarchy"] = { "Chefe","Sub-Chefe","Gerente","Conselheiro","Membro" },
		["Service"] = {},
		["Type"] = "Favela"
	},
}