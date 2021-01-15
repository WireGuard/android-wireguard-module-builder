#!/bin/bash
set -ex

[[ $# -eq 1 ]] || { echo "Usage: $0 KERNEL_NAME" >&2; exit 1; }
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
KERNEL_DIR="$BASE/kernels/$1"
# For use in kernel-specific do.bash files
export KERNEL_DIR
[[ -d $KERNEL_DIR ]] || { echo "Error: '$0' does not exist" >&2; exit 1; }

# Step 1) Account for already built modules by hard linking new hashes to the old names.
first=""
while IFS='|' read -r hash ver; do
	if [[ -f $BASE/out/wireguard-$hash.ko ]]; then
		first="$hash"
		break
	fi
done < "$KERNEL_DIR/version-hashes.txt"
if [[ -n $first ]]; then
	while IFS='|' read -r hash ver; do
		[[ -f $BASE/out/wireguard-$hash.ko ]] || ln "$BASE/out/wireguard-$first.ko" "$BASE/out/wireguard-$hash.ko"
	done < "$KERNEL_DIR/version-hashes.txt"
	exit 0
fi

# Step 2) Make working directory.
D="$(mktemp -d)"
trap 'rm -rf "$D"' INT TERM EXIT
cd "$D"

# Step 3) Initialize repo with manifests and fetch repositories.
mkdir -p manifest
cd manifest
git init --initial-branch=master
git config user.email "$(id -un)@$(hostname)"
git config user.name "$(id -un)"
cp "$KERNEL_DIR/manifest.xml" default.xml
git add default.xml
git commit -m "Initial commit"
cd ..
repo init -u ./manifest
mkdir -p .repo/local_manifests
cp "$BASE/files/wireguard.xml" .repo/local_manifests/
repo sync

# Step 4) Inject shim module and launch build.
mkdir -p wireguard
cp "$BASE/files/shim.make" wireguard/Makefile
exec 9>&1
read -r output < <("$BASH" "$KERNEL_DIR/do.bash" 7>&1 >&9)
exec 9>-
[[ -f $output ]]

# Step 5) Copy first module out and hard link the rest.
mkdir -p "$BASE/out"
first=""
while IFS='|' read -r hash vers; do
	if [[ -z $first ]]; then
		cp "$output" "$BASE/out/wireguard-$hash.ko"
		first="$hash"
	else
		ln "$BASE/out/wireguard-$first.ko" "$BASE/out/wireguard-$hash.ko"
	fi
done < "$KERNEL_DIR/version-hashes.txt"
