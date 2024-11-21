#!/usr/bin/env sh


alias reload='systemctl --user daemon-reload'
alias get-icons='wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh'
alias wall-set='~/.config/hypr/scripts/wall-set.sh'