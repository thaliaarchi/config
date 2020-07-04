#!/usr/bin/env fish

for dep in git jq curl wget
  ! command -q $dep; and set missing $missing $dep
end
if count $missing > /dev/null
  echo "Required dependencies: $missing" >&2
  exit 1
end

set installs
set --path gopaths

function select_option
  set prompt $argv[1]
  set options $argv[2..-1]
  while true
    read -P "$prompt: " val
    if contains $val $options
      echo $val
      return
    end
  end
end

function prompt_yn
  read -P "$argv[1] (y/n) " -n1 reply
  string match -q -i 'y' $reply
  return $status
end

function register_install
  set GOROOT $argv[1]
  set go $GOROOT/bin/go
  if ! test -x $go
    echo "Not executable: $go" >&2
    return
  end
  set GOPATH ($go env GOPATH)
  set goversion ($go version)
  echo (string replace -r '^go version ' '' $goversion) $GOROOT
  set -a installs
  for p in $GOPATH
    if ! contains -- $p $gopaths
      set -a gopaths $p
    end
  end
end

# See https://github.com/golang/website/blob/master/internal/dl/server.go
set releases (curl -sS 'https://golang.org/dl/?mode=json&include=all')
set versions (echo $releases | jq -r '.[].version')

# Go GitHub release tags:
# curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
#     jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'

set_color -o green
echo 'Stable versions:'
set_color normal
echo $releases | jq -r '.[] | select(.stable == true) | .version' | column
echo

set_color -o red
echo 'Unstable versions:'
set_color normal
echo $releases | jq -r '.[] | select(.stable == false) | .version' | column
echo

set_color -o blue
echo 'Installed versions:'
set_color normal

if command -q go
  register_install (go env GOROOT)
end

if command -q brew
  # `brew list --versions golang` is too slow.
  # Instead list versions in cellar directory.
  set brew_prefix (brew --prefix)
  for v in (command ls $brew_prefix/Cellar/go 2>/dev/null)
    register_install "$brew_prefix/Cellar/go/$v"
  end
end

for goversion in (cd ~/sdk 2>/dev/null && command ls | grep '^go')
  register_install ~/sdk/$goversion
end

echo

if prompt_yn 'Install main version?'
  set dl_version (select_option 'Select version' $versions)
  echo

  echo 'Binaries:'
  set binaries (echo -n $releases |
      VERSION=$dl_version jq -r '.[] | select(.version == env.VERSION) | .files | .[].filename')
  string join \n $binaries | column

  set binary (select_option 'Select binary' $releases)

  echo 'Fetching binary...'
  wget -nc -q --show-progress "https://golang.org/dl/$binary"
  echo
end

if prompt_yn 'Install extra versions?'
  go get -d golang.org/dl/gotip
  set GOPATH (go env GOPATH)
  set versions (git -C "$GOPATH[1]/src/golang.org/dl" ls-tree -d --name-only HEAD | grep '^go')

  echo 'Versions:'
  string join \n $versions | sort -Vr | column
  echo

  while true
    set extra_version (select_option 'Select version' $versions)
    go install golang.org/dl/$extra_version
    eval $extra_version download
    eval $extra_version version
  end
end
