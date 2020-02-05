#!/bin/bash
set -ex

cd kernel
ln -s ../../wireguard-linux-compat/src net/wireguard

# Inject the kernel module. Reference: https://git.zx2c4.com/android_kernel_wireguard/tree/patch-kernel.sh
[[ $(< net/Makefile) == *wireguard* ]] || sed -i "/^obj-\\\$(CONFIG_NETFILTER).*+=/a obj-\$(CONFIG_WIREGUARD) += wireguard/" net/Makefile
[[ $(< net/Kconfig) == *wireguard* ]] ||  sed -i "/^if INET\$/a source \"net/wireguard/Kconfig\"" net/Kconfig

# Based on Readme.txt in ocndtwl-4.4.153-perf-g0041d80.tar.gz, which is in turn downloaded from htcdev.com
mkdir out
make ARCH=arm64 CROSS_COMPILE="$PWD/../aarch64-linux-android-4.9/bin/aarch64-linux-android-" O=out htcperf_defconfig
make ARCH=arm64 CROSS_COMPILE="$PWD/../aarch64-linux-android-4.9/bin/aarch64-linux-android-" O=out -j$(nproc)

../aarch64-linux-android-4.9/bin/aarch64-linux-android-strip --strip-debug out/net/wireguard/wireguard.ko
readlink -f out/net/wireguard/wireguard.ko >&7
