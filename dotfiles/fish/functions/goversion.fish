function __goversion_releases -d 'Query Go releases as JSON'
  curl -sS 'https://golang.org/dl/?mode=json&include=all' | string collect
end
function __goversion_versions -d 'Extract versions from releases'
  jq -r '.[].version'
end
function __goversion_versions_stable -a stable -d 'Extract versions with given stability from releases'
  jq -r ".[] | select(.stable == $stable) | .version"
end

function __goversion_extra -d 'Query extra Go versions'
  if ! command -q go
    echo 'go must be in PATH to install extra Go versions' >&2
    return 1
  end
  go get -d golang.org/dl/gotip
  set GOPATH (go env GOPATH)
  git -C "$GOPATH[1]/src/golang.org/dl" ls-tree -d --name-only HEAD | command grep '^go'
end

function __goversion_tags -d 'Query GitHub release tags'
  curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
      jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'
end

function __goversion_installed_goroots -d 'List paths to installed Go versions'
  set -l install_paths
  if command -q go
    set -a install_paths (command -v go)
  end

  # Installs in PATH
  for go in $PATH/go
    set -a install_paths $go
  end

  # Homebrew
  if command -q brew
    # `brew list --versions golang` is too slow.
    # Instead traverse versions in cellar directory directly.
    for go in (brew --prefix)/Cellar/go/*/libexec/bin/go
      set -a install_paths $go
    end
  end

  # Extra versions: https://golang.org/doc/install#extra_versions
  for go in ~/sdk/*/bin/go
    set -a install_paths $go
  end

  # Canonicalize to GOROOT and dedupe
  set -l install_goroots
  for go in $install_paths
    test -x "$go" || continue
    set GOROOT ($go env GOROOT)
    contains -- $GOROOT $install_goroots && continue
    set -a install_goroots $GOROOT
  end
  string collect $install_goroots
end

function __goversion_installed_versions -d 'Print version info for Go installations'
  for goroot in $argv
    set goversion (string replace -r '^go version ' '' ($goroot/bin/go version))
    echo $goversion '  ' (prettypath $goroot)
  end
end

function __goversion_select_option -a prompt
  set options $argv[2..-1]
  while true
    read -P "$prompt: " val
    if contains -- $val $options
      echo $val
      return
    end
  end
end

function __goversion_prompt_yn -a prompt
  read -P "$prompt (y/n) " -n1 reply
  string match -q -i 'y' $reply
  return $status
end

function goversion -d 'Manage Go versions'
  for dep in git jq wget curl
    if ! command -q $dep
      set -a missing $dep
    end
  end
  if count $missing > /dev/null
    echo "Required dependencies: $missing" >&2
    exit 1
  end

  # See https://github.com/golang/website/blob/master/internal/dl/server.go
  set releases (__goversion_releases)
  set versions (echo $releases | __goversion_versions)

  set_color -o green
  echo 'Stable versions:'
  set_color normal
  echo $releases | __goversion_versions_stable true | column
  echo

  set_color -o red
  echo 'Unstable versions:'
  set_color normal
  echo $releases | __goversion_versions_stable false | column
  echo

  set_color -o blue
  echo 'Installed versions:'
  set_color normal
  set install_goroots (__goversion_installed_goroots)
  __goversion_installed_versions $install_goroots

  set install_gopaths
  for goroot in $install_goroots
    set GOPATH ($goroot/bin/go env GOPATH)
    for path in $GOPATH
      contains -- $path $install_gopaths || set -a install_gopaths $path
    end
  end
  echo

  set goversion (__goversion_select_option 'Select version' $versions)
  echo

  echo 'Binaries:'
  set binaries (echo -n $releases |
      jq --arg goversion $goversion \
        -r '.[] | select(.version == $goversion) | .files | .[].filename')
  string collect $binaries | column

  set binary (__goversion_select_option 'Select binary' $binaries)

  echo 'Fetching binary...'
  wget -nc -q --show-progress "https://golang.org/dl/$binary"
  echo

  if __goversion_prompt_yn 'Install extra versions?'
    echo 'Versions:'
    set versions (__goversion_extra)
    string collect $versions | sort -Vr | column
    echo

    while true
      set go (__goversion_select_option 'Select version' $versions)
      go install golang.org/dl/$go
      eval $go download
      eval $go version
    end
  end
end
