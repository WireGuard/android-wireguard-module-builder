#!/bin/bash
set -e

URL="$1"
# Expecting URL like https://dl.google.com/dl/android/aosp/crosshatch-qp1a.191005.007-factory-2989a08d.zip
[[ -n $URL ]] || { echo "Usage: $0 URL" >&2; exit 1; }

D="$(mktemp -d)"
trap 'rm -rf "$D"' INT TERM EXIT
cd "$D"

curl -#o out.zip "$URL"
bsdtar --strip-components 1 -xvf out.zip
bsdtar -xvf image-*.zip boot.img
abootimg -x boot.img
unlz4 zImage Image
version="$(strings Image | grep '^Linux version [^%]' | head -n 1)"
[[ -n $version ]] || { echo "ERROR: no proper version in image" >&2; exit 1; }
printf '\n==========================================\n\n%s|%s\n' "$(echo "$version" | sha256sum | cut -d ' ' -f 1)" "$version"
