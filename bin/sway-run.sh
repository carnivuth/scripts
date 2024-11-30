#!/bin/bash
export XDG_SESSION_DESKTOP=sway
export XDG_CURRENT_DESKTOP=sway
export DESKTOP_SESSION=sway

export QT_QPA_PLATFORM=wayland
export SDL_VIDEODRIVER=wayland

exec sway "$@"

