#!/usr/bin/env fish

if ! command -q jq
  echo 'jq must be installed'
  exit 1
end

# See https://github.com/golang/website/blob/master/internal/dl/server.go
set releases (curl -sS 'https://golang.org/dl/?mode=json&include=all')
set versions (echo $releases | jq -r '.[].version')

echo 'Stable versions:'
echo $releases | jq -r '.[] | select(.stable == true) | .version' | column
echo 'Unstable versions:'
echo $releases | jq -r '.[] | select(.stable == false) | .version' | column

# Go release tags:
#curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
#    jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")' |
#    column

if command -q go
  echo 'Installed:'
  go version

  #set installed (go version)
  #echo $installed
  #set parts (string match -r 'go version (go[^ ]+) ([^/]+)/(.+)' $installed)
  #set local_version $parts[2]
  #set local_goos $parts[3]
  #set local_goarch $parts[4]
end

echo
while true
  read -P 'Select version: ' dl_version
  string match -q --entire $dl_version $releases; and break
  echo 'Invalid version'
end

echo 'Binaries:'
set binaries (echo -n $releases |
    VERSION=$dl_version jq -r '.[] | select(.version == env.VERSION) | .files | .[].filename')
string join \n $binaries | column

echo
while true
  read -P 'Select binary: ' binary
  string match -q --entire $binary $releases; and break
  echo 'Invalid binary'
end

echo 'Fetching binary...'
wget -nc -q --show-progress "https://golang.org/dl/$binary"
