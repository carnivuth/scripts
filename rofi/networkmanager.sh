#!/usr/bin/bash

dir="$HOME/.config/rofi/networkmanager/"
theme='snorlax-line'

if [ -f "${dir}/${theme}.rasi"  ]; then

## Run
    rofi \
        -no-lazy-grub \
        -dmenu  \
        -theme ${dir}/${theme}.rasi 

else
## Run without theme
    rofi \
        -no-lazy-grub \
        -show -dmenu \

fi
