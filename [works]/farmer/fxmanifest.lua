

fx_version "bodacious"
game "gta5"
lua54 "yes"

client_scripts {
	"@revolt/config/Native.lua",
	"@revolt/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/config/Item.lua",
	"@revolt/lib/Utils.lua",
	"server-side/*"
}              