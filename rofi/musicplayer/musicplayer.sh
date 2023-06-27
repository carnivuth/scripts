#!/bin/bash
# set rofi theme
dir="$HOME/.config/rofi/musicplayer"
theme='snorlax-line'

#prompt
prompt='music player'
#music folder
folder="$HOME/Musica"
if [ "$#" -gt 1 ]; then
    theme="$1":
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

print_playlists() {
    ls "$folder" | rofi_cmd "${prompt}"

}

#main
chosen="$(print_playlists)"

#run playlist
if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    vlc="$(cat $HOME/scripts/rofi/musicplayer/log)"
    if [ "$vlc" != '' ]; then
        kill $vlc
        sleep 1
    fi
    vlc --qt-start-minimized "$folder/$chosen" &
    echo $! > $HOME/scripts/rofi/musicplayer/log
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"

fi
