#!/usr/bin/env sh

# systemctl
alias reload='systemctl --user daemon-reload'
alias rwire='systemctl --user restart pipewire pipewire-pulse wireplumber'

# gnome
alias setup-gnome='~/.config/zsh/scripts/gnome.sh'

# Boxy
alias boxy='~/.config/zsh/scripts/distrobox.sh'
alias boxy-stop='~/.config/zsh/scripts/distrobox.sh q'
alias boxy-rm='~/.config/zsh/scripts/distrobox.sh rm'

# Yazi exit on selected directory https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
