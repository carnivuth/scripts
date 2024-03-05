#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup vaultlauncher 

print_vaults() {
    echo -e "$(for vault in $vaultlauncher_folders; do echo "$vault"; done)" | menu_cmd "${prompt}"

}

#main
chosen="$(print_vaults)"

#open vault
if [[ "$chosen" != "" ]]; then
    xdg-open "obsidian://open?path=$chosen" &
fi
