
#!/bin/bash
source "$HOME/.config/scripts/settings.sh"

declare -A FLAGS
FLAGS[d]='DEVICE=${OPTARG}'

declare -A FLAGS_DESCRIPTIONS
FLAGS_DESCRIPTIONS[d]='device to format'

FLAGS_STRING='f:s:d:i:T'

declare -A COMMANDS
COMMANDS[format_to_dos]="Format a device to dos"

function format_to_dos {

  if [[ -z $DEVICE ]]; then echo "pass a device with -d option "; exit 1;fi

  read -p "device to format is $DEVICE, is correct? [Y/n]" response

  if [[ $response == Y ]]; then

    echo "creating partition table"
    sudo parted "$DEVICE" mklabel msdos
    echo "creating partition"
    sudo parted -a opt "$DEVICE" "mkpart" "primary" 'fat32' "0%" "100%"
    echo "creating fat32 filesystem"
    sudo mkfs.vfat "${DEVICE}1" -s 128

  fi

}

source "$SCRIPTS_LIB_FOLDER/cli.sh"
