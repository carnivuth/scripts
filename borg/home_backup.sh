#!/bin/bash
borg create --info /storage/borg::Home-"$(date +%c)" /home/matteo 2>> $HOME/scripts/borg/logs >> $HOME/scripts/borg/logs