# If not running interactively, don't do anything
[[ "$-" != *i* ]] && return

READLINK=readlink
if uname | grep -q Darwin; then
  READLINK=greadlink
fi
config_dir="$(dirname "$($READLINK -e "${BASH_SOURCE[0]}")")"

source "$config_dir/bash_aliases.bash"
source "$config_dir/bash_functions.bash"

export EMAIL=andrew@aarchibald.com
export EDITOR=vim
export GIT_EDITOR=vim

# /etc/profile sets 022, removing write perms to group and others.
# Neither group nor others have any perms:
umask 077

PATH="$HOME/bin:$PATH"                # User bin
PATH="/usr/local/go/bin:$PATH"        # Go standard tools
PATH="$HOME/go/bin:$PATH"             # Go binaries
PATH="$HOME/.cargo/bin:$PATH"         # Rust
PATH="$HOME/dev/github.com/andrewarchi/whitespace-haskell/bin:$PATH"
PATH="$HOME/dev/github.com/LLNL/yorick/relocate/bin:$PATH"
export PATH

[ -d "$HOME/bin" ]  && PATH="$HOME/bin:$PATH"
[ -d "$HOME/man" ]  && MANPATH="$HOME/man:$MANPATH"
[ -d "$HOME/info" ] && INFOPATH="$HOME/info:$INFOPATH"

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if uname | grep -q Darwin; then
  # Homebrew-installed Bash
  PATH="/usr/local/bin/bash:$PATH"

  # LLVM
  # Keg only, see Homebrew caveats
  PATH="/usr/local/opt/llvm/bin:$PATH"

  # Homebrew Command Not Found
  # https://github.com/Homebrew/homebrew-command-not-found
  COMMAND_NOT_FOUND_HANDLER="$(brew --prefix)/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh"
  if [ -f "$COMMAND_NOT_FOUND_HANDLER" ]; then
    source "$COMMAND_NOT_FOUND_HANDLER"
  fi
fi

# Shell Options
#
# See man bash for more options...
#
# Don't wait for job termination notification
# set -o notify
#
# Don't use ^D to exit
# set -o ignoreeof
#
# Use case-insensitive filename globbing
# shopt -s nocaseglob
#
# Make bash append rather than overwrite the history on disk
# shopt -s histappend
#
# When changing directory small typos can be ignored by bash
# for example, cd /vr/lgo/apaache would find /var/log/apache
# shopt -s cdspell

# Completion options
#
# These completion tuning parameters change the default behavior of bash_completion:
#
# Define to access remotely checked-out files over passwordless ssh for CVS
# COMP_CVS_REMOTE=1
#
# Define to avoid stripping description in --option=description of './configure --help'
# COMP_CONFIGURE_HINTS=1
#
# Define to avoid flattening internal contents of tar files
# COMP_TAR_INTERNAL_PATHS=1
#
# Uncomment to turn on programmable completion enhancements.
# Any completions you add in ~/.bash_completion are sourced last.
# [[ -f /etc/bash_completion ]] && . /etc/bash_completion

# History Options

# Format history time as "2006-01-02 15:04:05  "
export HISTTIMEFORMAT='%F %T  '

# Don't put duplicate lines in the history.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups

# Ignore some controlling instructions
# HISTIGNORE is a colon-delimited list of patterns which should be excluded.
# The '&' is a special pattern which suppresses duplicate entries.
export HISTIGNORE=$'[ \t]*:&:[fb]g:exit:ls'

# Whenever displaying the prompt, write the previous line to disk
# export PROMPT_COMMAND='history -a'
