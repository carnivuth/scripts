#!/bin/bash
# documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/CREATE_OBSIDIAN_VAULT.md
source "$HOME/scripts/settings.sh"

if [[ "$1" == '--help' ]]; then
    echo 'usage create_obsidian_folder.sh <vault path> [--git] [--reset]'
    exit 0
fi

vault="$1"
shift
#get parameters
while test $# -gt 0; do
    case "$1" in
    --git)
        git=1
        ;;
    --reset)
        reset=1
        ;;
    esac

    shift
done

if [[ ! -d "$vault" ]]; then
    echo "creating folder $vault"
    mkdir -p "$vault"
fi
!
if [[ ! -d "$vault/journals" ]]; then
    echo "create subfolders journals"
    mkdir "$vault/journals"
fi
if [[ ! -d "$vault/assets" ]]; then
    echo "create subfolders assets"
    mkdir "$vault/assets"
fi
if [[ ! -d "$vault/pages" ]]; then
    echo "create subfolders pages"
    mkdir "$vault/pages"
fi

if [[ ! -d "$vault/.obsidian" || "$reset" == '1' ]]; then
    echo "copying obsidian files"
    mkdir -p "$vault/.obsidian"
    cp -r $SCRIPTS_HOME_FOLDER/utilities/obsidian-files/* "$vault/.obsidian"
fi

# create git repo if --git is set
if [[ "$git" == '1' ]]; then

    if [[ ! -d "$vault/.git" ]]; then
        echo "entering $vault"
        cd "$vault"
        git init
    fi
    if [[ ! -f "$vault/.gitignore" ]]; then
        echo "creating gitignore"
        echo '.obsidian' >"$vault/.gitignore"
        echo '!.obsidian/app.json' >>"$vault/.gitignore"
        echo '!.obsidian/appereance.json' >>"$vault/.gitignore"
        echo '!.obsidian/config' >>"$vault/.gitignore"
        echo '!.obsidian/community-plugins.json' >>"$vault/.gitignore"
        echo '!.obsidian/core-plugins.json' >>"$vault/.gitignore"
        echo '!.obsidian/hotkeys.json' >>"$vault/.gitignore"
        echo '!.obsidian/graphs.json' >>"$vault/.gitignore"

    fi
fi
