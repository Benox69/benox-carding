fx_version 'cerulean'
game 'gta5'

version '1.0.0'
lua54 'yes'

client_scripts {
    'client/client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server.lua'

}

shared_scripts {
    'config.lua',
    '@ox_lib/init.lua'

} 

dependencies {
    'ox_inventory',
    'ox_lib'
}
escrow_ignore {
    'config.lua'
  }