

fx_version "bodacious"
game "gta5"

client_scripts {
	"client/*"
}
server_scripts {
	"@revolt/lib/Utils.lua",
	"server/*"
}

ui_page "web/index.html"

files {
	"web/*",
	"web/**/*"
}