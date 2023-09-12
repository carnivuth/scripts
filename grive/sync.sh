#!/bin/bash
source $HOME/scripts/settings.sh
# grive home folder set as needed
FOLDER="$HOME/google-drive"
grive -p "$FOLDER" 2>> "$SCRIPTS_LOGS_FOLDER/sync.logs" >> "$SCRIPTS_LOGS_FOLDER/sync.logs"