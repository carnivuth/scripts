#!/bin/bash
current_layout=$(setxkbmap -print -verbose 10 | grep layout | rev | cut -d" " -f1 | rev)
echo $current_layout
if [ -f "$HOME/scripts/system/keyboard/layouts.sh" ]; then
    source "$HOME/scripts/system/keyboard/layouts.sh"
else
    LAYOUTS=("it")
fi

for l in ${!LAYOUTS[@]}; do
    if [[ "${LAYOUTS[$l]}" == "$current_layout" ]]; then
    #check for the end array
        size=$(( ${#LAYOUTS[@]}-1 ))
        if [[ "$size" == "$l" ]]; then
            new_layout_index=0

        else
            new_layout_index=$(($l + 1))
        fi
        setxkbmap "${LAYOUTS[$new_layout_index]}" && notify-send -a "Keyboard switcher" -u "normal" "layout changed" "changed layout to ${LAYOUTS[$new_layout_index]}"
        exit 0
    fi
done
