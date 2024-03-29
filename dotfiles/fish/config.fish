# Disable greeting
set fish_greeting

fish_add_path ~/bin

# Git
abbr -a g 'git'
abbr -a gadd 'git add'
abbr -a bisect 'git bisect'
abbr -a blame 'git blame'
abbr -a branch 'git branch'
abbr -a checkout 'git checkout'
abbr -a check 'git checkout'
abbr -a cherry 'git cherry-pick'
abbr -a clean 'git clean'
abbr -a clone 'git clone'
abbr -a commit 'git commit'
abbr -a amend 'git commit --amend --no-edit'
abbr -a gconfig 'git config'
abbr -a gdescribe 'git describe'
abbr -a gdiff 'git diff'
abbr -a fetch 'git fetch'
abbr -a filter-repo 'git filter-repo'
abbr -a ginit 'git init'
abbr -a glog 'git log'
abbr -a merge 'git merge'
abbr -a pull 'git pull'
abbr -a push 'git push'
abbr -a fpush 'git push --force-with-lease'
abbr -a rebase 'git rebase -i'
abbr -a rabort 'git rebase --abort'
abbr -a rcont 'git rebase --continue'
abbr -a rquit 'git rebase --quit'
abbr -a rskip 'git rebase --skip'
abbr -a rtodo 'git rebase --edit-todo'
abbr -a reflog 'git reflog'
abbr -a remote 'git remote'
abbr -a greset 'git reset'
abbr -a rev-parse 'git rev-parse'
abbr -a stash 'git stash'
abbr -a gstatus 'git status'
abbr -a submodule 'git submodule'
abbr -a gswitch 'git switch'
abbr -a tag 'git tag'
abbr -a tcommit 'git tcommit'
abbr -a tcommit-pacific 'TZ=":America/Los_Angeles" git tcommit'
abbr -a tcommit-mountain 'TZ=":America/Denver" git tcommit'
abbr -a tcommit-berlin 'TZ=":Europe/Berlin" git tcommit'
abbr -a tamend 'GIT_COMMITTER_DATE=(git show -s --format=%ai) git commit --amend --no-edit'
abbr -a trebase 'git trebase -i'
abbr -a worktree 'git worktree'

set -g __fish_git_alias_tcommit commit
set -g __fish_git_alias_trebase rebase

function main --wraps='git checkout main'
  if ! git rev-parse -q --verify main > /dev/null &&
       git rev-parse -q --verify master > /dev/null
    git checkout master $argv
  else
    git checkout main $argv
  end
end
function master --wraps='git checkout master'
  if ! git rev-parse -q --verify master > /dev/null &&
       git rev-parse -q --verify main > /dev/null
    git checkout main $argv
  else
    git checkout master $argv
  end
end

function git-check-dates
  git log --format='test "%ai" = "%ci" || echo "%ai %ci %h %s"' $argv | source
end

function git-link-worktree -d 'Set the .git dir for a linked worktree to point to the worktree'
  git config --unset core.worktree
  set -l worktree (realpath --relative-to=(git rev-parse --absolute-git-dir) (git rev-parse --show-toplevel))
  test $worktree != .. && git config core.worktree $worktree
end

# -A  List all entries except for . and ..                   GNU BSD
# -a  List all entries except for . and ..                           exa
#
# -l  List in long format                                    GNU BSD exa
#
# -1  Display one entry per line                             GNU BSD exa
#
# -b  Print C-style escapes for non-graphic characters       GNU BSD
#
# -F  Append indicator to entries                            GNU BSD exa
#       / directory                                          GNU BSD exa
#       * executable                                         GNU BSD exa
#       @ symbolic link                                      GNU BSD exa
#       | FIFO                                               GNU BSD exa
#       = socket                                             GNU BSD exa
#       > door                                               GNU
#       % whiteout                                               BSD
#
# -h  Print sizes in powers of 1024 (K M G etc.)             GNU
# -h  Print sizes in powers of 1024 (B K M G etc.)               BSD
# -b  Print sizes in powers of 1024 (Ki Mi Gi etc.)                  exa
# --si       Print sizes in powers of 1000 (k M G etc.)          GNU
# (default)  Print sizes in powers of 1000 (k M G etc.)              exa
#
# -G  In a long listing, omit group names                    GNU
# -o  List in long format, but omit the group id             GNU BSD
# -g  In a long listing, include group names                         exa
#
# -H  In a long listing, include the number of hard links            exa
#
# -G  Enable colored output; equivalent to defining CLICOLOR     BSD
#
# --group-directories-first                                  GNU     exa
#     List directories before other files
#
# --git  List the Git status for each tracked file                   exa

