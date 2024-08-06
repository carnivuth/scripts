

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
