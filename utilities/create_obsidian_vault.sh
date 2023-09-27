#!/bin/bash
source "$HOME/scripts/settings.sh"

echo "creating folder $1"
mkdir "$1"

echo "create subfolders "
mkdir "$1/pages"
mkdir "$1/journals"
mkdir "$1/assets"

echo "creating gitignore"
echo '.obsidian/workspace.json'> "$1/.gitignore"

echo "entering $1"
cd "$1"
git init

echo "commiting gitignore"
git add .gitignore
git commit -m 'added gitignore'

echo "copying obsidian files"
cp -r $SCRIPTS_HOME_FOLDER/utilities/obsidian-files ./.obsidian