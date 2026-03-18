local function ensureTable(v) return type(v)=="table" and v or {} end

RegisterNUICallback('GetRanking', function(_, cb) 
    cb(ensureTable(vTunnel.getRanking and vTunnel.getRanking() or {}))
    -- cb({
    --   {
    --     id = 1337,
    --     name = 'João Sembraco',
    --     timePlayed = 1234,
    --     money = 5678,
    --     farm = 910
    --   },
    --   {
    --     id = 1337,
    --     name = 'João Sembraco',
    --     timePlayed = 1234,
    --     money = 5678,
    --     farm = 910
    --   },
    --   {
    --     id = 1337,
    --     name = 'João Sembraco',
    --     timePlayed = 1234,
    --     money = 5678,
    --     farm = 910
    --   },
    -- })
    -- local response = vTunnel.getFactionRanking()
    -- print(json.encode(response, { indent = true }))
    -- cb(response)
end)