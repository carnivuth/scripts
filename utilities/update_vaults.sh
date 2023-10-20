#!/bin/bash
source "$HOME/scripts/settings.sh"
cat $SCRIPTS_HOME_FOLDER/utilities/vaults | while read vault; do
$SCRIPTS_HOME_FOLDER/utilities/create_obsidian_vault.sh "$vault" --reset
done