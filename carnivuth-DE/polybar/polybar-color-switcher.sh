#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/get_wal_color.sh"
get_wal_color
echo -e " 
[color]
    background=     ${COLORS[13]}
    foreground=     ${COLORS[0]}
    icon=          ${COLORS[2]}
" > "$HOME/.config/polybar/colors/wal-colors.ini"