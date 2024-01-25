#!/bin/bash
source "$HOME/scripts/settings.sh"

menu_theme_setup(){
    STYLE="$WOFI_CONFIG_FOLDER/$1/$1.css"
    CONFIG="$WOFI_CONFIG_FOLDER/$1/$1"
}

# $1 wofi prompt
menu_cmd() {
        wofi  -dmenu \
            -p "$1" \
            -s "$STYLE"\
            -c "$CONFIG"
}