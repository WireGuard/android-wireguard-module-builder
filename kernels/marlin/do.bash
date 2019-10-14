#!/bin/bash
set -ex
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
patch -d WireGuard -p1 < "$BASE/tvec_base_deferrable-hack.patch"
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config
./build/build.sh
readlink -f out/android-msm-marlin-3.18/dist/wireguard.ko >&7
