#!/bin/bash
set -ex
BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
patch -d WireGuard -p1 < "$BASE/tvec_base_deferrable-hack.patch"
