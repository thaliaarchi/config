#!/usr/bin/env fish

if ! command -q jq
  echo 'jq must be installed'
  exit 1
end

echo 'Fetching Go releases'

curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'

if command -q go
  echo 'Installed:'
  set v (go version)
  echo $v
  set parts (string match -r 'go version (go[^ ]+) ([^/]+)/(.+)' $v)
  set installed_version $parts[2]
  set installed_goos $parts[3]
  set installed_goarch $parts[4]
end
