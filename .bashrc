#
# ~/.bashrc
#


# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Terminal prompt
PS1="\[\033[31m\][\w \A]\n\[\033[32m\]> \[\033[37m\]"
PS2="  \[\033[32m\]>\[\033[37m\] "

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls --color=auto'
alias cat='bat'
shopt -s autocd
shopt -s cdspell

alias btset='brightnessctl set'
alias cpp-clear='rm *.out && ls | grep -v "\." | xargs rm'

# dotfile git alias
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
# When first cloning / initialising dotfile,  run the following commands :
# config config --local status.showUntrackedFiles no
# config config --global credential.helper store

#pfetch info
export EDITOR=gvim
export SHELL="bash"
export PF_INFO="ascii title os kernel bash editor uptime memory palette"
export PF_COL1=4
export PF_COL3=1

export JAVA_HOME='/usr/lib/jvm/java-18-openjdk/'
export PATH="$JAVA_HOME/bin:$PATH"

export ANDROID_SDK_ROOT='/opt/android-sdk'
export PATH="$PATH:$ANDROID_SDK_ROOT/platform-tools/"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/bin/"
export PATH="$PATH:$ANDROID_SDK_ROOT/emulator"
export PATH="$PATH:$ANDROID_SDK_ROOT/tools/"

export CHROME_EXECUTABLE='/usr/bin/google-chrome-stable'
export PATH="$HOME/.emacs.d/bin/:$PATH"

xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Click Method Enabled" 0 1
xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Natural Scrolling Enabled" 1

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

pfetch

