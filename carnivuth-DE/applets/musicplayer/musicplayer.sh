#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/array_importer.sh"
source "$SCRIPTS_LIBS_FOLDER/menu_standard.sh"

menu_theme_setup musicplayer

#import values from array
array_importer "$SCRIPTS_APPLETS_FOLDER/musicplayer/folders.sh" "$HOME"


print_playlists() {
    echo -e "$(for dir in ${ARRAY[@]}; do ls -d "$dir"/*/; done)"  | menu_cmd "${prompt}"

}

#main
chosen="$(print_playlists)"

#kill vlc command
if [[ "$chosen" == "stop" ]];then
player="$(cat $SCRIPTS_RUN_FOLDER/pid.player)"
    if [ "$player" != '' ]; then
        kill $player
        rm $SCRIPTS_RUN_FOLDER/pid.player
    fi

fi

#run playlist
if [[ -d "$folder/$chosen" &&  "$chosen" != '' ]]; then
    player="$(cat $SCRIPTS_RUN_FOLDER/pid.player)"
    if [ "$player" != '' ]; then
        kill $player
        sleep 1
    fi
    mpv --no-video "$folder/$chosen" 2>> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log >> $SCRIPTS_LOGS_FOLDER/musicplayer.player.log &
    echo $! > $SCRIPTS_RUN_FOLDER/pid.player
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"

fi
