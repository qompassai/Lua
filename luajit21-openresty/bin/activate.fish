if functions -q deactivate-lua
    deactivate-lua
end

function deactivate-lua
    if test -x '/home/phaedrus/luajit21-openresty/bin/lua'
        eval ('/home/phaedrus/luajit21-openresty/bin/lua' '/home/phaedrus/luajit21-openresty/bin/get_deactivated_path.lua' --fish)
    end

    functions -e deactivate-lua
end

set -gx PATH '/home/phaedrus/luajit21-openresty/bin' $PATH
