#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Terminal aliases
alias ls='ls --color=auto'
alias ..='cd ..'
shopt -s autocd

# dotfile git alias
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'

# Terminal prompt
PS1="\[\033[31m\][\W]\[\033[32m\]> \[\033[37m\]"

# [ -n "$XTERM_VERSION" ] && transset-df --id "$WINDOWID" >/dev/null

export EDITOR="vim"
export SHELL="xterm"
export PF_INFO="ascii title os editor shell uptime memory palette"
export PF_COL1=4
export PF_COL3=1

pfetch
