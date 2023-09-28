#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"
host="$(cat /etc/hostname)"
rofi_theme_setup "$ROFI_CONFIG_FOLDER/launcher" "$1" "run applications"

if [ -f "${dir}/${theme}.rasi" ]; then

     rofi -show drun \
            -p "$1" \
            -config ${dir}/${theme}.rasi
    else
        rofi -show drun \
            -p "$1" \
            -config $DEFAULT_THEME_PATH

fi
