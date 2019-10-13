#!/bin/bash
set -ex

BASE="$(readlink -f "$(dirname "$(readlink -f "$0")")")"
source "$BASE/server.conf"
SSH_OPTS=( -q -o ControlMaster=auto -o ControlPath=../.ssh-deployment.sock )

cd "$BASE/../out"
sha256sum *.ko > modules.txt
signify -S -e -s "$SIGNING_KEY" -m modules.txt
rm modules.txt

ssh "${SSH_OPTS[@]}" -Nf "$WEB_SERVER"
ssh -t "${SSH_OPTS[@]}" $WEB_SERVER "sudo -u nginx -v"
rsync -aizm --delete --rsh="ssh ${SSH_OPTS[*]}" --rsync-path="sudo -n -u nginx rsync" ./ "$WEB_SERVER:$SERVER_PATH"
ssh -t "${SSH_OPTS[@]}" "$WEB_SERVER" "sudo chown -R nginx:nginx '$SERVER_PATH'"
ssh -t "${SSH_OPTS[@]}" "$WEB_SERVER" "sudo find '$SERVER_PATH' -type f -exec chmod 640 {} \;; sudo find '$SERVER_PATH' -type d -exec chmod 750 {} \;;"
ssh -O exit "${SSH_OPTS[@]}" "$WEB_SERVER"

