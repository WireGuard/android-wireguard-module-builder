#!/bin/bash
set -ex

BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
for i in "$BASE"/kernels/*; do
	KERNEL="${i##*/}"
	[[ -d "$BASE/kernels/$KERNEL" ]] || continue
	"$BASE/build-one.bash" "$KERNEL"
done
