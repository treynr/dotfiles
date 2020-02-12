## file: .zshrc
## desc: Zsh config.

## Color the prompt
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## Enable directory colors
if [[ -e "$HOME/.dir_colors" ]]; then
    eval "$(dircolors -b ~/.dir_colors)"
fi

## Environment variables
export ZSH=$HOME/.oh-my-zsh
export PATH="$PATH:$HOME/.local/bin"

## Aliases
alias ls='ls --file-type --color=auto'
alias lsa='ls --file-type --color=auto -a'

## Dotfile management
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

## Activate pyenv if necessary
if [[ -x "$(command -v pyenv)" ]]; then

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

## Custom Zsh theme named custom...
ZSH_THEME="custom"

## Idk some zsh shit I guess...
autoload -Uz compinit
compinit

## Shell history, save the last 10K commands
HISTFILE=$HOME/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

bindkey -v

## Cmd line alias autocompletion
setopt complete_aliases

## Prevent duplicates in history
setopt hist_ignore_dups

# Zsh plugins
plugins=(git)

source $ZSH/oh-my-zsh.sh

