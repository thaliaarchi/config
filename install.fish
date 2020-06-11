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

link fish/config.fish ~/.config/fish/config.fish
link bash/bash_profile ~/.bash_profile
link bash/bashrc ~/.bashrc
link screen/screnrc ~/.screenrc
link tmux/tmux.conf ~/.tmux.conf
