#!/bin/bash
# qompassai/Lua/scripts/quickstart.sh
# Qompass AI Diver Lua Quick‑Start
# Copyright (C) 2025 Qompass AI, All rights reserved
# --------------------------------------------------
set -euo pipefail
PREFIX="$HOME/.local"
mkdir -p "$PREFIX/bin"
NEEDED_TOOLS=(git curl tar make clang bash)
MISSING=()
need_tool() {
  local t=$1
  if command -v "$t" >/dev/null 2>&1; then
    return 0
  elif [[ -x "/usr/bin/$t" ]]; then
    ln -sf "/usr/bin/$t" "$PREFIX/bin/$t"
    echo " → Added symlink for $t in $PREFIX/bin (not originally in PATH)"
    return 0
  else
    return 1
  fi
}
for tool in "${NEEDED_TOOLS[@]}"; do
  if ! need_tool "$tool"; then
    MISSING+=("$tool")
  fi
done
if [[ ${#MISSING[@]} -gt 0 ]]; then
  printf '\n⚠  The following required tools are missing: %s\n' "${MISSING[*]}"
  if command -v pacman >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1; then
    echo "→ Attempting to install them system‑wide with sudo pacman -S --needed ${MISSING[*]}"
    if sudo -n true 2>/dev/null; then
      sudo pacman -Sy --needed --noconfirm "${MISSING[@]}"
    else
      echo "   (sudo privileges required – please enter your password)"
      sudo pacman -Sy --needed "${MISSING[@]}"
    fi
    for t in "${MISSING[@]}"; do need_tool "$t"; done
  else
    echo "   Please install them with your package manager, then re‑run this script."
    exit 1
  fi
fi
export PATH="$PREFIX/bin:$PATH"

declare -A MENU=(
  [1]="lua 5.1.5"
  [2]="lua 5.2.4"
  [3]="lua 5.3.6"
  [4]="lua 5.4.6"
  [5]="LuaJIT"
)

printf '%s\n' "╭─────────────────────────────────────────────╮"
printf '%s\n' "│       Qompass AI · Lua Quick‑Start          │"
printf '%s\n' "╰─────────────────────────────────────────────╯"
printf '%s\n\n' "    © 2025 Qompass AI. All rights reserved     "
for k in "${!MENU[@]}"; do printf ' %s) %s\n' "$k" "${MENU[$k]}"; done
printf '%s\n' " a) all   (default)"
printf '%s\n\n' " q) quit"
read -rp "Choose versions to build [a]: " choice
choice=${choice:-a}
[[ $choice == q ]] && exit 0

VERSIONS=()
if [[ $choice == a ]]; then
  VERSIONS=(5.1.5 5.2.4 5.3.6 5.4.6 luajit)
else
  for n in $choice; do
    case $n in
    1) VERSIONS+=("5.1.5") ;;
    2) VERSIONS+=("5.2.4") ;;
    3) VERSIONS+=("5.3.6") ;;
    4) VERSIONS+=("5.4.6") ;;
    5) VERSIONS+=("luajit") ;;
    *)
      echo "Unknown option $n"
      exit 1
      ;;
    esac
  done
fi
LUAROCKS_VERSION="3.12.1"
DEFAULT_IMPL="luajit"
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu || echo 4)
: "${CC:=clang}"
CFLAGS="-O3 -march=native -flto -fPIC -pipe -fstack-protector-strong"
LDFLAGS="-flto -Wl,-O1,--as-needed,-z,relro,-z,now"
[[ -x $(command -v ld.lld) ]] && LDFLAGS+=" -fuse-ld=lld"
case "$(uname -s)" in
Darwin*)
  PLATFORM=macosx
  SHARED="-DLUA_USE_MACOSX"
  ;;
MINGW* | MSYS* | CYG*)
  PLATFORM=mingw
  SHARED=""
  ;;
*)
  PLATFORM=linux
  SHARED="-DLUA_USE_LINUX"
  ;;
