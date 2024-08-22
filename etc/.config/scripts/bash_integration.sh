#!/bin/bash

export PATH="$HOME/.local/bin:$PATH"
# set editor and visual variables
export EDITOR='vim'
export VIUSUAL='vim'

# include scripts settings
if [ -f "$HOME/.config/scripts/settings.sh" ]; then source "$HOME/.config/scripts/settings.sh"; fi

# set terminal color if using alacritty
if [[ "$TERM" == alacritty ]] && [[ -f "$HOME/.cache/wal/sequences" ]];then cat "$HOME/.cache/wal/sequences"; fi

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
alias mpv='start_and_disown.sh mpv'
alias firefox='start_and_disown.sh firefox'
alias libreoffice='start_and_disown.sh libreoffice'

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
alias autoremove="sudo pacman -Qtdq | sudo pacman -Rns -"

# xdg-open
alias open='xdg-open'

# grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# diff
alias diff='diff --color=auto'

# ip
alias ip='ip --color=auto'

# homelab
alias wake-playchomp='ssh castleterra wakeonlan d8:5e:d3:8e:60:d1'
alias wake-castleterra='wol b4:2e:99:9c:09:80 '
alias sleep-castleterra="ssh 192.168.1.62 -l root 'poweroff'"

# du
alias du='du -h'

# vim
alias v='vim'
