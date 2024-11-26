#!/usr/bin/env sh


alias reload='systemctl --user daemon-reload'
alias get-icons='wget -qO- https://git.io/papirus-icon-theme-install | env DESTDIR="$HOME/.local/share/icons" sh'
alias wall-set='~/.config/hypr/scripts/wall-set.sh'

alias boxy='~/.config/zsh/scripts/distrobox.sh'
alias boxy-stop='~/.config/zsh/scripts/distrobox.sh q'
alias boxy-rm='~/.config/zsh/scripts/distrobox.sh rm'
