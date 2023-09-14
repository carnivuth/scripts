#!/usr/bin/bash

#OBSLOETE!!!!!!!!!

dir="$HOME/.config/rofi/filebrowser/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then
    theme="$1"
fi
if [ -f "${dir}/${theme}.rasi" ]; then

    ## Run
    rofi -show file-browser-extended \
        -file-browser-dir "$HOME" \
        -theme ${dir}/${theme}.rasi \
        -p "Files"

else
    ## Run without theme
    rofi -show file-browser-extended \
        -file-browser-dir "$HOME" \
        -p "Files"
fi
