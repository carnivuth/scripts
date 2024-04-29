#!/bin/bash
source "$HOME/scripts/settings.sh"

# install packages
echo 'installing packages'
packets='borg newsboat upower jq rclone'
sudo pacman -S $packets

# creating systemd folder
if [[ ! -d "$HOME/.config/systemd/user/" ]]; then
    mkdir -p "$HOME/.config/systemd/user/"
fi
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

# installing systemd timers
cp -rf "$SCRIPTS_HOME_FOLDER/systemd/timers/"*.service "$HOME/.config/systemd/user/"
cp -rf "$SCRIPTS_HOME_FOLDER/systemd/timers/"*.timer "$HOME/.config/systemd/user/"

# setting basolute paths
sed -i "s|\[\[HOME\]\]|${HOME}|g" "$HOME/.config/systemd/user/"*.service

# reload daemons
systemctl --user daemon-reload

# enable all services
for timerfile in "$SCRIPTS_HOME_FOLDER/systemd/timers/"*.timer; do
  timer=$(echo $timerfile | rev | cut -d'/' -f 1 | rev)

  # enable timer if is present in config variable
  if [[ "$ENABLED_TIMERS" =~ "$timer" ]]; then
    echo "enabling $timer"
    systemctl --user enable --now $timer
  fi
done
 echo "if you enable the backup service remember to run $HOME/scripts/systemd/bin/backup.sh init to initialize the borg repo"
