

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@revolt/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/config/Vehicle.lua",
	"@revolt/lib/Utils.lua",
	"server-side/*"
}

shared_scripts {
	"shared-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}

escrow_ignore {
	"shared-side/shared.lua"
}                            