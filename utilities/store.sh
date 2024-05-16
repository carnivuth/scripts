#!/bin/bash
install_packages(){
  pacman -Slq | fzf --multi --preview 'pacman -Si {1}' | xargs -ro sudo pacman -S
}
remove_packages(){
  pacman -Qq | fzf --multi --preview 'pacman -Qi {1}' | xargs -ro sudo pacman -Rns
}
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
