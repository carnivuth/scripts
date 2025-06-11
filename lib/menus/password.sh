#!/usr/bin/bash
source "$HOME/.config/scripts/settings.sh"

list_password(){
  for password_store in $PASSWORD_STORES; do
    find "$password_store"  -name '*.gpg' | sed -e "s|.*$(basename "$password_store")/||g" -e 's|.gpg||g' | sed "s/^/password:$(basename "$password_store")>/g"
  done
}

run_password(){
  echo "$1" | awk -F'>' '{print $1, $2}' | (
    read password_store password
    PASSWORD_STORE_DIR="$(find "$HOME" -type d -name "$password_store" )" pass -c "$password"
  )
}
