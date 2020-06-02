#!/bin/bash
set -ex
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
patch -d private/msm-google -p1 < "$BASE/0001-BACKPORT-arm64-makefile-fix-build-of-.i-file-in-exte.patch"
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config
./build/build.sh
readlink -f out/android-msm-wahoo-4.4/dist/wireguard.ko >&7
