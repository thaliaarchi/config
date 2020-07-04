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
    if test -z $compare_func
      echo "File exists at $dest" >&2
      return
    else if eval $compare_func $dest $compare_args
      rm $dest
    else
      return
    end
  end
  set dest_dir (dirname $dest)
  if ! test -d $dest_dir
    mkdir -p -- $dest_dir
  end
  ln -s -- $config_dir/$src $dest
end

if ! test -f $config_dir/dotfiles/bash/git-completion.bash
  wget 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' -O $config_dir/dotfiles/bash/git-completion.bash
end

function file_default
  set dest $argv[1]
  set default $argv[2]
  test -f "$dest"; and cmp -s -- $default $dest
  set cmp $status
  if test $cmp -ne 0
    echo "File $dest is modified from default at $default" >&2
  end
  return $cmp
end

function neofetch_default
  set dest $argv[1]
  neofetch --print_config 2>/dev/null | cmp -s -- $dest -
  set cmp $status
  if test $cmp -ne 0
    set v (neofetch --version | head -n1)
    echo "File $dest is modified from default or Neofetch is older than 4.0.2 ($v)" >&2
  end
  return $cmp
end

test -z "$XDG_CONFIG_HOME"; and set XDG_CONFIG_HOME ~/.config

# Suppress MOTD
! test -f ~/.hushlogin; and touch ~/.hushlogin

link dotfiles/neofetch.conf $XDG_CONFIG_HOME/neofetch/config.conf neofetch_default
link dotfiles/shellcheckrc $XDG_CONFIG_HOME/shellcheckrc
link dotfiles/screenrc ~/.screenrc
link dotfiles/tmux.conf ~/.config/tmux/tmux.conf # tmux >3.1 (does not check $XDG_CONFIG_HOME)
#link dotfiles/tmux.conf ~/.tmux.conf # tmux <3.1
link dotfiles/fish/functions $XDG_CONFIG_HOME/fish/functions
link dotfiles/fish/config.fish $XDG_CONFIG_HOME/fish/config.fish
link dotfiles/bash/bashrc.bash ~/.bashrc file_default /etc/skel/.bashrc
link dotfiles/bash/bash_profile.bash ~/.bash_profile file_default /etc/skel/.bash_profile
