function goversion --description='Manage Go versions'
  for dep in git jq curl wget
    if ! command -q $dep
      set -a missing $dep
    end
  end
  if count $missing > /dev/null
    echo "Required dependencies: $missing" >&2
    exit 1
  end

  function select_option
    set prompt $argv[1]
    set options $argv[2..-1]
    while true
      read -P "$prompt: " val
      if contains -- $val $options
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
  set releases (curl -sS 'https://golang.org/dl/?mode=json&include=all' | string collect)
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
  set install_paths

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

  set install_goroots
  set install_gopaths
  for go in $install_paths
    test -x "$go" || continue
    set goroot ($go env GOROOT)
    contains -- $goroot $install_goroots && continue
    set -a install_goroots $goroot

    set goversion (string replace -r '^go version ' '' ($go version))
    echo $goversion '  ' (prettypath $goroot)

    set gopath ($go env GOPATH)
    for path in $gopath
      contains -- $path $install_paths || set -a install_gopaths $path
    end
  end
  echo

  set goversion (select_option 'Select version' $versions)
  echo

  echo 'Binaries:'
  set binaries (echo -n $releases |
      jq --arg goversion $goversion \
        -r '.[] | select(.version == $goversion) | .files | .[].filename')
  string collect $binaries | column

  set binary (select_option 'Select binary' $binaries)

  echo 'Fetching binary...'
  wget -nc -q --show-progress "https://golang.org/dl/$binary"
  echo

  if prompt_yn 'Install extra versions?'
    go get -d golang.org/dl/gotip
    set GOPATH (go env GOPATH)
    set versions (git -C "$GOPATH[1]/src/golang.org/dl" ls-tree -d --name-only HEAD | grep '^go')

    echo 'Versions:'
    string collect $versions | sort -Vr | column
    echo

    while true
      set go (select_option 'Select version' $versions)
      go install golang.org/dl/$go
      eval $go download
      eval $go version
    end
  end

  functions --erase select_option
  functions --erase prompt_yn
end
