#!/usr/bin/env bash

# /qompassai/Lua/wireplumber/scripts/test.sh
# Qompass AI WirePlumber Test Script
# Copyright (C) 2026 Qompass AI, All rights reserved
# ----------------------------------------
SCRIPTS=/usr/share/wireplumber/scripts
for f in \
    node/audio-group.lua \
    node/create-item.lua \
    node/filter-forward-format.lua \
    node/software-dsp.lua \
    node/state-stream.lua \
    node/suspend-node.lua \
    linking/find-audio-group-target.lua \
    linking/find-best-target.lua \
    linking/find-default-target.lua \
    linking/find-defined-target.lua \
    linking/find-filter-target.lua \
    linking/find-media-role-target.lua \
    linking/get-filter-from-target.lua \
    linking/prepare-link.lua \
    linking/link-target.lua \
    linking/rescan.lua \
    linking/rescan-media-role-links.lua \
    monitors/alsa.lua \
    monitors/alsa-midi.lua; do
    [ -f "$SCRIPTS/$f" ] && echo "OK  $f" || echo "MISSING  $f"
done
