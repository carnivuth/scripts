#!/bin/bash
# documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/UPDATE_VAULTS.md
source "$HOME/scripts/settings.sh"
echo "$vaultlauncher_folders"| tr -s ' ' '\n' | while read vault; do
    
    echo "updating $vault"
    $SCRIPTS_HOME_FOLDER/utilities/create_obsidian_vault.sh "$vault" --reset
done
