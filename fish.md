# Fish setup

```sh
sudo apt install fish -y
```

## Set shell to tmux with fish

```sh
chsh -s $(command -v tmux)
echo "set -g default-shell $(command -v fish)" >> ~/.tmux.conf
```

## Disable greeting

```sh
echo "set fish_greeting" >> ~/.config/fish/config.fish
```
