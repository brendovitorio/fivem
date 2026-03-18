

fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
	"@revolt/lib/Utils.lua",
	"clothes.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/lib/Utils.lua",
	"clothes.lua",
	"server-side/*"
}