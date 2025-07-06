#!/usr/bin/env sh

alias reload='systemctl --user daemon-reload'
alias rwire='systemctl --user restart pipewire pipewire-pulse wireplumber'
alias setup-gnome='~/.config/zsh/scripts/gnome.sh'

alias boxy='~/.config/zsh/scripts/distrobox.sh'
alias boxy-stop='~/.config/zsh/scripts/distrobox.sh q'
alias boxy-rm='~/.config/zsh/scripts/distrobox.sh rm'
