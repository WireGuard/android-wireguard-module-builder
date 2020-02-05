#!/bin/bash
set -ex
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
patch -d private/msm-google -p1 < "$BASE/selinux.patch"
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config.common
echo 'ccflags-y += -Wno-unused-variable' >> wireguard-linux-compat/src/Kbuild
./build/build.sh
./prebuilts-master/clang/host/linux-x86/clang-r346389c/bin/llvm-strip -strip-debug out/android-msm-floral-4.14/dist/wireguard.ko
readlink -f out/android-msm-floral-4.14/dist/wireguard.ko >&7
