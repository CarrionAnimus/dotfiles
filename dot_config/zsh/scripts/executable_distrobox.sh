#!/usr/bin/env bash

set -oue pipefail

get_containers (){
    podman ps -a --filter label=manager=distrobox --format "{{.Names}}"
}

# Distrobox remove
remove_container (){
	echo "Warning!!! This will automatically stop and remove the selected container."
	local SELECT_CONTAINER=$(get_containers | fzf)
	echo "${SELECT_CONTAINER} is being removed."
	echo -e "y" | distrobox-stop "${SELECT_CONTAINER}"
	echo -e "y" | distrobox-rm "${SELECT_CONTAINER}"
}

stop_container (){
	local SELECT_CONTAINER=$(get_containers | fzf)
	echo "${SELECT_CONTAINER} is being stoped."
	echo -e "y" | distrobox-stop "${SELECT_CONTAINER}"
}

# List and enter selected container
enter_container (){
    local SELECT_CONTAINER=$(get_containers | fzf)
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
        *) echo "Unknown parameter: $1";;
    esac
    shift
done