esac

add_to_rc() {
  local rc_file=$1
  local line="export PATH='$PREFIX/bin:$PATH'"
  if [[ -f "$rc_file" ]] && ! grep -Fq "$line" "$rc_file"; then
    printf '\n# added by lua quickstart\n%s\n' "$line" >>"$rc_file"
    echo " → PATH updated in $rc_file"
  fi
}
install_luarocks() {
  local lua_prefix="$1"
  local rocks_prefix="$lua_prefix"
  pushd /tmp >/dev/null
  curl -fsSLO "https://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz"
  tar xf "luarocks-$LUAROCKS_VERSION.tar.gz"
  cd "luarocks-$LUAROCKS_VERSION"
  ./configure \
    --prefix="$rocks_prefix" \
    --with-lua="$lua_prefix" \
    --with-lua-include="$lua_prefix/include" \
    --with-lua-lib="$lua_prefix/lib"
  make -j"$JOBS"
  make install
  local tag
  tag=$(basename "$lua_prefix" | sed 's/^lua//;s/^luajit$/jit/')
  ln -sf "$rocks_prefix/bin/luarocks" "$PREFIX/bin/luarocks$tag"
  popd >/dev/null
  rm -rf "/tmp/luarocks-$LUAROCKS_VERSION"
}
cd /tmp
for v in "${VERSIONS[@]}"; do
  if [[ $v == luajit ]]; then
    echo -e "\n=== LuaJIT ==="
    git clone --depth 1 https://github.com/LuaJIT/LuaJIT.git
    pushd LuaJIT >/dev/null
    make -j"$JOBS" CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
    make install PREFIX="$PREFIX/luajit"
    ln -sf "$PREFIX/luajit/bin/luajit" "$PREFIX/bin/luajit"
    popd >/dev/null && rm -rf LuaJIT
    install_luarocks "$PREFIX/luajit"
    continue
  fi
  echo -e "\n=== Lua $v ==="
  curl -fsSLO "https://www.lua.org/ftp/lua-$v.tar.gz"
  tar xf "lua-$v.tar.gz" && rm "lua-$v.tar.gz"
  pushd "lua-$v" >/dev/null
  make "$PLATFORM" CC="$CC" MYCFLAGS="$CFLAGS $SHARED" MYLDFLAGS="$LDFLAGS" -j"$JOBS"
  $CC "$CFLAGS" -shared -o src/liblua.so -Wl,--whole-archive src/liblua.a -Wl,--no-whole-archive -lm
  short=${v%.*}
  dest="$PREFIX/lua$short"
  make install INSTALL_TOP="$dest"
  install -m 755 src/liblua.so "$dest/lib"
  ln -sf "$dest/bin/lua" "$PREFIX/bin/lua$short"
  ln -sf "$dest/bin/luac" "$PREFIX/bin/luac$short"
  popd >/dev/null && rm -rf "lua-$v"
  install_luarocks "$dest"
  cat >"$dest/lib/pkgconfig/lua$short.pc" <<EOF
prefix=$dest
exec_prefix=\${prefix}
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: Lua $short
Version: $v
Libs: -shared -L\${libdir} -llua
Cflags: -I\${includedir}
EOF
done
if [[ $DEFAULT_IMPL == luajit ]]; then
  ln -sf "$PREFIX/bin/luajit" "$PREFIX/bin/lua"
  ln -sf "$PREFIX/bin/luajit" "$PREFIX/bin/luac"
else
  def_short=${DEFAULT_IMPL//./}
  ln -sf "$PREFIX/bin/lua$def_short" "$PREFIX/bin/lua"
  ln -sf "$PREFIX/bin/luac$def_short" "$PREFIX/bin/luac"
fi
add_to_rc "$HOME/.bashrc"
add_to_rc "$HOME/.zshrc"
echo -e "\n✔  Build complete.  Open a new shell or run 'source ~/.bashrc' | 'source ~/.zshrc' for it to take effect ."
