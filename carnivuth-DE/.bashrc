#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH editing
export PATH="$HOME/scripts/utilities/:$PATH"
export PATH="$HOME/scripts/carnivuth-DE/applets:$PATH"
export PATH="$HOME/scripts/systemd/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/toolbox/bin:$PATH"


#include bas_aliases
if [ -f "$HOME/.bash_aliases" ]; then
  source "$HOME/.bash_aliases"
fi

# include scripts settings
if [ -f "$HOME/scripts/settings.sh" ]; then
  source "$HOME/scripts/settings.sh"
fi

# set editor and visual variables
export EDITOR='vim'
export VIUSUAL='vim'

# set terminal color if using alacritty
if [[ "$TERM" == alacritty ]] && [[ -f "$HOME/.cache/wal/sequences" ]];then
  cat "$HOME/.cache/wal/sequences"
fi


# enable powerline if installed
if [[ -f "/usr/share/powerline/bindings/bash/powerline.sh" ]]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source  "/usr/share/powerline/bindings/bash/powerline.sh"
else
  # set PS1 variable
  BLUE6="\[$(tput setaf 6)\]"
  BLUE21="\[$(tput setaf 21)\]"
  RESET="\[$(tput sgr0)\]"
  PS1="[${BLUE6}\u@\h${RESET}:${BLUE21}\w${RESET}]"
fi

# setup default fzf options
export FZF_DEFAULT_OPTS='--cycle --bind "tab:toggle-up,btab:toggle-down"'

# import fzf integration
eval  "$(fzf --bash)"
_fzf_setup_completion path mpv


source /home/matteo/toolbox/bash_integration.sh
