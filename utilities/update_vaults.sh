#!/bin/bash
# documentation at https://github.com/carnivuth/scripts/blob/main/notes/pages/UPDATE_VAULTS.md
source "$HOME/scripts/settings.sh"
cat $SCRIPTS_HOME_FOLDER/utilities/vaults | while read vault; do
    
    echo "updating $vault"
    $SCRIPTS_HOME_FOLDER/utilities/create_obsidian_vault.sh "$vault" --reset
done
