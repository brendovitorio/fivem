
fx_version 'cerulean'

game 'gta5'

ui_page 'web/build/index.html'

shared_scripts {
    'config/config.lua',
    '@revolt/lib/utils.lua'
}

client_scripts {
    'client/client.lua'
}

server_scripts {
    'server/server.lua'
}

files {
    'web/build/index.html',
    'web/build/**/*',
}