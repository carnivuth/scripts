#!/usr/bin/bash

dir="$HOME/.config/rofi/networkmanager/"
theme='snorlax-line'

if [ -f "${dir}/${theme}.rasi"  ]; then

## Run
    rofi \
        -dmenu  \
        -theme ${dir}/${theme}.rasi 

else
## Run without theme
    rofi \
        -show -dmenu \

fi
