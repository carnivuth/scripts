#!/bin/bash
# set rofi theme
source $HOME/scripts/settings.sh
source $SCRIPTS_LIBS_FOLDER/array_importer.sh
source "$SCRIPTS_LIBS_FOLDER/rofi_standard.sh"

array_importer "$SCRIPTS_HOME_FOLDER/rofi/kbdswitcher/layouts.sh" 'us'

rofi_theme_setup "$ROFI_CONFIG_FOLDER/fileexplorer" "$1" 


#prompt
prompt='keyboard switcher'

#import values from array

print_layouts() {
    echo -e "$(for l in ${ARRAY[@]}; do echo $l; done)" | rofi_cmd $prompt

}

#main
chosen="$(print_layouts)"
if [[ "$chosen" != '' ]]; then
    setxkbmap "$chosen" && notify-send -a "Keyboard switcher" -u "normal" "layout changed" "changed layout to $chosen"

fi
