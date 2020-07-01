# Disable greeting
set fish_greeting

set EMAIL andrew@aarchibald.com
set EDITOR vim
set GIT_EDITOR vim

# Git
alias g='git'
alias gadd='git add'
alias branch='git branch'
alias checkout='git checkout'
alias check='git checkout'
alias clone='git clone'
alias commit='git commit'
alias gdiff='git diff'
alias fetch='git fetch'
alias ginit='git init'
alias glog='git log'
alias merge='git merge'
alias pull='git pull'
alias push='git push'
alias gstatus='git status'

alias master='git checkout master'
alias tcommit-pacific='TZ=":America/Los_Angeles" tcommit'
alias tcommit-mountain='TZ=":America/Denver" tcommit'
alias tcommit-berlin='TZ=":Europe/Berlin" tcommit'

# Directory listings
if uname | grep -q Darwin
  # Enable ls color output
  # https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output
  set -x CLICOLOR 1
  set -x LSCOLORS ExGxBxDxCxEgEdxbxgxcxd
  alias ls='ls -hF'
else
  alias ls='ls -hF --color=tty'
end
alias ll='ls -l'
alias la='ls -A'  # all but . and ..
alias lla='ls -lA'
alias l='ls -CF'

# Misc
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias df='df -h'        # human readable figures
alias du='du -h'        # human readable figures
alias whence='type -a'  # where, of a sort

# Directory aliases
alias '\~'='cd ~'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias dev='cd ~/dev'
alias godev='cd ~/go/src'

# Code Search
alias csearch='csearch -n'  # show line numbers
alias cgrep='cgrep -n'      # show line numbers

alias ddg='lynx https://duckduckgo.com/lite'
alias weather='curl wttr.in'

# rsync command for copying from an NTFS drive.
# Permissions are not preserved; symlinks and times are preserved.
# Attributes set to rwxr-xr-x for dirs, rw-r--r-- for files.
# Excludes Thumbs.db and desktop.ini.
alias rsyncwin='rsync -rltDvzh --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --exclude Thumbs.db --exclude desktop.ini'

alias ascii4='wspace ~/go/src/github.com/andrewarchi/nebula/programs/ascii4.out.ws'

# SSH remotes
alias bb='ssh -t schizo "ssh blackbird"'
alias de='ssh -t schizo "ssh germany"'

# Set host color based on hostname
switch (hostname)
case raspi
  set -g fish_color_host c31c4a red
  set -g fish_color_host_remote $fish_color_host
case blueberrye
  set -g fish_color_host blue
  set -g fish_color_host_remote $fish_color_host
case marionberryphi
  set -g fish_color_host magenta
  set -g fish_color_host_remote $fish_color_host
end

# https://github.com/ungoogled-software/ungoogled-chromium-macos#setting-up-the-build-environment
# https://github.com/pyenv/pyenv#basic-github-checkout
command -q pyenv; and pyenv init - | source

# /etc/profile sets 022, removing write perms to group and others.
# Neither group nor others have any perms:
umask 077

for dir in ~/bin /usr/local/go/bin ~/go/bin ~/.cargo/bin /usr/local/opt/llvm/bin ~/dev/github.com/andrewarchi/whitespace-haskell/bin ~/dev/github.com/LLNL/yorick/relocate/bin
  if test -d $dir
    set PATH $dir $PATH
  end
end

if test -d ~/man
  set MANPATH ~/man $MANPATH
end
if test -d ~/info
  set INFOPATH ~/info $INFOPATH
end

# Load local configuration
if test -e ~/.config/fish/config_local.fish
  source ~/.config/fish/config_local.fish
end

if status is-login
  command -q neofetch; and neofetch
end
