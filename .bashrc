#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Terminal aliases
alias ls='ls --color=auto'
alias la='ls -a --color=auto'
alias ..='cd ..'
shopt -s autocd

# dotfile git alias
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
# When first cloning / initialising dotfile,  run the following commands :
# config config --local status.showUntrackedFiles no
# config config --global credential.helper store

# Terminal prompt
PS1="\[\033[31m\][\W]\[\033[32m\]> \[\033[37m\]"

# [ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

export EDITOR="vim"
export SHELL="bash"
export PF_INFO="ascii title os kernel editor uptime memory palette"
export PF_COL1=4
export PF_COL3=1

pfetch
