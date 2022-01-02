#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#Set jgmenu theme
jgmenu_run init --theme=col3

#Open nm-applet
nm-applet &

# Set trackpad options
xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Click Method Enabled" 0 1
xinput set-prop "MSFT0001:00 06CB:7E7E Touchpad" "libinput Natural Scrolling Enabled" 1

# Open flameshot
flameshot &

nitrogen --restore &
picom &
lxsession &
dunst -transparency 95 -dmenu /usr/bin/dmenu -browser /usr/bin/firefox &
exec qtile start
