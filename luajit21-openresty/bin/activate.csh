which deactivate-lua >&/dev/null && deactivate-lua

alias deactivate-lua 'if ( -x '\''/home/phaedrus/luajit21-openresty/bin/lua'\'' ) then; setenv PATH `'\''/home/phaedrus/luajit21-openresty/bin/lua'\'' '\''/home/phaedrus/luajit21-openresty/bin/get_deactivated_path.lua'\''`; rehash; endif; unalias deactivate-lua'

setenv PATH '/home/phaedrus/luajit21-openresty/bin':"$PATH"
rehash
