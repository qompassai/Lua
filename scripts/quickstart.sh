#!/usr/bin/env bash
# qompassai/Lua/scripts/quickstart.sh
# Qompass AI Diver Lua Quick‑Start
# Copyright (C) 2025 Qompass AI, All rights reserved
####################################################
set -euo pipefail
: "${XDG_DATA_HOME:=${HOME}/.local/share}"
PREFIX="${XDG_DATA_HOME}/lua"
LUAROCKS_VERSION="3.12.1"
NEEDED_TOOLS=(git curl tar make bash)
if command -v clang >/dev/null 2>&1; then
  CC_DEFAULT="clang"
elif command -v cc >/dev/null 2>&1; then
  CC_DEFAULT="cc"
else
  CC_DEFAULT="gcc"
fi
: "${CC:=${CC_DEFAULT}}"
JOBS="$(nproc 2>/dev/null || sysctl -n hw.ncpu 2>/dev/null || echo 4)"
CFLAGS="-O3 -march=native -fPIC -pipe -fstack-protector-strong"
LDFLAGS="-Wl,-O1,--as-needed,-z,relro,-z,now"
case "$(uname -s)" in
  Darwin*)
    PLATFORM="macosx"
    SHARED="-DLUA_USE_MACOSX"
    ;;
  MINGW*|MSYS*|CYG*)
    PLATFORM="mingw"
    SHARED=""
    ;;
  *)
    PLATFORM="linux"
    SHARED="-DLUA_USE_LINUX"
    ;;
esac
die() {
  printf 'ERROR: %s\n' "$*" >&2
  exit 1
}
safe_mkdir() {
  mkdir -p -- "$1" || die "Failed to create directory: $1"
}
add_to_bash_rc() {
  local rc_file=$1
  local line="export PATH='${PREFIX}/bin:\$PATH'"
  [[ -z "${rc_file}" ]] && return 0
  [[ ! -f "${rc_file}" ]] && return 0
  if ! grep -Fqx "${line}" "${rc_file}"; then
    printf '\n# added by lua quickstart\n%s\n' "${line}" >>"${rc_file}" || \
      die "Failed to update ${rc_file}"
    echo " → PATH updated in ${rc_file}"
  fi
}
add_to_fish_config() {
  local config_dir="${HOME}/.config/fish"
  local config_file="${config_dir}/config.fish"
  local line="set -gx PATH '${PREFIX}/bin' \$PATH"
  safe_mkdir "${config_dir}"
  if [[ -f "${config_file}" ]]; then
    if ! grep -Fqx "${line}" "${config_file}"; then
      printf '\n# added by lua quickstart\n%s\n' "${line}" >>"${config_file}" || \
        die "Failed to update ${config_file}"
      echo " → PATH updated in ${config_file}"
    fi
  else
    printf '# added by lua quickstart\n%s\n' "${line}" >"${config_file}" || \
      die "Failed to create ${config_file}"
    echo " → PATH created in ${config_file}"
  fi
}
need_tool() {
  local t=$1
  if command -v "${t}" >/dev/null 2>&1; then
    return 0
  fi
  if [[ -x "/usr/bin/${t}" ]]; then
    if [[ -w "${PREFIX}/bin" ]]; then
      ln -sf "/usr/bin/${t}" "${PREFIX}/bin/${t}"
      echo " → Added symlink for ${t} in ${PREFIX}/bin (not originally in PATH)"
      return 0
    else
      echo " → /usr/bin/${t} exists but ${PREFIX}/bin is not writable" >&2
    fi
  fi
  return 1
}
install_luarocks() {
  local lua_prefix="${1}"
  local lua_impl="${2}"
  [[ -d "${lua_prefix}" ]] || die "Lua prefix not found: ${lua_prefix}"
  local rocks_prefix="${lua_prefix}"
  local tmpdir
  tmpdir="$(mktemp -d "${TMPDIR:-/tmp}/luarocks.XXXXXXXX")"
  trap 'rm -rf "${tmpdir}"' RETURN
  (
    cd "${tmpdir}"
    curl -fsSLO "https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz"
    tar xf "luarocks-${LUAROCKS_VERSION}.tar.gz"
    cd "luarocks-${LUAROCKS_VERSION}"
    if [[ "${lua_impl}" == "luajit" ]]; then
      ./configure \
        --prefix="${rocks_prefix}" \
        --with-lua="${lua_prefix}" \
        --with-lua-include="${lua_prefix}/include/luajit-2.1" \
        --with-lua-lib="${lua_prefix}/lib" \
        --lua-version=5.1
    else
      ./configure \
        --prefix="${rocks_prefix}" \
        --with-lua="${lua_prefix}" \
        --with-lua-include="${lua_prefix}/include" \
        --with-lua-lib="${lua_prefix}/lib"
    fi
    make -j"${JOBS}"
    make install
  )
}
safe_mkdir "${PREFIX}/bin"
MISSING=()
for tool in "${NEEDED_TOOLS[@]}"; do
  if ! need_tool "${tool}"; then
    MISSING+=("${tool}")
  fi
