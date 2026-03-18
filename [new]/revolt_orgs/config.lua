Config = {}

Config.framework = 'revolt' -- Coloque o nome do seu framework aqui, caso queira pular a detecção automática. (ex: vrp, vrpex, creativenw, creativev5)

Config.Main = {
    cmd = 'org', -- Comando para abrir Painel
    cmdAdm = 'facadm', -- Comando para abrir Painel Admin
    createAutomaticOrganizations = true,
    storeUrl = '', -- Link da Sua Loja
    serverLogo = "https://cdn.discordapp.com/attachments/1451260658720182333/1473474221295534248/Screenshot_20260217-1905222.png?ex=69a18c0e&is=69a03a8e&hm=eca2793af0eed8a4ea32fbf208331e2e141893d32754a8036177c12d626360b2&",
    blackListIlegal = 7,
    blackList = 7,
    clearChestLogs = 15, -- Logs do Bau limpar automaticamente de 15 em 15 dias. ( Evitar consumo da tabela )
}

Config.weebhooks = {
    Withdraw = 'https://discord.com/api/webhooks/1349201107511021659/ZuCHiwrjxZ17RPjuxjkkCHWqGfD6W31COCBPMf1_cgnGZ9lekoVgTT35y_IdD6KPsq66',
    Deposit = 'https://discord.com/api/webhooks/1349201151157075968/1m9uE1Y_iVUF7cSn0xkZ7ZrGyaAVwMoWCp_6VzmevnBXoV_HV_QdrbuPzyBYK9-avRWR',
}

Config.defaultPermissions = { 
    invite = { -- Permissao Para Convidar
        name = "Convidar",
        description = "Esta permissao permite vc convidar as pessoas para sua facção."
    },
    demote = { -- Permissao Para Rebaixar
        name = "Rebaixar",
        description = "Essa permissão permite que o cargo selecionado rebaixe um cargo inferior."
    }, 
    promote = { -- Permissao Para Promover
        name = "Promover",
        description = "Essa permissão permite que o cargo selecionado promova um cargo."
    }, 
    dismiss = { -- Permissao Para Rebaixar
        name = "Demitir",
        description = "Essa permissão permite que o cargo selecionado demita um cargo inferior."
    }, 
    withdraw = { -- Permissao Para Sacar Dinheiro
        name = "Sacar dinheiro",
        description = "Permite que esse cargo selecionado possa sacar dinheiro do banco da facção."
    }, 
    deposit = { -- Permissao Para Depositar Dinheiro
        name = "Depositar dinheiro",
        description = "Permite que esse cargo selecionado possa depositar dinheiro no banco da facção."
    }, 
    message = { -- Permissao para Escrever nas anotaçoes
        name = "Escrever anotações",
        description = "Permite que esse cargo selecionado possa escrever anotações."
    },
    alerts = { -- Permissao para enviar alertas
        name = "Escrever Alertas",
        description = "Permite que esse cargo selecionado possa enviar alertas para todos jogadores."
    },
    chat = { -- Permissao para Falar no chat
        name = "Escrever no chat",
        description = "Permite que esse cargo selecionado possa se comunicar no chat da facção"
    },
}

Config.ItemsTemplate = {
    armas = {
        ["pecadearma"] = 10,
    },
    municao = {
        ['money'] = 1000000,
        ["capsulas"] = 50,
        ["polvora"] = 50,
    },
    lavagem = {
        ['dirty_money'] = 1000000,
        ['l-alvejante'] = 50,
        ['money'] = 50,
    },
    drogasAzul = {
        ['anfetamina'] = 1000000,
        ['ferro'] = 1000000,
        ['aluminio'] = 1000000,
    },
    drogasVermelha = {
        ['morfina'] = 1000000,
        ['ferro'] = 1000000,
        ['aluminio'] = 1000000,
    },
    drogasPreta = {
        ['pastabase'] = 1000000,
        ['ferro'] = 1000000,
        ['aluminio'] = 1000000,
    },
    drogasAmarela = {
        ['podemd'] = 1000000,
        ['ferro'] = 1000000,
        ['aluminio'] = 1000000,
    },
    drogasVerde = {
        ['folhamaconha'] = 1000000,
        ['ferro'] = 1000000,
        ['aluminio'] = 1000000,
    },
    legal = {
        ['money'] = 1000000,
    }
}

Config.DefaultSallary = {
    active = false,
    amount = 2000,
    time = 30,
}

