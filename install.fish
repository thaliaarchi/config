#!/usr/bin/env fish

# Install links to config

set READLINK readlink
if uname | grep -q Darwin
  set READLINK greadlink
end
set config_dir (dirname ($READLINK -e (status -f)))

function link
  set src $argv[1]
  set dest $argv[2]

  if test -L $dest
    rm $dest
  end
  if test -e $dest
    echo "File exists at $dest"
    return
  end
  ln -s $config_dir/$src $dest
end

if not test -f $config_dir/bash/git-completion.bash
  wget 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' -O $config_dir/bash/git-completion.bash
end

if test -f ~/.config/neofetch/config.conf
  if neofetch --print_config | cmp -s ~/.config/neofetch/config.conf -
    rm ~/.config/neofetch/config.conf
  else
    echo 'neofetch config is modified from default'
  end
end

link screen/screnrc ~/.screenrc
link tmux/tmux.conf ~/.tmux.conf
link neofetch/config.conf ~/.config/neofetch/config.conf
link fish/functions ~/.config/fish/functions
link fish/config.fish ~/.config/fish/config.fish
link bash/bashrc ~/.bashrc
link bash/bash_profile ~/.bash_profile
