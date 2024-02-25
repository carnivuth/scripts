#!/bin/bash
source "$HOME/scripts/settings.sh"
source "$SCRIPTS_LIBS_FOLDER/get_wal_color.sh"
get_wal_color
sed -i "s/default_color = '#.*'/default_color = '${COLORS[13]}'/g" "$HOME/.config/conky/conky.conf" 
sed -i "s/default_color = '#.*'/default_color = '${COLORS[0]}'/g" "$HOME/.config/conky/conky.conf" 
sed -i "s/default_color = '#.*'/default_color = '${COLORS[1]}'/g" "$HOME/.config/conky/conky.conf" 
