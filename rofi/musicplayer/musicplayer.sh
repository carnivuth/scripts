#!/bin/bash
 source "$HOME/scripts/settings.sh"

# set rofi theme
dir="$HOME/.config/rofi/musicplayer"
theme='snorlax-line'

#prompt
prompt='music player'
#music folder
folder="$HOME/Musica"
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

print_playlists() {
    ls "$folder" | rofi_cmd "${prompt}"

}

#main
chosen="$(print_playlists)"

#kill vlc command
if [[ "$chosen" == "stop" ]];then
vlc="$(cat $SCRIPTS_RUN_FOLDER/pid.vlc)"
    if [ "$vlc" != '' ]; then
        kill $vlc
        rm $SCRIPTS_RUN_FOLDER/pid.vlc
    fi
    glava="$(cat $SCRIPTS_RUN_FOLDER/pid.glava)"
    if [ "$glava" != '' ]; then
        kill $glava
        rm $SCRIPTS_RUN_FOLDER/pid.glava
    fi

fi

#run playlist
if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    vlc="$(cat $SCRIPTS_RUN_FOLDER/pid.vlc)"
    if [ "$vlc" != '' ]; then
        kill $vlc
        sleep 1
    fi
    glava="$(cat $SCRIPTS_RUN_FOLDER/pid.glava)"
    if [ "$glava" != '' ]; then
        kill $glava
        sleep 1
    fi
    vlc --qt-start-minimized "$folder/$chosen" 2 >> $SCRIPTS_LOGS_FOLDER/musicplayer.vlc.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.vlc.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.vlc
    glava --desktop 2 >> $SCRIPTS_LOGS_FOLDER/musicplayer.glava.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.glava.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.glava
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"

fi
