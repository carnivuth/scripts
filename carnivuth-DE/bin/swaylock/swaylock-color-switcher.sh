#!/bin/bash
source "$HOME/scripts/settings.sh"
IMAGE="$1"
sed -i "s|image=.*|image=\"${IMAGE}\"|g" "$HOME/.config/swaylock/config" 