done
if ((${#MISSING[@]} > 0)); then
  printf '\n⚠  The following required tools are missing: %s\n' "${MISSING[*]}"
  if command -v pacman >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1; then
    echo "→ Installing with: sudo pacman -S --needed ${MISSING[*]}"
    if sudo -n true 2>/dev/null; then
      sudo pacman -Sy --needed --noconfirm "${MISSING[@]}"
    else
      echo "   (sudo privileges required – please enter your password)"
      sudo pacman -Sy --needed "${MISSING[@]}"
    fi
    for t in "${MISSING[@]}"; do
      need_tool "${t}" || die "Required tool ${t} is still missing after install."
    done
  else
    echo "   Please install them with your package manager, then re‑run this script."
    exit 1
  fi
fi
export PATH="${PREFIX}/bin:${PATH}"
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
printf '%s\n\n' "    © 2026 Qompass AI. All rights reserved     "
for k in "${!MENU[@]}"; do
  printf ' %s) %s\n' "${k}" "${MENU[${k}]}"
done
printf '%s\n' " a) all"
printf '%s\n\n' " q) quit"
read -rp "Choose versions to build [1]: " choice
choice=${choice:-1}
[[ "${choice}" == "q" ]] && exit 0
VERSIONS=()
if [[ "${choice}" == "a" ]]; then
  VERSIONS=(5.1.5 5.2.4 5.3.6 5.4.6 luajit)
elif [[ "${choice}" == "1" ]]; then
  VERSIONS=("5.1.5")
else
  for n in ${choice}; do
    case "${n}" in
      1) VERSIONS+=("5.1.5") ;;
      2) VERSIONS+=("5.2.4") ;;
      3) VERSIONS+=("5.3.6") ;;
      4) VERSIONS+=("5.4.6") ;;
      5) VERSIONS+=("luajit") ;;
      *)
        die "Unknown option: ${n}"
        ;;
    esac
  done
fi
tmproot="$(mktemp -d "${TMPDIR:-/tmp}/lua-build.XXXXXXXX")"
trap 'rm -rf "${tmproot}"' EXIT
cd "${tmproot}"
for v in "${VERSIONS[@]}"; do
  if [[ "${v}" == "luajit" ]]; then
    echo -e "\n=== LuaJIT ==="
    git clone --depth 1 https://github.com/LuaJIT/LuaJIT.git
    pushd LuaJIT >/dev/null
    make -j"${JOBS}" CC="${CC}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
    make install PREFIX="${PREFIX}/luajit"
    popd >/dev/null
    rm -rf LuaJIT
    install_luarocks "${PREFIX}/luajit" "luajit"
    continue
  fi
  echo -e "\n=== Lua ${v} ==="
  curl -fsSLO "https://www.lua.org/ftp/lua-${v}.tar.gz"
  tar xf "lua-${v}.tar.gz"
  rm "lua-${v}.tar.gz"
  pushd "lua-${v}" >/dev/null
  make "${PLATFORM}" CC="${CC}" MYCFLAGS="${CFLAGS} ${SHARED}" MYLDFLAGS="${LDFLAGS}" -j"${JOBS}"
  if [[ -f src/liblua.a ]]; then
    "${CC}" "${CFLAGS}" -shared -o src/liblua.so \
      -Wl,--whole-archive src/liblua.a -Wl,--no-whole-archive -lm
  fi
  short="${v%.*}"
  dest="${PREFIX}/lua${short}"
  make install INSTALL_TOP="${dest}"
  if [[ -f src/liblua.so ]]; then
    safe_mkdir "${dest}/lib"
    install -m 755 src/liblua.so "${dest}/lib"
  fi
  popd >/dev/null
  rm -rf "lua-${v}"
  install_luarocks "${dest}" "lua"
  safe_mkdir "${dest}/lib/pkgconfig"
  cat >"${dest}/lib/pkgconfig/lua${short}.pc" <<EOF
prefix=${dest}
exec_prefix=\${prefix}
libdir=\${prefix}/lib
includedir=\${prefix}/include
Name: Lua ${short}
Version: ${v}
Libs: -L\${libdir} -llua
Cflags: -I\${includedir}
EOF
done
add_to_bash_rc "${HOME}/.bashrc"
add_to_bash_rc "${HOME}/.zshrc"
add_to_fish_config
echo -e "\n✔  Lua QuickStart Done UwU ."
echo "   Prefix: ${PREFIX}"
echo "   Binaries live under:"
echo "     - ${PREFIX}/lua*/bin"
echo "     - ${PREFIX}/luajit/bin"
echo "   PATH entry added for: ${PREFIX}/bin (wrapper dir for tools you may add later)"
