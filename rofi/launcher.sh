#!/usr/bin/bash

dir="$HOME/.config/rofi/launcher/"
theme='snorlax-line'
if [ "$#" -eq 1 ]; then
    theme="$1"
fi
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
