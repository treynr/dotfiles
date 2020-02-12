## file: .bashrc
## desc: Bash config.

## Color the prompt
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

## Enable directory colors
if [[ -e "$HOME/.dir_colors" ]]; then
    eval "$(dircolors -b ~/.dir_colors)"
fi

## Bash history lengths
HISTSIZE=10000
HISTFILESIZE=1000000

## Enable autocompletion for sudo and man commands
complete -cf sudo
complete -cf man

## Environment variables
export EDITOR=vim
export PATH="$PATH:$HOME/.local/bin"

## General aliases
alias ls='ls --file-type --color=auto'
alias lsa='ls --file-type --color=auto -a'
alias ..='cd ..'

## Dotfile management
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

## Activate pyenv if necessary
if [[ -x "$(command -v pyenv)" ]]; then

    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

## Bash prompt shit
## Colors
GREEN='\[\e[0;32m\]'
YELL='\[\e[0;33m\]'
BLUE='\[\e[0;34m\]'
PINK='\[\e[0;35m\]'
LBLUE='\[\e[0;36m\]'
WHITE='\[\e[0;37m\]'
AGREEN='\[\e[1;32m\]'
AYELL='\[\e[1;33m\]'
APINK='\[\e[1;35m\]'
NOCOL='\[\e[0m\]'
NORMAL='\[\e[m\]'

## Returns true if the current directory we're sitting in is a git repo. Uses
## command to ensure the git binary is installed. Any encountered errors are
## ignored.
#
function is_git_repo() {
    echo $(command git rev-parse --is-inside-work-tree 2> /dev/null)
}

## Returns the name of the git branch we're on (provided we're currently 
## inside a repo).
#
function get_branch() {

    local branch

    branch=$(command git symbolic-ref --quiet HEAD 2> /dev/null)

    local ret=$?

    if [[ $ret != 0 ]]; then

        ## No git branch/repo
        [[ $ret != 128 ]] && return

        ## Handle symbolics
        branch=$(command git symbolic-ref --short HEAD 2> /dev/null)
    fi

    ## Substring removal
    echo ${branch#refs/heads/}
}

## Returns 'true" if there are untracked files in the current git directory.
#
function has_untracked_files() {

    local untracked=$(command git ls-files --exclude-standard --others)

    if [[ -n $untracked ]]; then

        echo ""
    else
        echo "yes"
    fi
}

## Returns 'true" if the current git branch is dirty.
#
function is_branch_dirty() {

    local flags="--porcelain -uno"
    local dirty=$(command git status $flags 2> /dev/null)

    if [[ -n $dirty ]]; then
        echo "1"
    fi
}

## Returns text for the currenty git repo.
#
function git_prompt() {

    local prompt
    local branch=$(get_branch)

    if [[ -n $branch ]]; then

        if [[ -n $(is_branch_dirty) ]]; then

            echo -e "$YELL<$branch>"
        else
            echo -e "$GREEN<$branch>"
        fi
    fi
}

function prompt() {
    PS1="\n $WHITE[${YELL}\h$WHITE | $LBLUE\${PWD}$WHITE] $(git_prompt) \n $AGREEN$ $HWHITE$NOCOL"
}

## Bash prompt
PROMPT_COMMAND=prompt
