#!/bin/bash

# wofi cmd
run_wofi() {

	wofi --show dmenu --prompt='firefox search' --heigh="5%"
}

# main
chosen="$(run_wofi)"
if [ "$chosen" != "" ]; then
	firefox --new-window --search "$chosen"
fi
