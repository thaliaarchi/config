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
  set dest_dir (dirname $dest)

  if test -L $dest
    rm $dest
  end
  if test -e $dest
    echo "File exists at $dest"
    return
  end
  if ! test -d $dest_dir
    mkdir -p $dest_dir
  end
  ln -s $config_dir/$src $dest
end

if ! test -f $config_dir/dotfiles/bash/git-completion.bash
  wget 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' -O $config_dir/dotfiles/bash/git-completion.bash
end

# Suppress MOTD
! test -f ~/.hushlogin; and touch ~/.hushlogin

set nfconf ~/.config/neofetch/config.conf
if test -f $nfconf
  if test -L $nfconf; or neofetch --print_config | cmp -s $nfconf -
    rm $nfconf
  else
    set v (neofetch --version | head -n1)
    echo 'Neofetch config is modified from default or Neofetch is older than 4.0.2 ('$v')'
  end
end
link dotfiles/neofetch.conf $nfconf

link dotfiles/screnrc ~/.screenrc
link dotfiles/tmux.conf ~/.tmux.conf
link dotfiles/fish/functions ~/.config/fish/functions
link dotfiles/fish/config.fish ~/.config/fish/config.fish
link dotfiles/bash/bashrc ~/.bashrc
link dotfiles/bash/bash_profile ~/.bash_profile
