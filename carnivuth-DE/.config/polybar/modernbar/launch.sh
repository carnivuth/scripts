#!/bin/bash 
# Add this script to your wm startup file.

DIR="$HOME/.config/polybar/modernbar"

# Terminate already running bar instances
#killall -q polybar
kill -9 $(pgrep -x 'polybar') >/dev/null 2>&1

# Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
xrandr |grep " connected" | cut -d ' ' -f 1 | while read m; do 
    export MONITOR="$m"
    polybar -q main -c /home/matteo/.config/polybar/modernbar/config.ini & 
    #polybar -q connections -c /home/matteo/.config/polybar/carnibar/config.ini & 
    #polybar -q system -c /home/matteo/.config/polybar/carnibar/config.ini & 

done
