#!/bin/bash

# print menu filtering elements with jq
chosen="$(hyprctl clients -j | jq -r '.[].title | select(length > 0)'| wofi --show dmenu)"

# focus selected window
hyprctl dispatch focuswindow "title:$chosen"
