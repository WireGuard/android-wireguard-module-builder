#!/bin/bash
set -ex
sed -i 's/EXT_MODULES="/EXT_MODULES="\nwireguard/' private/msm-google/build.config.common
echo 'ccflags-y += -Wno-unused-variable' >> WireGuard/src/Kbuild
./build/build.sh
readlink -f out/android-msm-pixel-4.9/dist/wireguard.ko >&7
