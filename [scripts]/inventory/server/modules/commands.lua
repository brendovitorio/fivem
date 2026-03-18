

RegisterCommand('item', function(source, args)
    local Passport = rEVOLT.Passport(source)
    if not Passport then return end
    if not rEVOLT.HasGroup(Passport, 'Admin', 1) then
        return TriggerClientEvent('Notify', source, 'negado', 'Você não tem permissão.', 5000)
    end
    local targetPassport = parseInt(args[1])
    local item = tostring(args[2] or '')
    local amount = parseInt(args[3])
    if targetPassport <= 0 or item == '' or amount <= 0 then
        return TriggerClientEvent('Notify', source, 'amarelo', 'Use: /item [passaporte] [item] [quantidade]', 5000)
    end
    if rEVOLT.GenerateItem then
        rEVOLT.GenerateItem(targetPassport, item, amount, true)
    else
        rEVOLT.GiveItem(targetPassport, item, amount, true)
    end
    TriggerClientEvent('Notify', source, 'sucesso', 'Você enviou '..amount..'x '..item..' para o passaporte '..targetPassport..'.', 5000)
    local targetSource = rEVOLT.Source and rEVOLT.Source(targetPassport)
    if targetSource then
        TriggerClientEvent('Notify', targetSource, 'sucesso', 'Você recebeu '..amount..'x '..item..'.', 5000)
    end
end)

RegisterCommand('item2', function(source, args)
    local Passport = rEVOLT.Passport(source)
    if not Passport then return end
    if not rEVOLT.HasGroup(Passport, 'Admin', 1) then
        return TriggerClientEvent('Notify', source, 'negado', 'Você não tem permissão.', 5000)
    end
    local item = tostring(args[1] or '')
    local amount = parseInt(args[2])
    if item == '' or amount <= 0 then
        return TriggerClientEvent('Notify', source, 'amarelo', 'Use: /item2 [item] [quantidade]', 5000)
    end
    if rEVOLT.GenerateItem then
        rEVOLT.GenerateItem(Passport, item, amount, true)
    else
        rEVOLT.GiveItem(Passport, item, amount, true)
    end
    TriggerClientEvent('Notify', source, 'sucesso', 'Você recebeu '..amount..'x '..item..'.', 5000)
end)
