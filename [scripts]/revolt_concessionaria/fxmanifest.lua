fx_version "cerulean"
game "gta5"

ui_page "nui/index.html"

client_scripts {
    "@revolt/lib/Utils.lua",
    "client_config.lua",
    "client.lua"
}

server_scripts {
    "@revolt/lib/Utils.lua",
    "config.lua",
    "server.lua"
}

files {
    "nui/index.html",
    "nui/style.css",
    "nui/script.js"
}
