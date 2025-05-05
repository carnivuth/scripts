#!/bin/bash
source "$HOME/.config/scripts/settings.sh"
source "$SCRIPTS_LIB_FOLDER/notify.sh"

declare -A FLAGS
FLAGS_STRING=''

declare -A COMMANDS
COMMANDS[checkupdates]="checks if updates are available"
COMMANDS[start]="starts update daemon"
COMMANDS[update]="updates the system"

APP_NAME="System manager"
APP_ICON="/usr/share/icons/Papirus/16x16/apps/system-software-update.svg"

function checkupdates(){
  if ! type -P fakeroot >/dev/null; then
  	echo 'Cannot find the fakeroot binary.'
  	exit 1
  fi

  if [[ -z $CHECKUPDATES_DB ]]; then
  	CHECKUPDATES_DB="${TMPDIR:-/tmp}/checkup-db-${USER}/"
  fi

  trap 'rm -f $CHECKUPDATES_DB/db.lck' INT TERM EXIT

  DBPath="$(pacman-conf DBPath)"
  if [[ -z "$DBPath" ]] || [[ ! -d "$DBPath" ]]; then
  	DBPath="/var/lib/pacman/"
  fi

  mkdir -p "$CHECKUPDATES_DB"
  ln -s "${DBPath}/local" "$CHECKUPDATES_DB" &> /dev/null
  if ! fakeroot -- pacman -Sy --dbpath "$CHECKUPDATES_DB" --logfile /dev/null &> /dev/null; then
         echo 'Cannot fetch updates'
         exit 1
  fi
  pacman -Qu --dbpath "$CHECKUPDATES_DB" 2> /dev/null | grep -v '\[.*\]'
}

function update(){
  status=0
  # update system
  sudo pacman -Syu --noconfirm
  status=$?

  # remove orphans
  pkgs=$(sudo pacman -Qdtq)
  if [[ "$pkgs" != "" ]];then
    sudo pacman -Rns $pkgs --noconfirm
    status=$?
  fi

  # clean cache
  sudo pacman -Sc --noconfirm
  status=$?

  if [[ "$XDG_SESSION_TYPE" != "tty" ]] && [[ "$status" == "0" ]]; then
    notify normal "system is up to date"
  fi
}

function start(){
while true; do
  UPDATES=$(checkupdates 2>/dev/null | wc -l);

    # notify user of updates
    if (( UPDATES > 50 )); then
      notify critical "You really need to update!! $UPDATES New packages"
    elif (( UPDATES > 25 )); then
      notify normal "You should update soon $UPDATES New packages"
    elif (( UPDATES > 2 )); then
      notify normal "$UPDATES New packages"
    fi

    # when there are updates available
    # every 10 seconds another check for updates is done
    while (( UPDATES > 0 )); do
      if (( UPDATES == 1 )); then
        echo "$UPDATES"
      elif (( UPDATES > 1 )); then
        echo "$UPDATES"
      else
        echo "None"
      fi
      sleep 10
      UPDATES=$(checkupdates 2>/dev/null | wc -l);
    done

    # when no updates are available, use a longer loop, this saves on CPU
    # and network uptime, only checking once every 30 min for new updates
    while (( UPDATES == 0 )); do
      echo "None"
      sleep 1800
      UPDATES=$(checkupdates 2>/dev/null | wc -l);
    done
  done
}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
