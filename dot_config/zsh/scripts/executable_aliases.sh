#!/usr/bin/env sh

# misc/general
alias fastfetch='fastfetch -c /usr/share/chopper-os/custom/fastfetch.jsonc'

alias mkdir='mkdir -p'

alias grep='ug'
alias egrep='ug -E'
alias fgrep='ug -F'
alias xzgrep='ug -z'
alias xzegrep='ug -zE'
alias xzfgrep='ug -zF'

# systemctl
alias reload='systemctl --user daemon-reload'
alias rwire='systemctl --user restart pipewire pipewire-pulse wireplumber'

# gnome
alias setup-gnome='~/.config/zsh/scripts/gnome.sh'

# Boxy
alias boxy='~/.config/zsh/scripts/distrobox.sh'
alias boxy-stop='~/.config/zsh/scripts/distrobox.sh q'
alias boxy-create='~/.config/zsh/scripts/distrobox.sh c'
alias boxy-rm='~/.config/zsh/scripts/distrobox.sh rm'
alias boxy-clear-cache='~/.config/zsh/scripts/distrobox.sh rmc'

# Yazi exit on selected directory https://yazi-rs.github.io/docs/quick-start/#shell-wrapper
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
