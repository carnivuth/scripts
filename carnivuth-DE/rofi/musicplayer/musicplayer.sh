#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

rofi_theme_setup $ROFI_CONFIG_FOLDER/musicplayer "$1" "music player"

#import values from array
array_importer "$SCRIPTS_HOME_FOLDER/carnivuth-DE/rofi/musicplayer/folders.sh" "$HOME"


print_playlists() {
    echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*/; done)"  | rofi_cmd "${prompt}"

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
    vlc --qt-start-minimized "$folder/$chosen" 2>> $SCRIPTS_LOGS_FOLDER/musicplayer.vlc.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.vlc.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.vlc
    glava --desktop 2 >> $SCRIPTS_LOGS_FOLDER/musicplayer.glava.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.glava.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.glava
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"

fi
