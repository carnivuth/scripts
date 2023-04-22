#!/usr/bin/bash

dir="$HOME/.config/rofi/launcher/"
theme='snorlax-line'

if [ -f "${dir}/${theme}.rasi"  ]; then

## Run
    rofi \
        -show drun \
        -theme ${dir}/${theme}.rasi 

else
## Run without theme
    rofi \
        -show drun \

fi
