#! /bin/bash
echo "Installing Vim-Plug..."
cd
git clone https://github.com/junegunn/vim-plug.git
echo "You need to run :PlugInstall when you next open vim"

echo "Installing pfetch..."
cd
git clone https://github.com/dylanaraps/pfetch.git
cd pfetch
sudo make install

echo "Installing dmenu-jbalatos..."
cd
git clone https://github.com/jbalatos/dmenu-jbalatos-git.git
cd dmenu-jbalatos-git
sudo make
sudo make install

echo "Installing tabbed-jbalatos..."
cd
git clone https://github.com/jbalatos/tabbed-jbalatos-git.git
cd tabbed-jbalatos-git
sudo make
sudo make install

echo "Installing jgmenu..."
cd
git clone https://github.com/johanmalm/jgmenu.git
cd jgmenu
./configure
sudo make
sudo make install

echo "Done!"
