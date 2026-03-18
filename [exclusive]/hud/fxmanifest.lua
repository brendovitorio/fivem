
fx_version "bodacious"
game "gta5"
lua54 'yes'
ui_page "web-side/index.html"
client_scripts {
	"@revolt/config/Native.lua",
	"@revolt/config/Item.lua",
	"@revolt/lib/Utils.lua",
	"client-side/nui_bridge.lua",
	"client-side/core.lua",
	"client-side/map.lua",
	"client-side/scuba.lua",
	"client-side/textform.lua",
	"client-side/vehicle.lua",
	"client-side/weapon.lua"
}
server_scripts {
	"@revolt/config/Item.lua",
	"@revolt/lib/Utils.lua",
	"server-side/*"
}
files {
	"web-side/*",
	"web-side/**/*"
}              