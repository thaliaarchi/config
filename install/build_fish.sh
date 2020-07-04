#!/bin/sh -e

echo 'Make sure dependencies are satisfied:'
echo '    sudo apt install build-essential cmake ncurses-dev \'
echo '                     libncurses5-dev libpcre2-dev gettext -y'

if [ ! -d ~/dev/github.com/fish-shell/fish-shell ]; then
  mkdir -p ~/dev/github.com/fish-shell
  git clone https://github.com/fish-shell/fish-shell ~/dev/github.com/fish-shell/fish-shell
fi
cd ~/dev/github.com/fish-shell/fish-shell
git pull

mkdir -p build; cd build
cmake ..
make
sudo make install
