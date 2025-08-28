#!/usr/bin/env bash

set -oue pipefail

GUM_SELECT="gum choose --height=30 --selected.bold --selected.underline"
DEST_DIR="${HOME}/.cache/chopper"
mkdir -p "${DEST_DIR}"

IMAGE_DIR="${PWD}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d)
      shift
      IMAGE_DIR="$1"
      shift
      ;;
    -c)
      shift
      IMAGE_DIR="${HOME}"/Pictures
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Image Directory: $IMAGE_DIR"

image_Selector() {
    # Enable nullglob to avoid patterns when no matches
    shopt -s nullglob

    IMAGES=("${IMAGE_DIR}"/*.{jpg,jpeg,png,gif})

    if [[ ${#IMAGES[@]} -eq 0 ]]; then
        echo "No images found in ${IMAGE_DIR}."
        exit 1
    fi

    # Preview selected image
    IMAGE=$(printf "%s\n" "${IMAGES[@]}" | fzf --preview 'img2sixel -p 64 -w 256 {}')
}

wallpaper_Selector() {
    image_Selector

    cp --force "${IMAGE}" "${DEST_DIR}/wallpaper"
    echo "Copied ${IMAGE} to ${DEST_DIR}/wallpaper."

    swww img --transition-duration 1 --transition-step 30 "${DEST_DIR}"/wallpaper
}

profile_Selector() {
    image_Selector

    cp --force "${IMAGE}" "${DEST_DIR}/profile"
    echo "Copied ${IMAGE} to ${DEST_DIR}/profile"
}

SELECTION=$(${GUM_SELECT} "profile" "wallpaper")

if [[ "${SELECTION}" == "profile" ]];
then
    profile_Selector
elif [[ "${SELECTION}" == "wallpaper" ]];
then
    wallpaper_Selector
else
    echo "No valid selection made."
fi
