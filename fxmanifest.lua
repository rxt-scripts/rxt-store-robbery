fx_version 'cerulean'
game 'gta5'

description 'RXT - Store Robbery System (All Stores Synced)'
author 'RXT Scripts'
version '1.0.0'

shared_script '@ox_lib/init.lua' -- If using ox_target and notifications
shared_script 'config.lua'
shared_script 'utils.lua'

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'