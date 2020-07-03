#!/usr/bin/env fish

for dep in git jq curl wget
  ! command -q $dep; and set missing $missing $dep
end
if count $missing > /dev/null
  echo 'Required dependencies:' $missing
  exit 1
end

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

if command -q go
  set installed (string match -r '^go version (go[^ ]+) ([^/]+)/(.+)$' (go version))
  set installed_version $installed[2]
  set installed_goos $installed[3]
  set installed_goarch $installed[4]

  set GOROOT (go env GOROOT)
  if prompt_yn "$installed_version is installed at $GOROOT. Uninstall?"
    sudo rm $GOROOT
    # TODO notify user to remove from PATH
    echo
  end
end

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
