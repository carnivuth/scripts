#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH editing
export PATH="~/scripts/utilities/:$PATH"
export PATH="~/scripts/carnivuth-DE/applets:$PATH"
export PATH="~/.local/bin:$PATH"


#include bas_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# source scripts settings
source ~/scripts/settings.sh
# set editor and visual variables
export EDITOR='vim'
export VIUSUAL='vim'

# set terminal color if using alacritty
if [[ "$TERM" == alacritty ]];then
    cat $HOME/.cache/wal/sequences
fi

if [[ -f "$HOME/todo.md" ]]; then
    glow "$HOME/todo.md"
fi

# enable undistract-me if installed
if [[ -f "/etc/profile.d/undistract-me.sh" ]]; then
    source /etc/profile.d/undistract-me.sh
fi
# enable powerline if installed
if [[ -f "/usr/share/powerline/bindings/bash/powerline.sh" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
    . /usr/share/powerline/bindings/bash/powerline.sh
else
    # set PS1 variable
    BLUE6="\[$(tput setaf 6)\]"
    BLUE21="\[$(tput setaf 21)\]"
    RESET="\[$(tput sgr0)\]"
    PS1="[${BLUE6}\u@\h${RESET}:${BLUE21}\w${RESET}]"
fi

# import fzf integration
eval  "$(fzf --bash)"
_fzf_setup_completion path mpv

# setup default fzf options
export FZF_DEFAULT_OPTS='--cycle --bind "tab:toggle-up,btab:toggle-down"'
source /home/matteo/toolbox/bash_integration.sh
export PATH=$PATH:/home/matteo/toolbox/bin
