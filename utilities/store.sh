#!/bin/bash
install_packages(){
  pacman -Slq | fzf  --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}
remove_packages(){
  pacman -Qq | fzf  --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}
$FZF_DEFAULT_OPTS = '--cycle --bind "ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up,tab:toggle-up,btab:toggle-down"'
case "$1" in
  install)
      install_packages
      ;;
  remove)
      remove_packages
      ;;
  *)
      echo "usage: $0 [install/remove]"
esac
unset FZF_DEFAULT_OPTS
