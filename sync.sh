#!/bin/sh
# Copies each folder's mods from your Herdr home into this repo, so a commit captures what you run.
# Leaves out the type files Herdr writes itself.
set -e
cd "$(dirname "$0")"
HOME_DIR="${HERDR_APP_HOME:-$HOME/.config/herdr-app}"
for mod in */mods/*/; do
  name=$(basename "$mod")
  rsync -a --delete --exclude gpui-kit.d.ts --exclude herdr.d.ts --exclude jsconfig.json \
    --exclude node_modules --exclude .cache --exclude .DS_Store \
    "$HOME_DIR/mods/$name/" "$mod"
  echo "synced $mod"
done
