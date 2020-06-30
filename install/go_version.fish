#!/usr/bin/env fish

if ! command -q jq
  echo 'jq must be installed'
  exit 1
end

echo 'Fetching Go versions'

curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'

if command -q go
  echo 'Installed:'
  go version
end
