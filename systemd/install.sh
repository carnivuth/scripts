#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='borg newsboat upower jq rclone'
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

  # enable service if is present in config variable
  if [[ "$ENABLED_SERVICES" =~ "$service" ]]; then
    echo "enabling $service"
    systemctl --user enable --now $service
  fi
done
