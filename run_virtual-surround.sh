#!/usr/bin/env sh

sed -i "s=USERNAME=$USER=g" "$HOME"/.config/pipewire/pipewire.conf.d/virtual-surround-7_1.conf

systemctl --user restart pipewire wireplumber pipewire-pulse
