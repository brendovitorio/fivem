lua54 'yes'

fx_version 'bodacious'
game 'gta5'

author "Mirt1n#9985"
description "Mirt1n Store - https://discord.gg/MPm3Pptfn5"
api_version "1.0"

shared_script {
  '@revolt/lib/Utils.lua',
  'config.lua'
}

client_script {
  '@revolt/lib/Utils.lua',
  'lib/framework/client/revolt.lua',
  'client/main.lua',
  'client/modules/*.lua'
}

server_script {
  '@revolt/lib/Utils.lua',
  'lib/framework/server/revolt.lua',
  'server/server.lua',
  'server/modules/*.lua'
}

ui_page 'ui/index.html'
files {
  'ui/*',
  'ui/**/*'
}
