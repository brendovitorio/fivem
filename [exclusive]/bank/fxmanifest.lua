

fx_version "bodacious"
game "gta5"
lua54 "yes"
version "1.5.0"

ui_page "web-side/index.html"

client_scripts {
	"@revolt/lib/Utils.lua",
	"client-side/*"
}

server_scripts {
	"@revolt/lib/Utils.lua",
	"server-side/*"
}

files {
	"web-side/*",
	"web-side/**/*"
}

shared_scripts {
	"shared-side/*"
}

escrow_ignore {
	"db.sql"
}              

exports {
  "AddPed"
}