local frameworkFunctions = {}
local Sql = {}
local tables = {}
local loadedSql = false
local resourceName = GetCurrentResourceName()

local tableCreation = {
    [[
        CREATE TABLE IF NOT EXISTS `revolt_orgfacs` (
            `user_id` INT(11) NOT NULL,
            `entered` INT(50) NOT NULL DEFAULT '0',
            `fac` VARCHAR(50) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
            `lastLogin` INT(50) NOT NULL DEFAULT '0',
            `playedTime` INT(50) NOT NULL DEFAULT '0',
            `farmed` VARCHAR(250) NOT NULL COLLATE 'utf8mb4_general_ci',
            `gettedReward` INT(11) NULL DEFAULT '0',
            PRIMARY KEY (`user_id`) USING BTREE
        )
        COLLATE='utf8mb4_general_ci'
        ENGINE=InnoDB
        ;   
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `revolt_orgblacklist` (
            `user_id` INT(6) NULL DEFAULT '0',
            `time` INT(20) NULL DEFAULT '0'
        ) COLLATE='utf8mb4_general_ci' ENGINE=InnoDB;
    ]],
    [[
        CREATE TABLE IF NOT EXISTS `revolt_orgpainel` (
            `faction` VARCHAR(50) NOT NULL COLLATE 'utf8mb4_general_ci',
            `data` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `bank` INT(11) NULL DEFAULT '0',
            `max_members` INT(11) NULL DEFAULT '20',
            `contractions` INT(11) NULL DEFAULT '0',
            `pix` VARCHAR(50) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `meta` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            `value` INT(11) NULL DEFAULT '0',
            `imagem` VARCHAR(150) NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`faction`) USING BTREE
        )
        COLLATE='utf8mb4_general_ci'
        ENGINE=InnoDB
        ;
    ]]
}

local WRAPPERS = {
    {
        'oxmysql',
        function (promise, sql_text, params)
            exports['oxmysql']:query(sql_text, params, function (result)
                promise:resolve(result)
            end)
        end,
    },
    {
        'ghmattimysql',
        function (promise, sql_text, params)
            exports['ghmattimysql']:execute(sql_text, params, function (result)
                promise:resolve(result)
            end)
        end,
    },
    {
        'GHMattiMySQL',
        function (promise, sql_text, params)
            exports['GHMattiMySQL']:QueryResultAsync(sql_text, params, function (result)
                promise:resolve(result)
            end)
        end,
    },
    {
        'mysql-async',
        function (promise, sql_text, params)
            exports['mysql-async']:mysql_fetch_all(sql_text, params, function (result)
                promise:resolve(result)
            end)
        end,
    }
}

local function isScriptStarted(scriptName)
    local state = GetResourceState(scriptName)

    return state == 'started'
end

CreateThread(function()
    for key, infos in ipairs(WRAPPERS) do
        local scriptName = infos[1]
        local wrapper = infos[2]

        if isScriptStarted(scriptName) then
            Sql = wrapper
            break
        end
    end

    local resolution = promise.new()

    local query = [[
        SELECT table_name as t, column_name as c FROM information_schema.columns WHERE 
        table_schema = DATABASE()
    ]]

    Sql(resolution, query)

    local result = Citizen.Await(resolution)

    for key, value in ipairs(result) do
        if not tables[value.t] then
            tables[value.t] = {}
        end

        tables[value.t][value.c] = true
    end
    
    loadedSql = true
end)

local function sqlFetchTable(table, column)
    if column then
        return tables[table] and tables[table][column]
    else
        return tables[table]
    end
end

local currentFramework = config.framework or 'none'

CreateThread(function()
    while not loadedSql do
        Wait(100)
    end

    if currentFramework == 'none' then
        local vrpStarted = GetResourceState('vrp') == 'started'
        
        if vrpStarted then
            currentFramework = 'vrpex'
            
            if sqlFetchTable('characters', 'License') then
                currentFramework = 'creativeext'
            elseif sqlFetchTable('snt_accounts') then
                currentFramework = 'snt'
            elseif sqlFetchTable('accounts', 'steam') then
                currentFramework = 'creativenw'
            elseif sqlFetchTable('characters', 'license') then
                currentFramework = 'creativenw'
            elseif sqlFetchTable('characters', 'license') then
                currentFramework = 'revolt'
            elseif sqlFetchTable('summerz_accounts') then
                currentFramework = 'creativev5'
            elseif sqlFetchTable('vrp_users') then
                currentFramework = 'vrpex'
            end
        elseif GetResourceState('nyo_modules') == 'started' then
            if sqlFetchTable('nyo_accounts') then
                currentFramework = 'nyofw'
            end
        end
    end

    TriggerClientEvent(resourceName .. ':frameworkDetected', -1, currentFramework)
    print('[AUTO-DETECTOR]: Framework detectado! ^2['..currentFramework..']^7')
end)

RegisterServerEvent(resourceName .. ':getFramework', function()
    local source = source
    TriggerClientEvent(resourceName .. ':frameworkDetected', source, currentFramework)
end)

exports('getFramework', function()
    while not loadedSql do
        Wait(100)
    end

    local triesDetectFramework = 100
    while currentFramework == 'none'  and triesDetectFramework > 0 do
        triesDetectFramework = triesDetectFramework - 1
        Wait(100)
    end

    if currentFramework == 'none' then
        print('ERROR, FRAMEWORK NOT DETECTED, CALL REVOLT TO FIX THIS')
        return nil
    end

    local isServer = IsDuplicityVersion()

    local frameworkArchive = isServer and 'server' or 'client'

    frameworkFunctions = module(resourceName, 'framework/'..frameworkArchive..'/'..currentFramework)

    frameworkFunctions.sql = Sql

    if type(tableCreation) == 'table' then
        for key, query in ipairs(tableCreation) do
            local result = promise.new()

            Sql(result, query, {})

            Citizen.Await(result)
        end
    else
        local result = promise.new()

        Sql(result, tableCreation, {})

        Citizen.Await(result)
    end

    local modularsFunctions = exports[resourceName]:getAllModularsFunctionsForFramework(currentFramework)

    if modularsFunctions then
        for name, handler in pairs(modularsFunctions) do
            if frameworkFunctions[name] then
                frameworkFunctions[name] = handler()
            end
        end
    end

    return frameworkFunctions, currentFramework
end)

exports('fetchTable', sqlFetchTable)
exports('query', function(...)
    local result = promise.new()

    Sql(result, ...)

    return Citizen.Await(result)
end)