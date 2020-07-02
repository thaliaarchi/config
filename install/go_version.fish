#!/usr/bin/env fish

if ! command -q jq
  echo 'jq must be installed'
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

# See https://github.com/golang/website/blob/master/internal/dl/server.go
set releases (curl -sS 'https://golang.org/dl/?mode=json&include=all')
set versions (echo $releases | jq -r '.[].version')

echo 'Stable versions:'
echo $releases | jq -r '.[] | select(.stable == true) | .version' | column
echo 'Unstable versions:'
echo $releases | jq -r '.[] | select(.stable == false) | .version' | column

# Go GitHub release tags:
# curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
#     jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'

if command -q go
  echo 'Installed:'
  go version

  #set installed (go version)
  #echo $installed
  #set parts (string match -r '^go version (go[^ ]+) ([^/]+)/(.+)$' $installed)
  #set local_version $parts[2]
  #set local_goos $parts[3]
  #set local_goarch $parts[4]
end

echo
set dl_version (select_option 'Select version' $versions)
echo

echo 'Binaries:'
set binaries (echo -n $releases |
    VERSION=$dl_version jq -r '.[] | select(.version == env.VERSION) | .files | .[].filename')
string join \n $binaries | column

set binary (select_option 'Select binary' $releases)

echo 'Fetching binary...'
wget -nc -q --show-progress "https://golang.org/dl/$binary"
