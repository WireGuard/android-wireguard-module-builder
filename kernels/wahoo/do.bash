#!/bin/bash
set -ex
echo 'EXT_MODULES="${EXT_MODULES} wireguard"' >> private/msm-google/build.config
./build/build.sh
readlink -f out/android-msm-wahoo-4.4/dist/wireguard.ko >&7
