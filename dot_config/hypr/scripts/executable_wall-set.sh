#!/usr/bin/env bash

set -oue pipefail

# Check deps
check_requirements(){
    script_deps=(
        "img2sixel"
        "gum"
        "fzf"
        "swww"
    )

    missing_deps=()

    # Loop through each dependency and check if it's installed
    for dep in "${script_deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done

    # If there are any missing dependencies, output them
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo "Error: Missing dependencies:"
        for dep in "${missing_deps[@]}"; do
            echo "- $dep"
        done
        exit 1
    fi
}

check_requirements

GUM_SELECT="gum choose --height=30 --selected.bold --selected.underline"
DEST_DIR="${HOME}/.cache/corse"
mkdir -p "${DEST_DIR}"

# Defaults to PWD, but can be overwritten with `-d`
IMAGE_DIR="${PWD}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -d)
      shift
      IMAGE_DIR="$1"
      shift
      ;;
    *)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

echo "Image Directory: $IMAGE_DIR"

# wallpaper selector
wallpaper_Selector() {
    # Enable nullglob to avoid patterns when no matches
    shopt -s nullglob

    IMAGES=("${IMAGE_DIR}"/*.{jpg,jpeg,png,gif})

    if [[ ${#IMAGES[@]} -eq 0 ]]; then
        echo "No images found in ${IMAGE_DIR}."
        exit 1
    fi

    # Preview selected image
    IMAGE=$(printf "%s\n" "${IMAGES[@]}" | fzf --preview 'img2sixel -p 64 -w 256 {}')


    # overwrite wallpaper
    cp --force "${IMAGE}" "${DEST_DIR}/wallpaper"
    echo "Copied ${IMAGE} to ${DEST_DIR}/wallpaper."

    swww img --transition-duration 1 --transition-step 30 "${DEST_DIR}"/wallpaper
}

# profile selector
profile_Selector() {
    # Enable nullglob to avoid patterns when no matches
    shopt -s nullglob

    IMAGES=("${IMAGE_DIR}"/*.{jpg,jpeg,png})

    if [[ ${#IMAGES[@]} -eq 0 ]]; then
        echo "No images found in ${IMAGE_DIR}."
        exit 1
    fi

    # Preview selected image
    IMAGE=$(printf "%s\n" "${IMAGES[@]}" | fzf --preview 'img2sixel -p 64 -w 256 {}')

    # overwrite profile
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
