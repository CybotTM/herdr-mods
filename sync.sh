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
  # Settings a mod.schema.json describes are your own choices (Mod settings): ship the defaults.
  if [ -f "$mod/mod.schema.json" ] && jq -e '.settings' "$mod/mod.json" >/dev/null 2>&1; then
    jq 'del(.settings)' "$mod/mod.json" > "$mod/mod.json.tmp" && mv "$mod/mod.json.tmp" "$mod/mod.json"
  fi
  echo "synced $mod"
done
