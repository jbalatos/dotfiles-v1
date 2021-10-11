#! /bin/bash
cd

echo "Installing packages..."
sudo pacman -S python-setuptools nitrogen xorg xorg-server xorg-xinit qtile picom xterm firefox galculator nerd-fonts-ubuntu-mono xf86-video-intel lxsession pcmanfm
yay -S tabbed

echo "Installing pip modules..."
sudo pacman -S extra/python-pip
pip install dbus-next psutil 
