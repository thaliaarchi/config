set fish_greeting

# Default to human readable figures
alias df='df -h'
alias du='du -h'

# Misc :)
alias whence='type -a'                        # where, of a sort
alias grep='grep --color'                     # show differences in color
alias egrep='egrep --color=auto'              # show differences in color
alias fgrep='fgrep --color=auto'              # show differences in color

# Some shortcuts for different directory listings
alias ls='ls -hF --color=tty'                 # classify files in color
alias dir='ls --color=auto --format=vertical'
alias vdir='ls --color=auto --format=long'
alias ll='ls -l'                              # long list
alias la='ls -A'                              # all but . and ..
alias l='ls -CF'

# Git
alias master='git checkout master'

alias g='git'
alias branch='git branch'
alias checkout='git checkout'
alias check='git checkout'
alias clone='git clone'
alias commit='git commit'
alias gdiff='git diff'
alias fetch='git fetch'
alias glog='git log'
alias pull='git pull'
alias push='git push'

alias bcompare='"/cygdrive/c/Program\ Files/Beyond\ Compare\ 4/BCompare.exe"'
alias bcomp='"/cygdrive/c/Program\ Files/Beyond\ Compare\ 4/BComp.exe"'
