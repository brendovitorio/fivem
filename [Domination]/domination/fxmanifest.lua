

fx_version "cerulean"
game "gta5"

shared_scripts {
	"@revolt/lib/Utils.lua",
	"custom/cc.lua"
}

client_scripts {
	'**/zero.lua'
}

server_scripts {
	"@revolt/config/Item.lua",
	'**/geass.lua'
}
