#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='borg upower jq rclone'
sudo pacman -S $packets

# installing systemd services
cp -rf "$SCRIPTS_HOME_FOLDER/systemd/services/"*.service "$HOME/.config/systemd/user/"

# setting basolute paths
sed -i "s|\[\[HOME\]\]|${HOME}|g" "$HOME/.config/systemd/user/"*.service

# reload daemons
systemctl --user daemon-reload

# enable all services
for servicefile in "$SCRIPTS_HOME_FOLDER/systemd/services/"*.service; do
  service=$(echo $servicefile | rev | cut -d'/' -f 1 | rev)
  echo $service
  systemctl --user enable --now $service
done
