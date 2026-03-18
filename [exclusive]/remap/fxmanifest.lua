

fx_version "bodacious"
game "gta5"

ui_page "web-side/index.html"

client_scripts {
	"@revolt/lib/utils.lua",
	"client-side/*",
}

server_scripts {
	"@revolt/lib/utils.lua",
	"server-side/*"
}

files {
    "web-side/*",
    "web-side/**/*",
    "web-side/**/**/*"
}              