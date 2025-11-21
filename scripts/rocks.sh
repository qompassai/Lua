#!/usr/bin/env sh
rocks="bit32 busted lua-cjson dkjson fzy httpclient libluajit lpeg lua-lru luautf8 luacheck lua-csnappy luadbi luafilesystem luafilesystem-ffi lua-genai httprequestparser luaproc luar luarocks-build-rust-mlua lua-rtoml luasocket luaossl luasql-postgres luastruct lua-resty-http luasql-postgres luasql-sqlite3 lua-term lua-toml luv lzlib magick penlight quantum typecheck tree-sitter-php"
for rock in $rocks; do
  luarocks --lua-version=5.1 install $rock --force-lock
done
