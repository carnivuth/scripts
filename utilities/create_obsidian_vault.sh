#!/bin/bash
source "$HOME/scripts/settings.sh"

echo "creating folder $1"
if [[ ! -d "$1" ]]; then
    mkdir "$1"
fi

echo "create subfolders "
if [[ ! -d "$1/journals" ]]; then
    mkdir "$1/journals"
fi
if [[ ! -d "$1/assets" ]]; then
    mkdir "$1/assets"
fi
if [[ ! -d "$1/pages" ]]; then
    mkdir "$1/pages"
fi
if [[ ! -d "$1/.git" ]]; then
    echo "entering $1"
    cd "$1"
    git init
fi
echo "creating gitignore"
if [[ ! -f "$1/.gitignore" ]]; then
    echo '.obsidian/workspace.json' >"$1/.gitignore"
    echo "commiting gitignore"
    cd "$1"
    git add .gitignore
    git commit -m 'added gitignore'

fi

if [[ ! -d "$1/.obsidian" ]]; then
    echo "copying obsidian files"
    cp -r $SCRIPTS_HOME_FOLDER/utilities/obsidian-files ./.obsidian
fi
