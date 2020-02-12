#!/usr/bin/env bash

## file: install.sh
## desc: Installs the dotfiles.

## Directory of this install.sh script, which should also contain all of the
## dotfiles
dotfile_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

## Dotfiles to copy
dotfiles=(
    '.bashrc'
    '.dir_colors'
    '.gitignore'
    '.oh-my-zsh'
    '.tmux.conf'
    '.vim'
    '.vimrc'
    '.zshrc'
)

## Installation directory, should always be $HOME
prefix="$HOME"

usage() {

    echo "usage: $0 [options]"
    echo ""

    echo 'Install dotfiles'
    echo ''
    echo '  --no-backup do not backup any previously installed dotfiles'
    echo '  --prefix    set the installation directory'
    echo ''
    echo 'Misc options:'
    echo '  -h, --help  print this help message and exit'
}


## cmd line processing
while :; do
    case $1 in

        --prefix)
            if [ "$2" ]; then
                prefix="$2"
                shift
            else
                echo 'ERROR: --prefix requires an argument'
                exit 1
            fi
            ;;

        --no-backup)
            no_backup=1
            ;;

        -h | -\? | --help)
            usage
            exit
            ;;

        --)
            shift
            break
            ;;

        -?*)
            echo "WARN: unknown option (ignored): $1" >&2
            ;;

        *)
            break
    esac
    shift
done

for df in "${dotfiles[@]}"
do
    ## If the --no-backup option is NOT set and the dotfile already exists
    if [[ -z "$no_backup" && -f "${prefix}/$df" ]]; then
        cp "${prefix}/$df" "${prefix}/${df}.bak"
    fi

    cp -r "${dotfile_dir}/$df" "$prefix"
done

## Store the git repo in the installation directory with the other dotfiles
cp -r "${dotfile_dir}/.git" "${prefix}/.dotfiles" 

gitopts="--git-dir=${prefix}/.dotfiles --work-tree=$prefix"

## Ignore installation script and readme
git $gitopts update-index --assume-unchanged "$prefix/install.sh"
git $gitopts update-index --assume-unchanged "$prefix/readme.rst"

