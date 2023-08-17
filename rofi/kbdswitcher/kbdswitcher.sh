#!/bin/bash
# set rofi theme
dir="$HOME/.config/rofi/kbdswitcher"
theme='snorlax-center'

#prompt
prompt='keyboard switcher'

#project folders
if [ -f "$HOME/scripts/rofi/kbdswitcher/layouts.sh" ]; then
    source "$HOME/scripts/rofi/kbdswitcher/layouts.sh"
else
    LAYOUTS=("us")
fi

if [ "$#" -gt 0 ]; then
    theme="$1"
fi
rofi_cmd() {
    if [ -f "${dir}/${theme}.rasi" ]; then
        rofi -dmenu \
            -p "$1" \
            -theme ${dir}/${theme}.rasi
    else
        rofi -dmenu \
            -p "$1"

    fi
}

print_layouts() {
    echo -e "$(for l in ${LAYOUTS[@]}; do echo $l; done)" | rofi_cmd $prompt

}

#main
chosen="$(print_layouts)"

#main
if [[ "$chosen" != '' ]]; then
    setxkbmap "$chosen" && notify-send -a "Keyboard switcher" -u "normal" "layout changed" "changed layout to $chosen"

fi
