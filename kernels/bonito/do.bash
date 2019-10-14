#!/bin/bash
set -ex
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config.common
echo 'ccflags-y += -Wno-unused-variable' >> WireGuard/src/Kbuild
./build/build.sh
readlink -f out/android-msm-pixel-4.9/dist/wireguard.ko >&7
