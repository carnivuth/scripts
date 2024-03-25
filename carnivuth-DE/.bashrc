#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# PATH editing
export PATH="~/scripts/utilities/:$PATH"
export PATH="~/scripts/carnivuth-DE/applets:$PATH"
export PATH="~/.local/bin:$PATH"

# set PS1 variable
BLUE6="\[$(tput setaf 6)\]"
BLUE21="\[$(tput setaf 21)\]"
RESET="\[$(tput sgr0)\]"
PS1="{${BLUE6}\u@\h${RESET}:${BLUE21}\w${RESET}}"

#include bas_aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

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
