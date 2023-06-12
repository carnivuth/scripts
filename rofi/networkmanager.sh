#!/usr/bin/bash

dir="$HOME/.config/rofi/networkmanager/"
theme='snorlax-line'

if [ "$#" -eq 1 ]; then
    theme="$1"
fi

if [ -f "${dir}/${theme}.rasi" ]; then

    ## Run
    rofi \
        -no-lazy-grub \
        -dmenu \
        -p 'networks' \
        -theme ${dir}/${theme}.rasi

else
    ## Run without theme
    rofi \
        -no-lazy-grub \
        -show -dmenu \
        -p 'networks'

fi
