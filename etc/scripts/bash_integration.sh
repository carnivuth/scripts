#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"

# include scripts settings
if [ -f "$HOME/.config/scripts/settings.sh" ]; then source "$HOME/.config/scripts/settings.sh"; fi

# set PS1 variable
BLUE6="\[$(tput setaf 6)\]"
BLUE21="\[$(tput setaf 21)\]"
RESET="\[$(tput sgr0)\]"
PS1="[${BLUE6}\u@\h${RESET}:${BLUE21}\w${RESET}]"

# setup default fzf options
export FZF_DEFAULT_OPTS='--cycle --bind "tab:toggle-up,btab:toggle-down"'

# import fzf integration
eval  "$(fzf --bash)"
_fzf_setup_completion path mpv

# starship integration
eval "$(starship init bash)"

#autodisown aliases
alias d='start_and_disown.sh'

#ls aliases
alias ls='ls --color=auto '
alias ll='ls --color=auto -pl'
alias la='ls --color=auto -pa'
alias lla='ls --color=auto -pla'

# kitten ssh
alias kssh='kitten ssh'

# sudo
alias s='sudo'

# git
alias G='git'

# clear
alias c='clear'

# yay
alias yay='yay --color=auto'

# pacman
alias pacman='pacman --color=auto'
alias update='sudo pacman -Syu --noconfirm && pkgs=$(sudo pacman -Qdtq); if [[ "$pkgs" != "" ]];then sudo pacman -Rns $pkgs --noconfirm; fi && sudo pacman -Sc --noconfirm && if [[ "$XDG_SESSION_TYPE" != "tty" ]]; then notify-send -u normal -a updates "system is up to date" -i /usr/share/icons/Papirus/32x32/apps/system-software-update.svg; fi'
alias autoremove='pkgs=$(sudo pacman -Qdtq); if [[ "$pkgs" != "" ]];then sudo pacman -Rns $pkgs; fi'

# xdg-open
alias open='xdg-open'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# grep
alias docker_remove_all='clean_env.sh docker_clean'
alias vagrant_remove_all='clean_env.sh vagrant_clean'
alias ollama_remove_all='clean_env.sh ollama_clean'

# diff
alias diff='diff --color=auto'

# ip
alias ip='ip --color=auto'

# homelab
alias wake-garchomp='ssh torterra wakeonlan d8:5e:d3:8e:60:d1'
alias wake-torterra='wol b4:2e:99:9c:09:80 '
alias sleep-torterra="ssh 192.168.1.62 -l root 'poweroff'"

# du
alias du='du -h'

# vim
alias v='vim'

# systemctl
alias sctlu='systemctl --user'
alias jctlu='journalctl --user'

# bashly
alias bashly='docker run --rm -it --user $(id -u):$(id -g) --volume "$PWD:/app" dannyben/bashly'
alias t='task'

# toolbox
alias tb='docker run  --pull=always --rm -u $UID:$UID -v "$(pwd)"/:/home/toolbox/"$(basename "$(pwd)")" --name toolbox -it carnivuth/toolbox /home/toolbox/.local/bin/project.sh /home/toolbox/"$(basename "$(pwd)")"'
