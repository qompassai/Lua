#!/usr/bin/env bash
# qompassai/Lua/scripts/quickstart.sh
# Qompass AI Diver Lua Quick Start
# Copyright (C) 2025 Qompass AI, All rights reserved
#####################################################
set -euo pipefail
declare -A MENU=(
  [1]="lua 5.1.5"
  [2]="lua 5.2.4"
  [3]="lua 5.3.6"
  [4]="lua 5.4.6"
  [5]="luajit"
)
echo "╭─────────────────────────────────────────────╮"
echo "│       Qompass AI · Lua Quick-Start          │"
echo "╰─────────────────────────────────────────────╯"
echo "    © 2025 Qompass AI. All rights reserved     "
echo
for k in "${!MENU[@]}"; do printf " %s) %s\n" "$k" "${MENU[$k]}"; done
echo " a) all   (default)"
echo " q) quit"
echo
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
PREFIX="$HOME/.local"
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu || echo 4)
: "${CC:=clang}"
CFLAGS="-O3 -march=native -flto -fPIC -pipe"
LDFLAGS="-flto -Wl,-O1,--as-needed"
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
  local line="export PATH='$HOME/.local/bin:$PATH'"
  if [[ -f "$rc_file" ]] && ! grep -Fq "$line" "$rc_file"; then
    printf '\n# added by lua quickstart\n%s\n' "$line" >>"$rc_file"
    echo " -> PATH updated in $rc_file"
  fi
}
mkdir -p "$PREFIX/bin"
cd /tmp
for v in "${VERSIONS[@]}"; do
  if [[ $v == luajit ]]; then
    echo -e "\n=== LuaJIT ==="
    git clone --depth 1 https://github.com/LuaJIT/LuaJIT.git
    cd LuaJIT
    make -j"$JOBS" CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
    make install PREFIX="$PREFIX/luajit"
    ln -sf "$PREFIX/luajit/bin/luajit" "$PREFIX/bin/luajit"
    cd /tmp && rm -rf LuaJIT
    continue
  fi
  echo -e "\n=== Lua $v ==="
  curl -fsSLO "https://www.lua.org/ftp/lua-$v.tar.gz"
  tar xf "lua-$v.tar.gz"
  rm "lua-$v.tar.gz"
  cd "lua-$v"
  make "$PLATFORM" \
    CC="$CC" \
    MYCFLAGS="$CFLAGS $SHARED" \
    MYLDFLAGS="$LDFLAGS" \
    -j"$JOBS"
  $CC "$CFLAGS" -shared -o src/liblua.so \
    -Wl,--whole-archive src/liblua.a -Wl,--no-whole-archive -lm
  short=${v%.*}
  dest="$PREFIX/lua$short"
  make install INSTALL_TOP="$dest"
  install -m 755 src/liblua.so "$dest/lib"
  ln -sf "$dest/bin/lua" "$PREFIX/bin/lua$short"
  ln -sf "$dest/bin/luac" "$PREFIX/bin/luac$short"
  cd /tmp && rm -rf "lua-$v"
done
add_to_rc "$HOME/.bashrc"
add_to_rc "$HOME/.zshrc"
if [[ -n ${PROFILE:-} && -f "$PROFILE" ]]; then
  if ! grep -Fq '.local/bin' "$PROFILE"; then
    printf "\n# added by lua quickstart\n$Env:Path = "%s
    " + $Env:Path\n" \
      "$HOME/.local/bin" >>"$PROFILE"
    echo " -> PATH updated in PowerShell profile: $PROFILE"
  fi
fi

echo -e "\n✔  Build complete.  Open a new shell or run:  source ~/.bashrc"
