#!/bin/bash
#function for rofi theme and setup parameters
# $1 absolute path to theme directory
# $2 theme filename without extension
# $3 rofi prompt
source "$HOME/scripts/settings.sh"
menu_theme_setup() {
    theme="$ROFI_CONFIG_FOLDER/$1.rasi"
}
# $1 rofi prompt
menu_cmd() {
        rofi  -dmenu \
            -p "$1" \
            -config ${theme}
}

app_cmd() {
        rofi  -drun \
            -p "$1" \
            -config ${theme}
}
