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

    local DISTROBOX_HOME="$HOME/Documents/Distrobox"

    mkdir -p "$DISTROBOX_HOME/Cache/Arch"
    mkdir -p "$DISTROBOX_HOME/Cache/Debian"

    local CONTAINER_VARIANT=(
        "ghcr.io/carrionanimus/cachyos-toolbox:latest"
        "quay.io/toolbx-images/debian-toolbox:unstable"
    )

    declare -A CONTAINER_CACHE
    CONTAINER_CACHE["ghcr.io/carrionanimus/cachyos-toolbox:latest"]="$DISTROBOX_HOME/Cache/Arch:/var/cache/pacman/pkg"
    CONTAINER_CACHE["quay.io/toolbx-images/debian-toolbox:unstable"]="$DISTROBOX_HOME/Cache/Debian:/var/cache/apt/archives"

    local SELECT_CONTAINER_VARIANT
    SELECT_CONTAINER_VARIANT=$(printf "%s\n" "${CONTAINER_VARIANT[@]}" | fzf)

    local CONTAINER_PACKAGE_CACHE="${CONTAINER_CACHE[$SELECT_CONTAINER_VARIANT]}"

    local CONTAINER_NAME
    read -rp "Enter Container Name: " CONTAINER_NAME

    distrobox-create --name "$CONTAINER_NAME" \
        --home "$DISTROBOX_HOME/$CONTAINER_NAME" --image "$SELECT_CONTAINER_VARIANT" --hostname "$CONTAINER_NAME" \
        --volume "$CONTAINER_PACKAGE_CACHE" \
        --volume /usr/share/vulkan/icd.d/nvidia_icd.x86_64.json:/usr/share/vulkan/icd.d/nvidia_icd.json:ro \
        --nvidia \
        --additional-packages helix \
        --unshare-devsys --unshare-groups --unshare-process \
        --init-hooks "install -o 1000 -g 1000 -d /tmp/.X11-unix-$(cat /etc/hostname)-upper;install -o 1000 -g 1000 -d /tmp/.X11-unix-$(cat /etc/hostname)-work;mount -t overlay -o lowerdir=/tmp/.X11-unix,upperdir=/tmp/.X11-unix-$(cat /etc/hostname)-upper,workdir=/tmp/.X11-unix-$(cat /etc/hostname)-work overlay /tmp/.X11-unix"
}

clear_container_cache (){
    local DISTROBOX_HOME="$HOME/Documents/Distrobox"

    local CONTAINER_VARIANT=(
        "Arch"
        "Debian"
    )
    
    declare -A CONTAINER_CACHE
    CONTAINER_CACHE["Arch"]="$DISTROBOX_HOME/Cache/Arch"
    CONTAINER_CACHE["Debian"]="$DISTROBOX_HOME/Cache/Debian"

    echo "WARNING THIS WILL DELETE ALL PACKAGE CACHE!!!" && sleep 3
    local SELECT_CONTAINER_VARIANT
    SELECT_CONTAINER_VARIANT=$(printf "%s\n" "${CONTAINER_VARIANT[@]}" | fzf)

    local CONTAINER_PACKAGE_CACHE="${CONTAINER_CACHE[$SELECT_CONTAINER_VARIANT]}"

    rm -rf "${CONTAINER_PACKAGE_CACHE:?}/"*
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
        q|--quit) stop_container;;
        rm|--remove) remove_container;;
        rmc|--clear-cache) clear_container_cache;;
        c|--create) create_container;;
        *) echo "Unknown parameter: $1"; exit 1;;
    esac
    shift
done
