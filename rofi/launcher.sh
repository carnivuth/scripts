#!/usr/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"
host="$(cat /etc/hostname)"
rofi_theme_setup "$ROFI_CONFIG_FOLDER/launcher" "$1" "run applications"

if [ -f "${dir}/${theme}.rasi" ]; then

    ## Run
    rofi \
        -show drun \
        -theme ${dir}/${theme}.rasi

else
    ## Run without theme
    rofi \
        -show drun

fi
