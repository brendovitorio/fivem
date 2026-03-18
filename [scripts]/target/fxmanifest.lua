shared_script ""

fx_version "bodacious"
game "gta5"
lua54 "yes"

dependencies {
    "PolyZone"
}

ui_page "web-side/index.html"

client_scripts {
	"@revolt/config/Native.lua",
	"@revolt/lib/Utils.lua",
	"@PolyZone/client.lua",
	"@PolyZone/BoxZone.lua",
	"@PolyZone/EntityZone.lua",
	"@PolyZone/CircleZone.lua",
	"@PolyZone/ComboZone.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*"
}