#!/bin/env zsh

# -- FZF
FZF_BASE_PATH="$HOME/.local/share/vim/plugged/fzf/shell/"  # Using vim install fzf binary
FZF_KEY_BINDINGS="$FZF_BASE_PATH/key-bindings.zsh"
FZF_COMPLETION="$FZF_BASE_PATH/completion.zsh"

if type "zoxide" > /dev/null; then eval "$(zoxide init zsh --no-cmd)"; fi

# Try to load FZF
[ -s "$FZF_KEY_BINDINGS" ] && source "$FZF_KEY_BINDINGS"

if [ -s "$FZF_COMPLETION" ]; then
    source "$FZF_COMPLETION"

    [ -s "$HOME/.dotfiles/tools/fzf-git/fzf-git.sh" ] &&\
        source "$HOME/.dotfiles/tools/fzf-git/fzf-git.sh"
fi


# Make sure to load this after fzf
if type "atuin" > /dev/null; then eval "$(atuin init zsh --disable-up-arrow)"; fi
