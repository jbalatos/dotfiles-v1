#
# ~/.bashrc
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Terminal prompt
PS1="\[\033[31m\][\W]\[\033[32m\]> \[\033[37m\]"

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
shopt -s autocd
shopt -s cdspell

alias btset='brightnessctl set'

# dotfile git alias
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
# When first cloning / initialising dotfile,  run the following commands :
# config config --local status.showUntrackedFiles no
# config config --global credential.helper store

#pfetch info
export EDITOR="vim"
export SHELL="bash"
export PF_INFO="ascii title os kernel editor uptime memory palette"
export PF_COL1=4
export PF_COL3=1

pfetch

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
