#! /usr/bin/env bash

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

#Open nm-applet
#nm-applet &

# Open flameshot
#flameshot &

#nitrogen --restore &
#picom &
#lxsession &
#dunst -transparency 95 -dmenu /usr/bin/dmenu -browser /usr/bin/firefox &

xinput set-prop "DLL06E4:01 06CB:7A13 Touchpad" "libinput Click Method Enabled" 0 1
xinput set-prop "DLL06E4:01 06CB:7A13 Touchpad" "libinput Tapping Enabled" 1
xinput set-prop "DLL06E4:01 06CB:7A13 Touchpad" "libinput Natural Scrolling Enabled" 1

# Add greek keyboard layout
# setxkbmap -model pc104 -layout us,gr -option 'grp:win_space_toggle'

# Start window manager
# QTile
# exec qtile start
# XMonad
exec xmonad
