#!/usr/bin/env bash
# qompassai/Lua/scripts/rocks2.sh
# Qompass AI Diver Lua Rocks Script
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
set -euo pipefail
: "${LUAROCKS_CONFIG:=${HOME}/.config/luarocks/luarocks-5.1.lua}"
export LUAROCKS_CONFIG
log_file="${HOME}/.cache/luarocks/install.log"
mkdir -p "$(dirname "$log_file")"
rocks=(
    api7-lua-resty-aws
    api7-lua-resty-jwt
    bit32
    busted
    dkjson
    fzf-lua
    fzy
    httpclient
    httprequestparser
    lpeg
    lua-cjson
    lua-lru
    luautf8
    luacheck
    luadbi
    luadbi-postgresql
    luafilesystem
    luafilesystem-ffi
    lua-genai
    luamake
    luaproc
    luar
    luarocks-build-rust-mlua
    lua-rtoml
    luasocket
    luaossl
    luasql-postgres
    luastruct
    lua-resty-http
    luasql-sqlite3
    lua-term
    lua-toml
    luv
    lzlib
    magick
    penlight
    penlight-ffi
    quantum
    typecheck
)
failed=()
succeeded=()
echo "Installing ${#rocks[@]} rocks to $(luarocks config rocks_trees | grep root | head -1)"
echo "Logging to: $log_file"
echo
for rock in "${rocks[@]}"; do
    printf "Installing %-40s ... " "$rock"
    if luarocks install "$rock" >> "$log_file" 2>&1; then
        echo "✓"
        succeeded+=("$rock")
    else
        echo "✗"
        failed+=("$rock")
    fi
done
echo
echo "================================"
echo "Summary:"
echo "  Succeeded: ${#succeeded[@]}"
echo "  Failed: ${#failed[@]}"

if [[ ${#failed[@]} -gt 0 ]]; then
    echo
    echo "Failed rocks:"
    printf "  - %s\n" "${failed[@]}"
    echo
    echo "Check $log_file for details"
    exit 1
fi
