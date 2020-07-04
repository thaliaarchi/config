# Fish

## Set shell to fish

```sh
sudo apt install fish -y
chsh -s $(command -v fish)
```

## Update fish with apt

```sh
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
```

## Building from source

```sh
sudo apt install build-essential cmake ncurses-dev libncurses5-dev libpcre2-dev gettext -y
mkdir -p ~/dev/github.com/fish-shell/fish-shell
cd ~/dev/github.com/fish-shell/fish-shell
git clone https://github.com/fish-shell/fish-shell .
mkdir build; cd build
cmake ..
make
sudo make install
```
