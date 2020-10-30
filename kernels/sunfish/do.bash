#!/bin/bash
set -ex
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config.common
echo 'ccflags-y += -Wno-unused-variable' >> wireguard-linux-compat/src/Kbuild
./build/build.sh
./prebuilts-master/clang/host/linux-x86/clang-r383902/bin/llvm-strip -strip-debug out/android-msm-pixel-4.14/dist/wireguard.ko
readlink -f out/android-msm-pixel-4.14/dist/wireguard.ko >&7
