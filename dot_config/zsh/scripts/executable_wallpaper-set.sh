#!/usr/bin/env bash

set -oue pipefail

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

# Copy the wallpaper to the cache directory
WALLPAPER_DIR=$HOME/.cache/chopper
mkdir -p ~/.cache/chopper
cp --force "$WALLPAPER" "$WALLPAPER_DIR"/wallpaper

# Kill any existing swaybg processes.
# We use '|| true' to prevent the script from exiting if no processes are found.
pkill -x swaybg || true

# Start the new wallpaper and disown the process
swaybg -i "$WALLPAPER_DIR"/wallpaper -m fill & disown
