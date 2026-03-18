

fx_version "bodacious"
game "gta5"


shared_scripts {
    "cfg.lua",
}

client_scripts {
	"@revolt/lib/utils.lua",
	"@PolyZone/client.lua",
	"client/*"
}

server_scripts {
	"@revolt/lib/utils.lua",
	"@PolyZone/client.lua",
	"server/*"
}         