#!/usr/bin/env bash

set -oue pipefail

get_containers (){
    podman ps -a --filter label=manager=distrobox --format "{{.Names}}"
}

get_running_containers (){
    podman ps --filter label=manager=distrobox --format "{{.Names}}"
}

# Distrobox remove
remove_container (){
	echo "Warning!!! This will automatically stop and remove the selected container."
	local SELECT_CONTAINER
    SELECT_CONTAINER=$(get_containers | fzf)
	echo "${SELECT_CONTAINER} is being removed."
	echo -e "y" | distrobox-stop "${SELECT_CONTAINER}"
	echo -e "y" | distrobox-rm "${SELECT_CONTAINER}"
}

stop_container (){
	local SELECT_CONTAINER
    SELECT_CONTAINER=$(get_running_containers | fzf)
	echo "${SELECT_CONTAINER} is being stoped."
	echo -e "y" | distrobox-stop "${SELECT_CONTAINER}"
}

create_container (){
    echo "Select Container Variant"

    local CONTAINER_VARIANT=(
        "ghcr.io/carrionanimus/cachyos-toolbox:latest"
        "quay.io/toolbx-images/debian-toolbox:unstable"
    )

    local SELECT_CONTAINER_VARIANT
    SELECT_CONTAINER_VARIANT=$(printf "%s\n" "${CONTAINER_VARIANT[@]}" | fzf)

    if [ "$SELECT_CONTAINER_VARIANT" = "ghcr.io/carrionanimus/cachyos-toolbox:latest" ]; then
        local CONTAINER_PACKAGE_CACHE="$HOME/Documents/Distrobox/Cache/Arch:/var/cache/pacman/pkg"
    elif [ "$SELECT_CONTAINER_VARIANT" = "quay.io/toolbx-images/debian-toolbox:unstable" ]; then
        local CONTAINER_PACKAGE_CACHE="$HOME/Documents/Distrobox/Cache/Debian:/var/cache/apt/archives"
    fi

    mkdir -p "$HOME/Documents/Distrobox/Cache/Arch"
    mkdir -p "$HOME/Documents/Distrobox/Cache/Debian"

    local CONTAINER_NAME
    read -rp "Enter Container Name: " CONTAINER_NAME

    distrobox-create --name "$CONTAINER_NAME" \
        --home "$HOME/Documents/Distrobox/$CONTAINER_NAME" --image "$SELECT_CONTAINER_VARIANT" \
        --volume "$CONTAINER_PACKAGE_CACHE" \
        --volume /usr/share/vulkan/icd.d/nvidia_icd.x86_64.json:/usr/share/vulkan/icd.d/nvidia_icd.x86_64.json:ro \
        --nvidia
}

# List and enter selected container
enter_container (){
    local SELECT_CONTAINER
    SELECT_CONTAINER=$(get_containers | fzf)
    distrobox-enter "${SELECT_CONTAINER}"
}

# Check if no arguments were passed
if [[ $# -eq 0 ]]; then
    enter_container
    exit 0
fi

# Arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        q) stop_container;;
        rm) remove_container;;
        c) create_container;;
        *) echo "Unknown parameter: $1";;
    esac
    shift
done
