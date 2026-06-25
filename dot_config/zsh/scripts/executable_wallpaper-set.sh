#!/usr/bin/env bash

set -oue pipefail

WALLPAPER_DIR=$HOME/.cache/chopper
mkdir -p ~/.cache/chopper

# Check if a file path is provided as an argument
if [ -z "$1" ]; then
 echo "Usage: $0 <path_to_wallpaper>"
 exit 1
fi

WALLPAPER="$1"

# Verify the file exists before proceeding
if [[ ! -f "$WALLPAPER" ]]; then
 echo "Error: File '$WALLPAPER' not found."
 exit 1
fi

# Set wallpaper
pkill -x swaybg || true
BG_COLOR=$(convert "$WALLPAPER" -resize 1x1 txt:- | rg -o "#[[:xdigit:]]{6}" | cut -c 2-)
cp --force "$WALLPAPER" "$WALLPAPER_DIR"/wallpaper
swaybg -i "$WALLPAPER_DIR"/wallpaper -m fit -c "$BG_COLOR" & disown

# Lockscreen is done afterwards to speed up time to wallpaper
magick "$WALLPAPER" -adaptive-blur 0x8 "$WALLPAPER_DIR"/wallpaper_blurred
