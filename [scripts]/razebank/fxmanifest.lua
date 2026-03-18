shared_script ""


fx_version 'adamant'

game 'gta5'

author 'okok#3488'
description 'RevoltBank'

ui_page 'web/ui.html'

files {
	'web/*.*'
}

shared_script 'config.lua'

client_scripts {
	"@revolt/lib/Utils.lua",
	'client.lua',
}

server_scripts {
	"@revolt/lib/Utils.lua",
	'server.lua'
}