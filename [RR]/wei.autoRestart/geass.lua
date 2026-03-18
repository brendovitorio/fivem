local notifyTime = {}

CreateThread(function ()
    framework.sendWebhook(framework.webhookrestart, "Revolt BOT", "A chuva passou! Voce já pode retornar as suas atividades na cidade!", 10357504)
end)

CreateThread(function()
    if not CC.notifyBeforeRR then return end

    for _,v in pairs(CC.autoRRs) do
        local hour = tonumber(v:sub(1,2))
        local min = tonumber(v:sub(4,5))
        local sec = v:sub(7,8)
        min = min - CC.notifyTime
        while min < 0 do
            min = 60 + min
            hour = hour - 1
        end
        while hour < 0 do
            hour = 24 + hour
        end
        if hour < 10 then hour = '0'..hour end
        if min < 10 then min = '0'..min end
        local time = hour..':'..min..':'..sec
        table.insert(notifyTime,time)
    end

    while true do
        Wait(700)
        local utcTime = os.date('%X')
        for k,v in pairs(notifyTime) do
            if utcTime == v then
                framework.notifyAll(CC.autoRRs[k])
                return
            end
        end
    end
end)

CreateThread(function()
    while true do
        Wait(700)
        local utcTime = os.date('%X')
        for _,v in pairs(CC.autoRRs) do
            if utcTime == v then
                restartServer()
                return
            end
        end
    end
end)

function restartServer()
    framework.kickAll()
    if CC.emptyCache then
        if CC.os == 'windows' then
            os.execute('rd /s/q "'..CC.cacheDir..'"')
        elseif CC.os == 'linux' then
            os.execute('rm -rd "'..CC.cacheDir..'"')
        end
    end
    io.popen('start '..CC.batFile)
    os.exit()
end
