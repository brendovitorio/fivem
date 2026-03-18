fx_version   'bodacious'
lua54        'yes'
game         'gta5'

dependencies {
    '/onesync',
    'revolt',
    'PolyZone'
}

shared_scripts {
    '@revolt/lib/Utils.lua',
    'config/shared.*.lua'
}

server_scripts {
	"@oxmysql/lib/MySQL.lua",
    "server/main.lua",
    "server/utils/**",
    'config/*.lua',
    "server/modules/**",
}

client_scripts {
    "@PolyZone/CircleZone.lua",
    "@PolyZone/client.lua",
    "client/main.lua",
    "client/utils/**",
    "client/modules/**",
}

ui_page 'web/index.html'
files {
    'web/**/*',
    'web/*'
}