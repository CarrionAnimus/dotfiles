#!/usr/bin/env bash

# image downloader
gallery-dl () {
    podman run \
    --interactive \
    --rm \
    --tty \
    --volume ~/.config/containers/storage/Gallery-dl:/etc/gallery-dl:z \
    --volume ~/.config/containers/storage/Gallery-dl/gallery-dl.conf:/etc/gallery-dl.conf:z \
    ghcr.io/mikf/gallery-dl:latest \
    "$@"
}
