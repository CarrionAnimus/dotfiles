#!/usr/bin/env sh

source <(bluebuild completions zsh || true)
eval "$(atuin init zsh || true)"
eval "$(zoxide init zsh || true)"
eval "$(starship init zsh || true)"
source <(fzf --zsh)
