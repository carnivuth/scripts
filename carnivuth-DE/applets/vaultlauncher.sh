#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh

menu_theme_setup vaultlauncher 

print_vaults() {
    echo -e "$(cat $HOME/.config/obsidian/obsidian.json | jq -r '.vaults[].path' )" | menu_cmd "obsidian vault"

}

#main
chosen="$(print_vaults)"

#open vault
if [[ "$chosen" != "" ]]; then
    obsidian "obsidian://open?path=$chosen" &
fi