# Directory listings
if command -q exa
  alias la='exa -abF'
  alias ll='exa -abFl --group-directories-first'
  alias l1='exa -1b'
  alias ls='exa -bF'
  alias l='exa -bF'
else
  set -l ls ls
  if command -q gls # brew install coreutils
    set ls gls
  end
  if $ls --version 2> /dev/null | grep -q 'GNU coreutils'
    # GNU
    alias la="$ls -AbFGh --color"
    alias ll="$ls -AbFGhl --color --group-directories-first"
    alias l1="$ls -1bGh --color"
    alias ls="$ls -bFGh --color"
    alias l="$ls -bFGh --color"
  else
    # BSD
    alias la="$ls -AbFGh"
    alias ll="$ls -AbFGho"
    alias l1="$ls -1bGh"
    alias ls="$ls -bFGh"
    alias l="$ls -bFGh"
    # Colors mimicking GNU
    # https://apple.stackexchange.com/questions/33677/how-can-i-configure-mac-terminal-to-have-color-ls-output
    set -x CLICOLOR 1
    set -x LSCOLORS ExGxBxDxCxEgEdxbxgxcxd
  end
end

# Misc
alias grep='grep --color'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias less='less -R' # or LESS=R
alias df='df -h'
alias du='du -h'
alias whence='type -a'

# Directory shortcuts
# ~ and .. are supported by default
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias ..........='cd ../../../../../../../../..'
alias ...........='cd ../../../../../../../../../..'
alias ............='cd ../../../../../../../../../../..'
alias dev='cd ~/dev'
alias godev='cd ~/go/src'

function mkcd -a dir
  mkdir $dir && cd $dir
end

# Update credentials on every sudo
alias sudo='command sudo -v; command sudo'

# Command substitutions
abbr -a youtube-dl yt-dlp
abbr -a gdb lldb
abbr -a cloc tokei # cloc, scc, tokei

# Code Search, show line numbers
command -q csearch && alias csearch='csearch -n'
command -q cgrep   && alias cgrep='cgrep -n'

command -q lynx && alias ddg='lynx https://duckduckgo.com/lite'
command -q curl && alias weather='curl wttr.in'

# pbcopy/pbpaste aliases using X11
if ! command -q pbcopy && command -q xclip
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
end

function cdef -a ident
  ident=(string escape --style=regex $ident) \
  func_or_var="^([^\s/#].+\s+\**)?$ident\s*[(=;\[]" \
  define="^\s*#\s*define\s+$ident([(\s]|\$)" \
  typedef="(^|;)\s*typedef\s+.+\s+$ident\s*;" \
  rg --glob='*.{c,h,cpp,cc,hpp}' "$func_or_var|$define|$typedef"
end

function rsyncclean
  set -l exclude Thumbs.db '$RECYCLE.BIN' 'System Volume Information' \
    .DS_Store .Spotlight-V100 .TemporaryItems .Trashes .fseventsd __MACOSX
  echo rsync -vzh {--exclude,$exclude} $argv
end

# rsync command for copying from an NTFS or exFAT drive.
#
# Preserves times and symlinks; strips permissions, owner, and group
# (same as --archive without -pogD).
function rsyncwin
  rsyncclean -rlt --chmod='Du=rwx,Dgo=rx,Fu=rw,Fgo=r' $argv
end

# protonchk checks availability of a ProtonMail address.
function protonchk -a username
  echo proton.me:
  curl "https://account.proton.me/api/users/available?Name=$username%40proton.me&ParseDomain=1" -H 'x-pm-appversion: web-account@5.0.15.2'
  echo
  echo protonmail.com:
  curl "https://account.proton.me/api/users/available?Name=$username%40protonmail.com&ParseDomain=1" -H 'x-pm-appversion: web-account@5.0.15.2'
  echo
end

