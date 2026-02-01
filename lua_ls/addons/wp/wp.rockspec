-- wp.rockspec
-- Qompass AI - [ ]
-- Copyright (C) 2026 Qompass AI, All rights reserved
-- ----------------------------------------
rockspec_format = '3.0'
package = 'lls-addon-cc-tweaked'
version = 'dev-1'
source = {
    url = 'git+https://gitlab.com/qompassai/lua',
}
description = {
    summary = 'LuaCATS annotations for CC:Tweaked',
    detailed = 'Manually crafted LuaCATS annotations for Minecraft\'s CC:Tweaked computer mod',
    homepage = 'https://gitlab.com/carsakiller/lls-addon-cc-tweaked',
    license = 'MIT',
}
build = {
    type = 'lls-addon',
    settings = {
        ['runtime.version'] = 'Lua 5.3',
        ['runtime.builtin'] = {
            io = 'disable',
            os = 'disable',
        },
    },
}
