#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/vaultlauncher "$1" "obsidian vault launcher"

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/vaultlauncher/folders.sh" "$HOME"

print_vaults() {
    echo -e "$(for vault in ${ARRAY[@]}; do echo "$vault"; done)" | rofi_cmd "${prompt}"

}

#main4
chosen="$(print_vaults)"

#open vault
if [[ "$chosen" != "" ]]; then
    xdg-open "obsidian://open?path=$chosen" &
fi