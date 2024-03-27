#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER"/"$MENU_BACKEND"_standard.sh
menu_theme_setup 'fileexplorer'

#max history size
max_size=50

get_history(){
	cat "$SCRIPTS_LOCAL_FOLDER/fileexplorer.history" |uniq | tail -n5 
}
get_history_size(){
	 wc -l "$SCRIPTS_LOCAL_FOLDER/fileexplorer.history"  | cut -d" " -f1
}

print_contents() {
	 ls "$1" | menu_cmd "${prompt}"

}
print_contents_and_history() {
	{ get_history; ls "$1";  } | menu_cmd "${prompt}"

}

#main
curpath="$HOME"
chosen="$(print_contents_and_history "$HOME")"
#cicle inside directory
while [[ -d "$curpath/$chosen" && "$chosen" != '' ]]; do
	curpath="$curpath/$chosen"
	chosen="$(print_contents "$curpath")"
done
#open file
if [[ -f "$curpath/$chosen" || -f "$chosen" ]]; then
	if [[ "$(get_history_size)" -gt $max_size ]];then 
		rm "$SCRIPTS_LOCAL_FOLDER/fileexplorer.history"
	fi
	case $chosen in
	/*)
		xdg-open "$chosen"
		;;
	*) 
		echo "$curpath/$chosen" >> "$SCRIPTS_LOCAL_FOLDER/fileexplorer.history"
		xdg-open "$curpath/$chosen"
		 ;;
	esac
fi
