#!/usr/bin/env fish

# Install links to config

set config_dir (dirname (realpath (status -f)))/dotfiles

# Symlink config to destination and replace existing
# when unchanged from default.
function link_config
  set src $config_dir/$argv[1]
  set dest $argv[2]

  if test -L "$dest"
    # Preserve unchanged symlinks
    if test (readlink $dest) != "$src"
      ln -sf -- $src $dest
    end
    return
  end

  if test -d $src -a -d $dest
    if test (count (command ls -A $dest)) != 0
      echo "Files in directory $dest" >&2
      return 1
    end
    rm -r $dest
  end

  if test -e "$dest"
    echo "File or directory already exists at $dest" >&2
    return 1
  end

  mkdir -p -- (dirname $dest)
  ln -s -- $src $dest
end

function fetch_file
  set url $argv[1]
  set dest $config_dir/$argv[2]
  mkdir -p -- (dirname $dest)
  test -f "$dest" || wget $url -O $dest
end

function remove_default
  set dest $argv[1]
  set default $argv[2]
  if test -f "$dest" -a ! -L "$dest"
    if cmp -s -- $default $dest
      rm $dest
    else
      echo "File $dest is modified from default at $default" >&2
    end
  end
end

function remove_default_neofetch
  set dest $argv[1]
  if test -f "$dest" -a ! -L (dirname $dest)
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

test -z "$XDG_CONFIG_HOME" && set XDG_CONFIG_HOME ~/.config

fetch_file 'https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash' bash/completions/git-completion.bash

remove_default ~/.bashrc /etc/skel/.bashrc
remove_default ~/.bash_profile /etc/skel/.bash_profile
remove_default ~/.bash_logout /etc/skel/.bash_logout
remove_default ~/.screenrc /etc/skel/.screenrc
remove_default_neofetch $XDG_CONFIG_HOME/neofetch/config.conf

# Files in $HOME
link_config bash/bashrc.bash ~/.bashrc
link_config bash/bash_profile.bash ~/.bash_profile
link_config bash/bash_logout.bash ~/.bash_logout
link_config screenrc ~/.screenrc
test -f ~/.hushlogin || touch ~/.hushlogin # Suppress MOTD
# Directories in $XDG_CONFIG_HOME
link_config fish $XDG_CONFIG_HOME/fish
link_config neofetch $XDG_CONFIG_HOME/neofetch
# Files in $XDG_CONFIG_HOME
link_config shellcheckrc $XDG_CONFIG_HOME/shellcheckrc
link_config karabiner $XDG_CONFIG_HOME/karabiner

if after_version (tmux -V) 'tmux 3.1'
  link_config tmux ~/.config/tmux # tmux does not check $XDG_CONFIG_HOME
else
  link_config tmux/tmux.conf ~/.tmux.conf
end
