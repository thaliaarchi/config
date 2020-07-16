READLINK=readlink
if uname | grep -q Darwin; then
  READLINK=greadlink
fi
config_dir="$(dirname "$($READLINK -e "${BASH_SOURCE[0]}")")"

# To override the alias instruction use a \ before,
# ie \rm will call the real rm not the alias.

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

# https://stackoverflow.com/questions/342969/how-do-i-get-bash-completion-to-work-with-aliases
source "$config_dir/completions/git-completion.bash"
__git_complete g __git_main
__git_complete branch _git_branch
__git_complete checkout _git_checkout
__git_complete check _git_checkout
__git_complete clone _git_clone
__git_complete commit _git_commit
__git_complete gdiff _git_diff
__git_complete fetch _git_fetch
__git_complete glog _git_log
__git_complete pull _git_pull
__git_complete push _git_push

alias master='git checkout master'

# Directory listings
if uname | grep -q Darwin; then
  # Enable ls color output
  # https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output
  export CLICOLOR=1
  export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd
  alias ls='ls -hF'
else
  alias ls='ls -hF --color=tty'
fi
alias ll='ls -l'
alias la='ls -A'  # all but . and ..
alias lla='ls -lA'
alias l='ls -CF'

# Misc
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias df='df -h'
alias du='du -h'
alias whence='type -a'

# Directory aliases
alias ~='cd $HOME'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias dev='cd $HOME/dev'
alias godev='cd $HOME/go/src'

# Update credentials on every sudo
alias sudo='sudo -v; sudo'

# Code Search, show line numbers
command -v csearch > /dev/null 2>&1 && alias csearch='csearch -n'
command -v cgrep > /dev/null 2>&1   && alias cgrep='cgrep -n'

command -v lynx > /dev/null 2>&1 && alias ddg='lynx https://duckduckgo.com/lite'
command -v curl > /dev/null 2>&1 && alias weather='curl wttr.in'

# rsync command for copying from an NTFS drive.
# Permissions are not preserved; symlinks and times are preserved.
# Attributes set to rwxr-xr-x for dirs, rw-r--r-- for files.
# Excludes Thumbs.db and desktop.ini.
command -v rsync > /dev/null 2>&1 &&
  alias rsyncwin='rsync -rltDvzh --chmod=Du=rwx,Dgo=rx,Fu=rw,Fgo=r --exclude Thumbs.db --exclude desktop.ini'

# 4-column ASCII table
command -v wspace > /dev/null 2>&1 &&
  alias ascii4='wspace $HOME/go/src/github.com/andrewarchi/nebula/programs/ascii4.out.ws'

# SSH into a random CS lab machine
alias cs='CS_MACHINES=($(cat ~/cs_machines_random)); RANDOM_MACHINE="${CS_MACHINES[$RANDOM % ${#CS_MACHINES[@]}]}"; echo "ssh $RANDOM_MACHINE"; ssh "$RANDOM_MACHINE"'
