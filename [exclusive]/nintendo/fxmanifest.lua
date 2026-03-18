fx_version 'adamant'
game 'gta5'

client_script {  
    "@revolt/lib/utils.lua",
    "main/client.lua"
}

server_script {
    "@revolt/lib/utils.lua",
    '@mysql-async/lib/MySQL.lua',
} 

ui_page "html/index.html"

files {
    'html/index.html',
    'html/*.js',
    'html/*.css',
    'html/images/*.png',
    'html/images/games/*.png',
    'html/images/games/*.jpg'
}

lua54 'yes'

escrow_ignore {
    'config.lua',
}

data_file 'DLC_ITYP_REQUEST' 'qua_nintendo.ytyp'