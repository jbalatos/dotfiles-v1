#! /usr/bin/env bash

if [ "$(id -u)" = 0 ]; then
	echo "!!! Should not be ran with sudo / as root user !!!"
	exit 1
fi

echo "--- Installing necessary packages from pacman... ---"
sudo pacman -S git base-devel alsa-utils binutils bluez blueberry \
	community/brightnessstl caffeine cmake ctags cups curl discord \
	evince flameshot galculator gdb g++ hplip jdk-openjdk jre-openjdk \
	lxsession musescore networkmanager \
	network-manager-applet nitrogen obs-studio pcmanfm pavucontrol \
	picom polkit pulseaudio python simple-scan \
	texlive-core texlive-langgreek tmux trayer vim vlc volumeicon \
	wmctrl xdotool xmobar xmonad xmonad-contrib xorg xorg-server \
	xournalpp alacritty
echo "--- Pacman package installation successful! ---"

echo "--- Downloading and building yay... ---"
cd
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
echo "--- Yay installed! ---"

echo "--- Installing necessary packages from aur... ---"
yay -S caffeine checkupdates-aur nerd-fonts-ubuntu-mono spotify teams \
	zoom
echo "--- AUR installation successful! ---"

echo "--- Building dmenu-jbalatos... ---"
cd
git clone https://github.com/jbalatos/dmenu-jbalatos-git.git
cd dmenu-jbalatos-git
make
sudo make install
cd ..
rm -rf dmenu-jbalatos-git
echo "--- Dmenu installed! ---"

echo "--- Building slock-jbalatos... ---"
cd
git clone https://github.com/jbalatos/slock-jbalatos-git.git
cd slock-jbalatos-git
make
sudo make install
cd ..
rm -rf slock-jbalatos-git
echo "--- Slock installed! ---"

echo "--- Installing Vim-Plug... ---"
cd
git clone https://github.com/junegunn/vim-plug.git
echo "You need to run :PlugInstall when you next open vim"
echo "--- Vim-Plug installed! ---"

echo "--- Installing pfetch... ---"
cd
git clone https://github.com/dylanaraps/pfetch.git
cd pfetch
sudo make install
cd ..
rm -rf pfetch
echo "--- pfetch installed! ---"

echo "--- Downloading and syncing jbalatos dotfiles... ---"
git clone https://github.com/jbalatos/dotfiles.git $HOME/dotfiles
alias config='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'
config config --local status.showUntrackedFiles no
config config --global credential.helper store
config pull origin master
echo "--- Dotfiles downloaded! ---"

echo "--- Placing dmenu scripts at /usr/local/bin... ---"
cd dmenu-scripts
chmod +x ./*
./update-dm-scripts.sh
echo "--- dmenu scripts complete! ---"

echo "--- INSTALLATION COMPLETE ---"