Config.Groups = {
    ['Franca'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [FRANCA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [FRANCA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [FRANCA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [FRANCA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [FRANCA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [FRANCA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Korea'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [KOREA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [KOREA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [KOREA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [KOREA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [KOREA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [KOREA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Pcc'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [PCC]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [PCC]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [PCC]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [PCC]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [PCC]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [PCC]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Milicia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [MILICIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MILICIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MILICIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MILICIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MILICIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MILICIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Mercenarios'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [MERCENARIOS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MERCENARIOS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MERCENARIOS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MERCENARIOS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MERCENARIOS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MERCENARIOS]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Mafia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [MAFIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MAFIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MAFIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MAFIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MAFIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MAFIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Abutres'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [ABUTRES]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [ABUTRES]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [ABUTRES]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [ABUTRES]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [ABUTRES]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [ABUTRES]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Corleone'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [CORLEONE]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [CORLEONE]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [CORLEONE]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [CORLEONE]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [CORLEONE]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [CORLEONE]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Croacia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [CROACIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [CROACIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [CROACIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [CROACIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [CROACIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [CROACIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Turquia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.armas }, },
        List = {
            ['Lider [TURQUIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [TURQUIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [TURQUIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [TURQUIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [TURQUIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [TURQUIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Grota'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [GROTA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [GROTA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [GROTA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [GROTA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [GROTA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [GROTA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Inglaterra'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [INGLATERRA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [INGLATERRA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [INGLATERRA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [INGLATERRA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [INGLATERRA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [INGLATERRA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Egito'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [EGITO]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [EGITO]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [EGITO]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [EGITO]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [EGITO]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [EGITO]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Bélgica'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [BÉLGICA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [BÉLGICA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [BÉLGICA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [BÉLGICA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [BÉLGICA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [BÉLGICA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Anonymous'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [ANONYMOUS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [ANONYMOUS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [ANONYMOUS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [ANONYMOUS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [ANONYMOUS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [ANONYMOUS]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Colombia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [COLOMBIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [COLOMBIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [COLOMBIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [COLOMBIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [COLOMBIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [COLOMBIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Yakuza'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [YAKUZA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [YAKUZA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [YAKUZA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [YAKUZA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [YAKUZA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [YAKUZA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Bratva'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [BRATVA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [BRATVA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [BRATVA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [BRATVA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [BRATVA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [BRATVA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Cpx'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [CPX]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [CPX]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [CPX]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [CPX]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [CPX]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [CPX]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Vagos'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.municao }, },
        List = {
            ['Lider [VAGOS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [VAGOS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [VAGOS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [VAGOS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [VAGOS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [VAGOS]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Cassino'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [CASSINO]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [CASSINO]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [CASSINO]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [CASSINO]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [CASSINO]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [CASSINO]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Bahamas'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [BAHAMAS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [BAHAMAS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [BAHAMAS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [BAHAMAS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [BAHAMAS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [BAHAMAS]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Vanilla'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [VANILLA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [VANILLA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [VANILLA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [VANILLA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [VANILLA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [VANILLA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Medusa'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [MEDUSA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MEDUSA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MEDUSA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MEDUSA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MEDUSA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MEDUSA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Mexico'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [MEXICO]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MEXICO]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MEXICO]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MEXICO]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MEXICO]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MEXICO]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Vaticano'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [VATICANO]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [VATICANO]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [VATICANO]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [VATICANO]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [VATICANO]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [VATICANO]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['China'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [CHINA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [CHINA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [CHINA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [CHINA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [CHINA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [CHINA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Tequila'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [TEQUILA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [TEQUILA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [TEQUILA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [TEQUILA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [TEQUILA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [TEQUILA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Lux'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [LUX]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [LUX]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [LUX]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [LUX]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [LUX]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [LUX]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Mainstreet'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.lavagem }, },
        List = {
            ['Lider [MAINSTREET]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MAINSTREET]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MAINSTREET]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MAINSTREET]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MAINSTREET]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MAINSTREET]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Motoclube'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasVermelha }, },
        List = {
            ['Lider [MOTOCLUBE]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MOTOCLUBE]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MOTOCLUBE]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MOTOCLUBE]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [MOTOCLUBE]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [MOTOCLUBE]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Lacoste'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasVermelha }, },
        List = {
            ['Lider [LACOSTE]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [LACOSTE]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [LACOSTE]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [LACOSTE]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [LACOSTE]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [LACOSTE]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Bennys'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasPreta }, },
        List = {
            ['Lider [BENNYS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [BENNYS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [BENNYS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [BENNYS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [BENNYS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [BENNYS]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Disney'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasPreta }, },
        List = {
            ['Lider [DISNEY]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [DISNEY]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [DISNEY]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [DISNEY]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [DISNEY]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [DISNEY]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Russia'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasAmarela }, },
        List = {
            ['Lider [RUSSIA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [RUSSIA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [RUSSIA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [RUSSIA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [RUSSIA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [RUSSIA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Alemanha'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasAmarela }, },
        List = {
            ['Lider [ALEMANHA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [ALEMANHA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [ALEMANHA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [ALEMANHA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [ALEMANHA]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [ALEMANHA]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Tdu'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasVerde }, },
        List = {
            ['Lider [TDU]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [TDU]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [TDU]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [TDU]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [TDU]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [TDU]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Bloods'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasVerde }, },
        List = {
            ['Lider [BLOODS]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [BLOODS]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [BLOODS]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [BLOODS]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [BLOODS]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [BLOODS]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Cohab'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasAzul }, },
        List = {
            ['Lider [COHAB]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [COHAB]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [COHAB]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [COHAB]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [COHAB]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [COHAB]'] = { prefix = 'Novato', tier = 6, },
        }
    },
    ['Tcp'] = {
        Config = { Salary = Config.DefaultSallary, Goals = { defaultReward = 300, itens = Config.ItemsTemplate.drogasAzul }, },
        List = {
            ['Lider [TCP]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [TCP]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [TCP]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [TCP]'] = { prefix = 'Recrutador', tier = 4, },
            ['Membro [TCP]'] = { prefix = 'Membro', tier = 5, },
            ['Novato [TCP]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Jornal'] = {
        Config = {
            Salary = Config.DefaultSallary,
            Goals = {
                defaultReward = 300,
                itens = Config.ItemsTemplate.legal
            }
        },
        List = {
            ['Diretor [JORNAL]'] = { prefix = 'Diretor', tier = 1, },
            ['Produtor [JORNAL]'] = { prefix = 'Produtor', tier = 2, },
            ['Reporter [JORNAL]'] = { prefix = 'Reporter', tier = 3, },
            ['Estagiario [JORNAL]'] = { prefix = 'Estagiario', tier = 4, },
        }
    },

    ['Mecanica'] = {
        Config = {
            Salary = Config.DefaultSallary,
            Goals = {
                defaultReward = 300,
                itens = Config.ItemsTemplate.legal
            }
        },
        List = {
            ['Lider [MECANICA]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [MECANICA]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [MECANICA]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [MECANICA]'] = { prefix = 'Recrutador', tier = 4, },
            ['Mecanico [MECANICA]'] = { prefix = 'Mecanico', tier = 5, },
            ['Novato [MECANICA]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Redline'] = {
        Config = {
            Salary = Config.DefaultSallary,
            Goals = {
                defaultReward = 300,
                itens = Config.ItemsTemplate.legal
            }
        },
        List = {
            ['Lider [REDLINE]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [REDLINE]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [REDLINE]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [REDLINE]'] = { prefix = 'Recrutador', tier = 4, },
            ['Mecanico [REDLINE]'] = { prefix = 'Mecanico', tier = 5, },
            ['Novato [REDLINE]'] = { prefix = 'Novato', tier = 6, },
        }
    },

    ['Driftking'] = {
        Config = {
            Salary = Config.DefaultSallary,
            Goals = {
                defaultReward = 300,
                itens = Config.ItemsTemplate.legal
            }
        },
        List = {
            ['Lider [DRIFTKING]'] = { prefix = 'Lider', tier = 1, },
            ['Sub-Lider [DRIFTKING]'] = { prefix = 'Sub-Lider', tier = 2, },
            ['Gerente [DRIFTKING]'] = { prefix = 'Gerente', tier = 3, },
            ['Recrutador [DRIFTKING]'] = { prefix = 'Recrutador', tier = 4, },
            ['Mecanico [DRIFTKING]'] = { prefix = 'Mecanico', tier = 5, },
            ['Novato [DRIFTKING]'] = { prefix = 'Novato', tier = 6, },
        }
    },
}

Config.Langs = {
    ['offlinePlayer'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Este jogador não está online.", 5000)
    end,

    ['alreadyFaction'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Este jogador já está em uma organização.", 5000)
    end,

    ['alreadyBlacklist'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Você está na black-list, não pode receber convites.", 5000)
    end,

    ['alreadyUserBlacklist'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Este jogador está na black-list.", 5000)
    end,

    ['sendInvite'] = function(source)
        TriggerClientEvent("Notify", source, "sucesso", "Você enviou o convite.", 5000)
    end,

    ['acceptInvite'] = function(source)
        TriggerClientEvent("Notify", source, "sucesso", "Você aceitou o convite.", 5000)
    end,

    ['acceptedInvite'] = function(source, ply_id, group)
        if not source or not ply_id or not group then
            return
        end

        TriggerClientEvent("Notify", source, "sucesso", "O " .. tostring(ply_id) .. " aceitou o convite.", 5000)

        local userId = getUserId(source)
        if userId then
            local logMessage = '```prolog\n[ID]: ' .. userId .. '\n[ORGANIZACAO]: ' .. group .. '\n[CONTRATOU]: ' .. ply_id .. '\n[DATA]: ' .. os.date("[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. '```'
            sendFrameworkLog('invite-org', logMessage)
        end
    end,

    ['bestTier'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Você não pode fazer isso com alguém com um cargo igual ou maior que o seu.", 5000)
    end,

    ['youPromoved'] = function(source)
        TriggerClientEvent("Notify", source, "sucesso", "Você foi promovido.", 5000)
    end,

    ['youPromovedUser'] = function(source, ply_id, group, user_id)
        TriggerClientEvent("Notify", source, "sucesso", "Você promoveu o ID: " .. ply_id .. " para " .. group .. ".", 5000)
        sendFrameworkLog('promover-org', '```prolog\n[ID]: ' .. user_id .. '\n[PROMOVEU]: ' .. ply_id .. '\n[PARA]: ' .. group .. '\n[DATA]: ' .. os.date("[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. '```')
    end,

    ['youDemote'] = function(source)
        TriggerClientEvent("Notify", source, "sucesso", "Você foi rebaixado.", 5000)
    end,

    ['youDemoteUser'] = function(source, ply_id, group)
        TriggerClientEvent("Notify", source, "sucesso", "Você rebaixou o ID: " .. ply_id .. ".", 5000)
        sendFrameworkLog('rebaixar-org', '```prolog\n[ID]: ' .. getUserId(source) .. '\n[ORGANIZACAO]: ' .. group .. '\n[REBAIXOU]: ' .. ply_id .. '\n[DATA]: ' .. os.date("[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. '```')
    end,

    ['youDismiss'] = function(source, group, owner_id)
        TriggerClientEvent("Notify", source, "sucesso", "Você foi demitido de sua organização.", 5000)
        sendFrameworkLog('demitir-org', '```prolog\n[ID]: ' .. owner_id .. '\n[ORGANIZACAO]: ' .. group .. '\n[DEMITIU]: ' .. getUserId(source) .. '\n[DATA]: ' .. os.date("[Data]: %d/%m/%Y [Hora]: %H:%M:%S") .. '```')
    end,

    ['waitCooldown'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Aguarde para fazer isso.", 5000)
    end,

    ['bankNotMoney'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "O Banco da organização não possui essa quantia.", 5000)
    end,

    ['rewardedGoal'] = function(source, amount)
        TriggerClientEvent("Notify", source, "sucesso", "Você resgatou sua meta diária e recebeu <b>R$ " .. amount .. "</b> por isso.", 5000)
    end,

    ['notPermission'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Você não possui permissão.", 5000)
    end,

    ['notMoneyDeposit'] = function(source)
        TriggerClientEvent("Notify", source, "negado", "Você não possui dinheiro para depositar.", 5000)
    end
}





--[[ 
    Como Utilizar EXPORT de Guardar / Retirar Item no Bau:
    ( Colocar Esse EXPORT na função de retirar/guardar item de seu inventario)
    
    user_id: user_id, -- ID Do Jogador,
    action: withdraw or deposit, -- Ação que foi feita Retirou/Depositou
    item: item, -- Spawn do item que foi retirado/guardado.
    amount: quantidade, -- Quantidade do item que foi depositada/retirada

    EXPORT: 
    exports.revolt_orgs_v2:addLogChest(user_id, action, item, amount)
]]

--[[ 
    Como Utilizar EXPORT De METAS DIARIAS:
    ( Colocar esse EXPORT na função de Guardar Itens no Armazem ou Coletar Itens no Farm )

    user_id: user_id, -- ID Do Jogador,
    item: item, -- Spawn do item que foi guardado/farmado.
    amount: quantidade, -- Quantidade do item que foi guardada/farmada.

    EXPORT: 
    exports.revolt_orgs_v2:addGoal(user_id, item, amount)
]]