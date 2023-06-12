#!/bin/bash
# set rofi theme 
dir="$HOME/.config/rofi/filebrowser/"
theme='snorlax-line'

#prompt
prompt='music player'
#music folder
folder="$HOME/Musica"
if [ "$#" -eq 1 ]; then 
    theme="$1":
fi
rofi_cmd() {
	if [ -f "${dir}/${theme}.rasi"  ]; then
		rofi -dmenu \
        -p "$1" \
			-theme ${dir}/${theme}.rasi
	else
		rofi -dmenu \
        -p "$1"
	
	fi
}

print_playlists(){
	 ls "$folder"| rofi_cmd "${prompt}"

}

#main
chosen="$(print_playlists)"

#run playlist
if [[ -d "$folder/$chosen"  ]];then
    mpv="$(pidof mpv)"
    if [ "$mpv" != '' ]; then 
    kill $mpv
    fi
    mpv "$folder/$chosen" &
    notify-send -a "Music player" -u "normal" "$chosen" "playing $chosen"

fi