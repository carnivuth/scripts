#!/bin/bash
#function for rofi theme and setup parameters
# $1 absolute path to theme directory
# $2 default value
rofi_theme_setup() {
    dir="$1"
    theme="$DEFAULT_THEME"
    if [[ "$#" -gt 1 && "$2" != '' ]]; then
        theme="$2"
    fi
}
# $1 rofi prompt
rofi_cmd() {
    if [ -f "${dir}/${theme}.rasi" ]; then
        rofi -dmenu \
            -p "$1" \
            -theme ${dir}/${theme}.rasi
    else
        rofi -dmenu \
            -p "$1"

    fi
}
