#!/bin/bash
borg create --info /storage/borg::Home-"$(date +%c)" /home/matteo 2>> /home/matteo/scripts/borg/logs >> /home/matteo/scripts/borg/logs