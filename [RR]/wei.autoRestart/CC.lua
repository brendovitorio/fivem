CC = {}
---------------------------------------------
-- Essential | Essencial
---------------------------------------------

-- CC.batFile = nome do arquivo '.bat' que é usado para iniciar o servidor
-- CC.batFile = name of the '.bat' file used to boot the server
CC.batFile = 'server.bat'

-- CC.autoRRs = lista de quais horários do dia será iniciada a função de RR automático
-- CC.autoRRs = list of which times of the day will the automatic Restart function will be triggered
CC.autoRRs = {
    '08:00:00',
    '18:00:00',
    '03:00:00',

}

---------------------------------------------
-- Cache
---------------------------------------------
-- CC.emptyCache = true: Limpar o cache do servidor ao realizar RR | false: não fazer nada
-- CC.emptyCache = true: empty the cache of the server on restart | false: don't do anything
CC.emptyCache = true

-- CC.cacheDir = Diretório que deve ser limpo ao reiniciar o servidor(só é relevante se a CC.emptyCache = true)
-- CC.cacheDir = Directory to be emptied when the server restart(only relevant if CC.emptyCache = true)
CC.cacheDir = [[.\cache\files]]

-- CC.os = Sistema operacional no qual o servidor está hospedado | valores configurados: 'windows' ou 'linux'
-- CC.os = Operational System where the server is hosted | configurated values: 'windows' or 'linux'
CC.os = 'windows'

---------------------------------------------
-- Notify
---------------------------------------------
-- CC.notifyBeforeRR = true: Ativar função framework.notifyAll() antes do RR ser realizado | false: não fazer nada
-- CC.notifyBeforeRR = true: Trigger framework.notifyAll function before the server restart | false: don't do anything
CC.notifyBeforeRR = true

--CC.notifyTime = Quantidade de tempo(em minutos) que a função de framework.notifyAll será ativa antes do RR
--CC.notifyTime = Amount of time(in minutes) that the framework.notifyAll function will be triggered before restart
CC.notifyTime = 5
