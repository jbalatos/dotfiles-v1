#! /bin/bash
cd

echo "Installing base-devel..."
sudo pacman -S base-devel

echo "Cloning git repository..."
git clone https://aur.archlinux.org/yay-git.git

echo "Building yay..."
cd yay-git
makepkg -si

echo "Done!"
