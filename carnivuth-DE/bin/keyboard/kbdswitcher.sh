#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/bin/keyboard/layouts.sh" "it"

current_layout=$(setxkbmap -print -verbose 10 | grep layout | rev | cut -d" " -f1 | rev)
echo $current_layout

for l in ${!ARRAY[@]}; do
    if [[ "${ARRAY[$l]}" == "$current_layout" ]]; then
    #check for the end array
        size=$(( ${#ARRAY[@]}-1 ))
        if [[ "$size" == "$l" ]]; then
            new_layout_index=0

        else
            new_layout_index=$(($l + 1))
        fi
        setxkbmap "${ARRAY[$new_layout_index]}" && notify-send -a "Keyboard switcher" -u "normal" "layout changed" "changed layout to ${ARRAY[$new_layout_index]}"
        exit 0
    fi
done
