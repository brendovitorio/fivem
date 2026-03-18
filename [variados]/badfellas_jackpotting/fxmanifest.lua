shared_script ""

fx_version "bodacious"
game "gta5"

client_scripts {
	"@revolt/config/Native.lua",
	"@revolt/lib/Utils.lua",
	"config.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/config/Native.lua",
	"@revolt/config/Item.lua",
	"@revolt/lib/Utils.lua",
	"config.lua",
	"server-side/*"
}