# getcrx fetches a Chrome extension crx from the Chrome Web Store.
function getcrx -a id
  set -l CHROME_VERSION '86.0.4240.183'
  wget --content-disposition --no-clobber "https://clients2.google.com/service/update2/crx?response=redirect&prodversion=$CHROME_VERSION&acceptformat=crx2,crx3&x=id%3D$id%26uc"
end

# 4-column ASCII table
command -q wspace && alias ascii4='wspace ~/go/src/github.com/thaliaarchi/nebula/programs/ascii4.out.ws'

# Format history time as "2006-01-02 15:04:05  "
alias history='history --show-time="%Y-%m-%d %H:%M:%S  "'

set -Ux DO_NOT_TRACK 1                 # https://consoledonottrack.com/
set -Ux HOMEBREW_NO_ANALYTICS 1        # Homebrew `brew analytics off` https://docs.brew.sh/Analytics
set -Ux DOTNET_CLI_TELEMETRY_OPTOUT 1  # .NET SDK https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry#how-to-opt-out
set -Ux AZURE_CORE_COLLECT_TELEMETRY 0 # Azure CLI https://docs.microsoft.com/en-us/cli/azure/azure-cli-configuration#cli-configuration-values-and-environment-variables
set -Ux SAM_CLI_TELEMETRY 0            # AWS SAM CLI https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-telemetry.html
set -Ux GATSBY_TELEMETRY_DISABLED 1    # Gatsby `gatsby telemetry --disable` https://www.gatsbyjs.com/docs/telemetry/
# TODO: opt out of telemetry using https://github.com/beatcracker/toptout

# Disable suggestion to scan Docker images with Snyk
# https://github.com/docker/scan-cli-plugin/issues/149
set -Ux DOCKER_SCAN_SUGGEST false

if status is-interactive && command -q zoxide
  zoxide init fish | source
end

# Add pyenv to PATH manually:
# set -Ux PYENV_ROOT ~/.pyenv
# set -Ua fish_user_paths $PYENV_ROOT/shims

if status is-interactive && command -q jenv
  jenv init - | source
end
if status is-interactive && command -q rbenv
  rbenv init - fish | source
end

# ghcup-env
if ! set -q GHCUP_INSTALL_BASE_PREFIX[1]
  set GHCUP_INSTALL_BASE_PREFIX $HOME
end
set -gx PATH ~/.cabal/bin ~/.ghcup/bin $PATH

# opam configuration
if test -e ~/.opam/opam-init/init.fish
  source ~/.opam/opam-init/init.fish > /dev/null 2>&1
end

# Homebrew Command Not Found
# https://github.com/Homebrew/homebrew-command-not-found
if status is-interactive && command -q brew
  set -l handler (brew --prefix)'/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.fish'
  if test -f $handler
    source $handler
  end
end

# /etc/profile sets 022, removing write perms to group and others.
# Neither group nor others have any perms:
umask 077

# set -a CDPATH . ~/dev/github.com/thaliaarchi ~/go/src/github.com/thaliaarchi

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

# if status is-login && status is-interactive
#   command -q neofetch && neofetch
# end


if command -q terminal-notifier # macOS
  function postexec_notify --arg cmd --on-event fish_postexec
    # brew install terminal-notifier
    # https://github.com/julienXX/terminal-notifier

    # TODO detect whether terminal is topmost application.
    # It doesn't seem possible to get the terminal's pid from fish.
    # osascript -e 'tell application "System Events" to return unix id of (first process whose its frontmost is true)'

    set -l s $pipestatus
    if test "$CMD_DURATION" -ge 25000 && ! string match -rq '(^man|\s--help)(\s|$)' $cmd
      if string match -qv 0 $s
        terminal-notifier -title $cmd -message 'Exited with '(string join '|' $s)' after '(math $CMD_DURATION / 1000)s
      else
        terminal-notifier -title $cmd -message 'Finished in '(math $CMD_DURATION / 1000)s
      end
    end
  end
else if command -q notify-send # Ubuntu
  function postexec_notify --arg cmd --on-event fish_postexec
    set -l s $pipestatus
    if test "$CMD_DURATION" -ge 25000 && ! string match -rq '(^man|\s--help)(\s|$)' $cmd
      if string match -qv 0 $s
        notify-send $cmd 'Exited with '(string join '|' $s)' after '(math $CMD_DURATION / 1000)s
      else
        notify-send $cmd 'Finished in '(math $CMD_DURATION / 1000)s
      end
    end
  end
end
