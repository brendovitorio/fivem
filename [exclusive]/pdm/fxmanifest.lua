

fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web-side/index.html"

client_scripts {
	"@revolt/config/Vehicle.lua",
	"@revolt/config/Native.lua",
	"@revolt/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/config/Vehicle.lua",
	"@revolt/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}              