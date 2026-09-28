<!--------------- /qompassai/lua/README.md --------------->
<!---------------------Qompass AI Lua -------------------->
<!-- Copyright (C) 2025 Qompass AI, All rights reserved -->
<!-- ----------------------------------------------------->

<h1 align="center">Qompass AI on Lua</h1>

<h2 align="center">Educational Content on the Lua Programming Language</h2>


![Repository Views](https://komarev.com/ghpvc/?username=qompassai-Lua)
![GitHub all releases](https://img.shields.io/github/downloads/qompassai/Lua/total?style=flat-square)
<p align="center">
<a href="https://www.lua.org/"><img src="https://img.shields.io/badge/Lua-2C2D72?style=for-the-badge&logo=lua&logoColor=white" alt="Lua"></a> <br> <a href="https://www.lua.org/docs.html"><img src="https://img.shields.io/badge/Lua-Documentation-blue?style=flat-square" alt="Lua Documentation"></a> <a href="https://github.com/topics/lua-tutorial"><img src="https://img.shields.io/badge/Lua-Tutorials-green?style=flat-square" alt="Lua Tutorials"></a> <br> <a href="./LICENSE"><img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License: Apache 2.0"></a>
</p>

<details>
  <summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;">
    <strong>
      <img src="https://raw.githubusercontent.com/qompassai/svg/main/assets/icons/lua/lua.svg"
           alt="Qompass AI Lua Icon"
           style="height: 1em; vertical-align: -0.2em; margin-right: 0.25em;" />
      Lua Solutions
    </strong>
  </summary>
  <div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace;">

* [Qompass Diver](https://github.com/qompassai/Diver)
* [Qompass rose.nvim](https://github.com/qompassai/rose.nvim)
* [Qompass blaze.nvim](https://github.com/qompassai/blaze.nvim)
* [Qompass blaze-ts.nvim](https://github.com/qompassai/blaze-ts.nvim)
* [Qompass QLuV](https://github.com/qompassai/qluv)

 </div>

</details>


<details>
  <summary
  style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;">
  <strong>▶️ Qompass AI Quick Start</strong>
</summary>
<div style="background: #f8f9fa; padding: 15px; border-radius: 5px; margin-top: 10px; font-family: monospace;">
  <pre><code># Download and run the compiled binary installer
curl -fsSL https://raw.githubusercontent.com/qompassai/dotfiles/main/scripts/qai_lua_installer -o qai_lua_installer && \
  chmod +x qai_lua_installer && \
  ./qai_lua_installer

# Alternatively, you can fetch and run the original shell script:

# bash <(curl -fsSL https://raw.githubusercontent.com/qompassai/dotfiles/main/scripts/quickstart.sh)

</code></pre>

</div>
      <summary style="font-size: 1em; font-weight: bold; padding: 10px; background: #e9ecef; color: #333; border-radius: 5px; cursor: pointer; margin: 10px 0;">
        <strong>📄 We advise you read the script BEFORE running it 😉</strong>
      </summary>
      <pre style="background: #fff; padding: 15px; border-radius: 5px; border: 1px solid #ddd; overflow-x: auto;">
#!/usr/bin/env bash
# qompassai/Lua/scripts/quickstart.sh
# Qompass AI Diver Lua Quick‑Start
# Copyright (C) 2025 Qompass AI, All rights reserved
#################################################### 
set -euo pipefail
PREFIX="$HOME/.local"
mkdir -p "$PREFIX/bin"
NEEDED_TOOLS=(git curl tar make clang)
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
\[1]="lua 5.1.5"
\[2]="lua 5.2.4"
\[3]="lua 5.3.6"
\[4]="lua 5.4.6"
\[5]="LuaJIT"
)
printf '%s\n' "╭─────────────────────────────────────────────╮"
printf '%s\n' "│       Qompass AI · Lua Quick‑Start          │"
printf '%s\n' "╰─────────────────────────────────────────────╯"
printf '%s\n\n' "    © 2025 Qompass AI. All rights reserved     "
for k in "${!MENU\[@]}"; do printf ' %s) %s\n' "$k" "${MENU\[$k]}"; done
printf '%s\n' " a) all   (default)"
printf '%s\n\n' " q) quit"
read -rp "Choose versions to build \[a]: " choice
choice=${choice:-a}
\[\[ $choice == q ]] && exit 0
VERSIONS=()
if \[\[ $choice == a ]]; then
VERSIONS=(5.1.5 5.2.4 5.3.6 5.4.6 luajit)
else
for n in $choice; do
case $n in
1\) VERSIONS+=("5.1.5") ;;
2\) VERSIONS+=("5.2.4") ;;
3\) VERSIONS+=("5.3.6") ;;
4\) VERSIONS+=("5.4.6") ;;
5\) VERSIONS+=("luajit") ;;
*)
echo "Unknown option $n"
exit 1
;;
esac
done
fi
LUAROCKS\_VERSION="3.12.1"
DEFAULT\_IMPL="luajit"
JOBS=$(nproc 2>/dev/null || sysctl -n hw.ncpu || echo 4)
: "${CC:=clang}"
CFLAGS="-O3 -march=native -flto -fPIC -pipe -fstack-protector-strong"
LDFLAGS="-flto -Wl,-O1,--as-needed,-z,relro,-z,now"
\[\[ -x $(command -v ld.lld) ]] && LDFLAGS+=" -fuse-ld=lld"
case "$(uname -s)" in
Darwin*)
PLATFORM=macosx
SHARED="-DLUA\_USE\_MACOSX"
;;
MINGW\* | MSYS\* | CYG\*)
PLATFORM=mingw
SHARED=""
;;
\*)
PLATFORM=linux
SHARED="-DLUA\_USE\_LINUX"
;;
esac
add\_to\_rc() {
local rc\_file=$1
local line="export PATH='$PREFIX/bin:$PATH'"
if \[\[ -f "$rc\_file" ]] && ! grep -Fq "$line" "$rc\_file"; then
printf '\n# added by lua quickstart\n%s\n' "$line" >>"$rc\_file"
echo " → PATH updated in $rc\_file"
fi
}
install\_luarocks() {
local lua\_prefix="$1"
local rocks\_prefix="$lua\_prefix"
pushd /tmp >/dev/null
curl -fsSLO "https://luarocks.org/releases/luarocks-$LUAROCKS\_VERSION.tar.gz"
tar xf "luarocks-$LUAROCKS\_VERSION.tar.gz"
cd "luarocks-$LUAROCKS\_VERSION"
./configure \
\--prefix="$rocks\_prefix" \
\--with-lua="$lua\_prefix" \
\--with-lua-include="$lua\_prefix/include" \
\--with-lua-lib="$lua\_prefix/lib"
make -j"$JOBS"
make install
local tag
tag=$(basename "$lua\_prefix" | sed 's/^lua//;s/^luajit$/jit/')
ln -sf "$rocks\_prefix/bin/luarocks" "$PREFIX/bin/luarocks$tag"
popd >/dev/null
rm -rf "/tmp/luarocks-$LUAROCKS\_VERSION"
}
cd /tmp
for v in "${VERSIONS\[@]}"; do
if \[\[ $v == luajit ]]; then
echo -e "\n=== LuaJIT ==="
git clone --depth 1 https://github.com/LuaJIT/LuaJIT.git
pushd LuaJIT >/dev/null
make -j"$JOBS" CC="$CC" CFLAGS="$CFLAGS" LDFLAGS="$LDFLAGS"
make install PREFIX="$PREFIX/luajit"
ln -sf "$PREFIX/luajit/bin/luajit" "$PREFIX/bin/luajit"
popd >/dev/null && rm -rf LuaJIT
install\_luarocks "$PREFIX/luajit"
continue
fi
echo -e "\n=== Lua $v ==="
curl -fsSLO "https://www.lua.org/ftp/lua-$v.tar.gz"
tar xf "lua-$v.tar.gz" && rm "lua-$v.tar.gz"
pushd "lua-$v" >/dev/null
make "$PLATFORM" CC="$CC" MYCFLAGS="$CFLAGS $SHARED" MYLDFLAGS="$LDFLAGS" -j"$JOBS"
$CC "$CFLAGS" -shared -o src/liblua.so -Wl,--whole-archive src/liblua.a -Wl,--no-whole-archive -lm
short=${v%.\*}
dest="$PREFIX/lua$short"
make install INSTALL\_TOP="$dest"
install -m 755 src/liblua.so "$dest/lib"
ln -sf "$dest/bin/lua" "$PREFIX/bin/lua$short"
ln -sf "$dest/bin/luac" "$PREFIX/bin/luac$short"
popd >/dev/null && rm -rf "lua-$v"
install\_luarocks "$dest"
cat >"$dest/lib/pkgconfig/lua$short.pc" <\<EOF
prefix=$dest
exec\_prefix=${prefix}
libdir=${prefix}/lib
includedir=${prefix}/include
Name: Lua $short
Version: $v
Libs: -shared -L${libdir} -llua
Cflags: -I${includedir}
EOF
done
if \[\[ $DEFAULT\_IMPL == luajit ]]; then
ln -sf "$PREFIX/bin/luajit" "$PREFIX/bin/lua"
ln -sf "$PREFIX/bin/luajit" "$PREFIX/bin/luac"
else
def\_short=${DEFAULT\_IMPL//./}
ln -sf "$PREFIX/bin/lua$def\_short" "$PREFIX/bin/lua"
ln -sf "$PREFIX/bin/luac$def\_short" "$PREFIX/bin/luac"
fi
add\_to\_rc "$HOME/.bashrc"
add\_to\_rc "$HOME/.zshrc"
echo -e "\n✔  Build complete.  Open a new shell or run 'source ~/.bashrc' | 'source ~/.zshrc' for it to take effect ."</pre>

</details> <p>Or, <a href="https://github.com/qompassai/Lua/blob/main/scripts/quickstart.sh" target="_blank">View the quickstart script</a>.</p>

  </blockquote>
</details>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #667eea; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🧭 About Qompass AI</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #f8f9fa; border-left: 6px solid #667eea; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">
  <p>Matthew A. Porter<br>
  Former Intelligence Officer<br>
  Educator & Learner<br>
  DeepTech Founder & CEO</p>
</div>

<h3>Publications</h3>
  <p>
    <a href="https://orcid.org/0000-0002-0302-4812">
      <img src="https://img.shields.io/badge/ORCID-0000--0002--0302--4812-green?style=flat-square&logo=orcid" alt="ORCID">
    </a>
    <a href="https://www.researchgate.net/profile/Matt-Porter-7">
      <img src="https://img.shields.io/badge/ResearchGate-Open--Research-blue?style=flat-square&logo=researchgate" alt="ResearchGate">
    </a>
    <a href="https://zenodo.org/communities/qompassai">
      <img src="https://img.shields.io/badge/Zenodo-Publications-blue?style=flat-square&logo=zenodo" alt="Zenodo">
    </a>
  </p>

<h3>Developer Programs</h3>

[![NVIDIA Developer](https://img.shields.io/badge/NVIDIA-Developer_Program-76B900?style=for-the-badge\&logo=nvidia\&logoColor=white)](https://developer.nvidia.com/)
[![Meta Developer](https://img.shields.io/badge/Meta-Developer_Program-0668E1?style=for-the-badge\&logo=meta\&logoColor=white)](https://developers.facebook.com/)
[![HackerOne](https://img.shields.io/badge/-HackerOne-%23494649?style=for-the-badge\&logo=hackerone\&logoColor=white)](https://hackerone.com/phaedrusflow)
[![HuggingFace](https://img.shields.io/badge/HuggingFace-qompass-yellow?style=flat-square\&logo=huggingface)](https://huggingface.co/qompass)
[![Epic Games Developer](https://img.shields.io/badge/Epic_Games-Developer_Program-313131?style=for-the-badge\&logo=epic-games\&logoColor=white)](https://dev.epicgames.com/)

<h3>Professional Profiles</h3>
  <p>
    <a href="https://www.linkedin.com/in/matt-a-porter-103535224/">
      <img src="https://img.shields.io/badge/LinkedIn-Matt--Porter-blue?style=flat-square&logo=linkedin" alt="Personal LinkedIn">
    </a>
    <a href="https://www.linkedin.com/company/95058568/">
      <img src="https://img.shields.io/badge/LinkedIn-Qompass--AI-blue?style=flat-square&logo=linkedin" alt="Startup LinkedIn">
    </a>
  </p>

<h3>Social Media</h3>
  <p>
    <a href="https://twitter.com/PhaedrusFlow">
      <img src="https://img.shields.io/badge/Twitter-@PhaedrusFlow-blue?style=flat-square&logo=twitter" alt="X/Twitter">
    </a>
    <a href="https://www.instagram.com/phaedrusflow">
      <img src="https://img.shields.io/badge/Instagram-phaedrusflow-purple?style=flat-square&logo=instagram" alt="Instagram">
    </a>
    <a href="https://www.youtube.com/@qompassai">
      <img src="https://img.shields.io/badge/YouTube-QompassAI-red?style=flat-square&logo=youtube" alt="Qompass AI YouTube">
    </a>
  </p>

</blockquote>
</details>

<details>
<summary style="font-size: 1.4em; font-weight: bold; padding: 15px; background: #ff6b6b; color: white; border-radius: 10px; cursor: pointer; margin: 10px 0;"><strong>🔥 How Do I Support</strong></summary>
<blockquote style="font-size: 1.2em; line-height: 1.8; padding: 25px; background: #fff5f5; border-left: 6px solid #ff6b6b; border-radius: 8px; margin: 15px 0; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">

<div align="center">

<table>
<tr>
<th align="center">🏛️ Qompass AI Pre-Seed Funding 2023-2025</th>
<th align="center">🏆 Amount</th>
<th align="center">📅 Date</th>
</tr>
<tr>
<td><a href="https://github.com/qompassai/r4r" title="RJOS/Zimmer Biomet Research Grant Repository">RJOS/Zimmer Biomet Research Grant</a></td>
<td align="center">$30,000</td>
<td align="center">March 2024</td>
</tr>
<tr>
<td><a href="https://github.com/qompassai/PathFinders" title="GitHub Repository">Pathfinders Intern Program</a><br>
<small><a href="https://www.linkedin.com/posts/evergreenbio_bioscience-internships-workforcedevelopment-activity-7253166461416812544-uWUM/" target="_blank">View on LinkedIn</a></small></td>
<td align="center">$2,000</td>
<td align="center">October 2024</td>
</tr>
</table>

<br>
<h4>🤝 How To Support Our Mission</h4>

[![GitHub Sponsors](https://img.shields.io/badge/GitHub-Sponsor-EA4AAA?style=for-the-badge\&logo=github-sponsors\&logoColor=white)](https://github.com/sponsors/phaedrusflow)
[![Patreon](https://img.shields.io/badge/Patreon-Support-F96854?style=for-the-badge\&logo=patreon\&logoColor=white)](https://patreon.com/qompassai)
[![Liberapay](https://img.shields.io/badge/Liberapay-Donate-F6C915?style=for-the-badge\&logo=liberapay\&logoColor=black)](https://liberapay.com/qompassai)
[![Open Collective](https://img.shields.io/badge/Open%20Collective-Support-7FADF2?style=for-the-badge\&logo=opencollective\&logoColor=white)](https://opencollective.com/qompassai)
[![Buy Me A Coffee](https://img.shields.io/badge/Buy%20Me%20A%20Coffee-Support-FFDD00?style=for-the-badge\&logo=buy-me-a-coffee\&logoColor=black)](https://www.buymeacoffee.com/phaedrusflow)

<details markdown="1">
<summary><strong>🔐 Cryptocurrency Donations</strong></summary>

**Monero (XMR):**

<div align="center">
  <h3>Support via Monero</h3>
    <img src="https://www.github.com/qompassai/svg/assets/monero-qr.svg" alt="Monero QR Code" width="180">
</div>
<div style="margin: 10px 0; text-align: center;">
  <code>42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH</code>
</div>

<button onclick="navigator.clipboard.writeText('42HGspSFJQ4MjM5ZusAiKZj9JZWhfNgVraKb1eGCsHoC6QJqpo2ERCBZDhhKfByVjECernQ6KeZwFcnq8hVwTTnD8v4PzyH')" style="padding: 6px 12px; background: #FF6600; color: white; border: none; border-radius: 4px; cursor: pointer;">
    📋 Copy Address
  </button>
<p><i>Funding helps us continue our research at the intersection of AI, healthcare, and education</i></p>

</blockquote>
</details>
</details>

<details id="FAQ">
  <summary><strong>Frequently Asked Questions</strong></summary>

### Q: How do you mitigate against bias?

**TLDR - we do math to make AI ethically useful**

### A: We delineate between mathematical bias (MB) - a fundamental parameter in neural network equations - and algorithmic/social bias (ASB). While MB is optimized during model training through backpropagation, ASB requires careful consideration of data sources, model architecture, and deployment strategies. We implement attention mechanisms for improved input processing and use legal open-source data and secure web-search APIs to help mitigate ASB.

[AAMC AI Guidelines | One way to align AI against ASB](https://www.aamc.org/about-us/mission-areas/medical-education/principles-ai-use)

### AI Math at a glance

## Forward Propagation Algorithm

$$
y = w_1x_1 + w_2x_2 + ... + w_nx_n + b
$$

Where:

- $y$ represents the model output
- $(x_1, x_2, ..., x_n)$ are input features
- $(w_1, w_2, ..., w_n)$ are feature weights
- $b$ is the bias term

### Neural Network Activation

For neural networks, the bias term is incorporated before activation:

$$
z = \sum_{i=1}^{n} w_ix_i + b
$$
$$
a = \sigma(z)
$$

Where:

- $z$ is the weighted sum plus bias
- $a$ is the activation output
- $\sigma$ is the activation function

### Attention Mechanism- aka what makes the Transformer (The "T" in ChatGPT) powerful

- [Attention High level overview video](https://www.youtube.com/watch?v=fjJOgb-E41w)

- [Attention Is All You Need Arxiv Paper](https://arxiv.org/abs/1706.03762)

The Attention mechanism equation is:

$$
Attention(Q, K, V) = softmax(\frac{QK^T}{\sqrt{d_k}})V
$$

Where:

- $Q$ represents the Query matrix
- $K$ represents the Key matrix
- $V$ represents the Value matrix
- $d_k$ is the dimension of the key vectors
- $\text{softmax}(\cdot)$ normalizes scores to sum to 1

### Q: Do I have to buy a Linux computer to use this? I don't have time for that!

### A: No. You can run Linux and/or the tools we share alongside your existing operating system:

- Windows users can use Windows Subsystem for Linux [WSL](https://learn.microsoft.com/en-us/windows/wsl/install)
- Mac users can use [Homebrew](https://brew.sh/)
- The code-base instructions were developed with both beginners and advanced users in mind.

### Q: Do you have to get a masters in AI?

### A: Not if you don't want to. To get competent enough to get past ChatGPT dependence at least, you just need a computer and a beginning's mindset. Huggingface is a good place to start.

- [Huggingface](https://docs.google.com/presentation/d/1IkzESdOwdmwvPxIELYJi8--K3EZ98_cL6c5ZcLKSyVg/edit#slide=id.p)

### Q: What makes a "small" AI model?

### A: AI models ~=10 billion(10B) parameters and below. For comparison, OpenAI's GPT4o contains approximately 200B parameters.

</details>

## License

This project is licensed under the [Apache License, Version 2.0](./LICENSE).

Copyright 2025 Qompass AI.
