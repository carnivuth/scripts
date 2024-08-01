#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='fzf sshpass yt-dlp ffmpeg gawk'
sudo pacman -S $packets
