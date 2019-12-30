#!/bin/bash
set -ex
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config.common
echo 'ccflags-y += -Wno-unused-variable' >> wireguard-linux-compat/src/Kbuild
./build/build.sh
readlink -f out/android-msm-floral-4.14/dist/wireguard.ko >&7
