#!/usr/bin/env fish

# Install link to Fish config

if test -e ~/.config/fish/config.fish
  echo 'Fish config already exists at ~/.config/fish/config.fish'
  exit 1
end

set dir (dirname (readlink -e (status -f)))
ln -s $dir/config.fish ~/.config/fish/config.fish
