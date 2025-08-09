-- LuaRocks configuration

rocks_trees = {
   { name = "user", root = home .. "/.luarocks" };
   { name = "system", root = "/home/phaedrus/luajit21-openresty" };
}
lua_interpreter = "lua";
variables = {
   LUA_DIR = "/home/phaedrus/luajit21-openresty";
   LUA_BINDIR = "/home/phaedrus/luajit21-openresty/bin";
}
