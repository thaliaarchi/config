#!/usr/bin/env fish

# Install links to config

set READLINK readlink
if uname | grep -q Darwin
  set READLINK greadlink
end
set config_dir (dirname ($READLINK -e (status -f)))

# Symlink config to destination and replace existing
# when unchanged from default.
function link
  set src $argv[1]
  set dest $argv[2]
  set compare_func $argv[3]
  set compare_args $argv[4..-1]

  if test -L $dest
    rm $dest
  end
  if test -e $dest
    echo "File already exists at $dest" >&2
    return
  end
  set dest_dir (dirname $dest)
  if ! test -d "$dest_dir"
    mkdir -p -- $dest_dir
  end
  ln -s -- $config_dir/$src $dest
end

function remove_default
  set dest $argv[1]
  set default $argv[2]
  if test -f $dest -a ! -L $dest
    if cmp -s -- $default $dest
      rm $dest
    else
      echo "File $dest is modified from default at $default" >&2
    end
  end
end

function remove_default_neofetch
  set dest $argv[1]
  if test -f $dest -a ! -L $dest
    if neofetch --print_config 2>/dev/null | cmp -s -- $dest -
      rm $dest
    else if after_version (neofetch --version | head -n1) '4.0.2'
      echo "File $dest is modified from `neofetch --print_config`" >&2
    end
  end
end

function after_version
  set current $argv[1]
  set min $argv[2]
  set versions (string join \n $current $min | sort -V)
  test "$versions[1]" = "$min"
  return $status
end

if ! test -f $config_dir/dotfiles/bash/git-completion.bash
  wget 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' -O $config_dir/dotfiles/bash/git-completion.bash
end

test -z "$XDG_CONFIG_HOME" && set XDG_CONFIG_HOME ~/.config

remove_default ~/.bashrc /etc/skel/.bashrc
remove_default ~/.bash_profile /etc/skel/.bash_profile
remove_default ~/.bash_logout /etc/skel/.bash_logout
remove_default ~/.screenrc /etc/skel/.screenrc
remove_default_neofetch $XDG_CONFIG_HOME/neofetch/config.conf

link dotfiles/bash/bashrc.bash ~/.bashrc
link dotfiles/bash/bash_profile.bash ~/.bash_profile
link dotfiles/bash/bash_logout.bash ~/.bash_logout
link dotfiles/screenrc ~/.screenrc
link dotfiles/neofetch/config.conf $XDG_CONFIG_HOME/neofetch/config.conf
link dotfiles/shellcheckrc $XDG_CONFIG_HOME/shellcheckrc
link dotfiles/karabiner $XDG_CONFIG_HOME/karabiner
! test -f ~/.hushlogin && touch ~/.hushlogin # Suppress MOTD

if after_version (tmux -V) 'tmux 3.1'
  link dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf # not $XDG_CONFIG_HOME
else
  link dotfiles/tmux/tmux.conf ~/.tmux.conf
end

link dotfiles/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
link dotfiles/fish/functions $XDG_CONFIG_HOME/fish/functions
