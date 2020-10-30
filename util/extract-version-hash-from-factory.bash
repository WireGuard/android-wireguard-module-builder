#!/bin/bash
set -e

URL="$1"
# Expecting URL like https://dl.google.com/dl/android/aosp/crosshatch-qp1a.191005.007-factory-2989a08d.zip
[[ -n $URL ]] || { echo "Usage: $0 URL" >&2; exit 1; }

UTIL="$(dirname "$(readlink -f "$0")")"
D="$(mktemp -d)"
trap 'rm -rf "$D"' INT TERM EXIT
cd "$D"

curl -#o out.zip "$URL"
bsdtar --strip-components 1 -xvf out.zip
bsdtar -xvf image-*.zip boot.img
if [[ $URL =~ bramble || $URL =~ redfin ]]; then
    "$UTIL"/unpack_bootimg.py --boot_img boot.img
    COMP_IMG=out/kernel
    DECOMP_IMG=out/kernel-decomp
else
    abootimg -x boot.img
    COMP_IMG=zImage
    DECOMP_IMG=Image
fi
unlz4 "$COMP_IMG" "$DECOMP_IMG"
version="$(strings "$DECOMP_IMG" | grep '^Linux version [^%]' | head -n 1)"
[[ -n $version ]] || { echo "ERROR: no proper version in image" >&2; exit 1; }
printf '\n==========================================\n\n%s|%s\n' "$(echo "$version" | sha256sum | cut -d ' ' -f 1)" "$version"
