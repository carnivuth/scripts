#!/bin/bash
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

echo "create subfolders "
if [[ ! -d "$vault/journals" ]]; then
    mkdir "$vault/journals"
fi
if [[ ! -d "$vault/assets" ]]; then
    mkdir "$vault/assets"
fi
if [[ ! -d "$vault/pages" ]]; then
    mkdir "$vault/pages"
fi

if [[ ! -d "$vault/.obsidian" || "$reset" == '1' ]]; then
    echo "copying obsidian files"
    cp -r $SCRIPTS_HOME_FOLDER/utilities/obsidian-files "$vault/.obsidian"
fi

# create git repo if --git is set
if [[ "$git" == '1' ]]; then

    if [[ ! -d "$vault/.git" ]]; then
        echo "entering $vault"
        cd "$vault"
        git init
    fi
    echo "creating gitignore"
    if [[ ! -f "$vault/.gitignore" ]]; then
        echo '.obsidian/workspace.json' >"$vault/.gitignore"
        echo "commiting gitignore"
        cd "$vault"
        git add .gitignore
        git commit -m 'added gitignore'

    fi
fi
