function __goversion_query_release_json -d 'Query Go releases as JSON'
  curl -sS 'https://golang.org/dl/?mode=json&include=all' | string collect
end
function __goversion_versions -d 'Extract versions from releases'
  jq -r '.[].version'
end
function __goversion_versions_stable -a stable -d 'Extract versions with given stability from releases'
  jq -r ".[] | select(.stable == $stable) | .version"
end
function __goversion_version_binaries -a goversion -d 'Extract list of binaries for version from releases'
  jq --arg goversion "$goversion" \
     -r '.[] | select(.version == $goversion) | .files | .[].filename'
end

# Extra versions: https://golang.org/doc/install#extra_versions
function __goversion_query_extra -d 'Query extra Go versions'
  if ! command -q go
    echo 'go must be in PATH to install extra Go versions' >&2
    return 1
  end
  go get -d golang.org/dl/gotip
  set GOPATH (go env GOPATH)
  git -C "$GOPATH[1]/src/golang.org/dl" ls-tree -d --name-only HEAD |
      command grep '^go' | sort -Vr
end

function __goversion_installed_path -d 'List Go versions installed in PATH'
  # To match older version tags:
  #   release\.r\d{1,2}(?:\.\d{1,2})?
  #   weekly(?:\.20\d\d-\d\d-\d\d(?:\.\d{1,2})?)?
  string match -r -e '\bgo(?:\d{1,2}(?:\.\d{1,2}(?:\.\d{1,2})?)?(?:(?:beta|rc)\d{1,2})?)?$' $PATH/go*
end
function __goversion_installed_extra -d 'List installed extra Go versions'
  echo ~/sdk/*/bin/go
end
function __goversion_installed_brew -d 'List installed Homebrew Go versions'
  if command -q brew
    # `brew list --versions golang` is too slow.
    # Instead directly list versions in cellar directory.
    echo (brew --prefix)/Cellar/go/*/libexec/bin/go
  end
end

function __goversion_install_primary -a binary -d 'Install primary Go version'
  echo 'Fetching binary...'
  wget -nc -q --show-progress "https://golang.org/dl/$binary"
end
function __goversion_install_extra -a goversion -d 'Install extra Go version'
  go install golang.org/dl/$goversion
  eval $goversion download
  eval $goversion version
end

function __goversion_tags -d 'Query GitHub release tags'
  curl -sS -H 'Accept: application/vnd.github.v3+json' https://api.github.com/repos/golang/go/git/refs/tags |
      jq -r 'reverse | .[] | .ref | select(test("refs/tags/go.+")) | ltrimstr("refs/tags/")'
end

function __goversion_installed_goroots -d 'List paths to installed Go versions'
  set -l install_paths
  set -a install_paths (__goversion_installed_path)
  set -a install_paths (__goversion_installed_brew)
  set -a install_paths (__goversion_installed_extra)

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
  for GOROOT in $argv
    set goversion (string replace -r '^go version ' '' ($GOROOT/bin/go version))
    echo $goversion '  ' (prettypath $GOROOT)
  end
end

function __goversion_select_option -a prompt
  set options $argv[2..-1]
  while true
    read -P "$prompt: " val
    if contains -- "$val" $options
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

function __goversion_help
  echo 'Usage: goversion' >&2
  return 1
end

function goversion -d 'Manage Go versions'
  if argparse -is 'h/help' -- $argv && test -n "$_flag_help"
    __goversion_help
    return
  end

  set -l missing
  for dep in git jq wget curl
    command -q $dep || set -a missing $dep
  end
  if count $missing > /dev/null
    echo "Required dependencies: $missing" >&2
    exit 1
  end

  # See https://github.com/golang/website/blob/master/internal/dl/server.go
  set releases (__goversion_query_release_json)
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
  for GOROOT in $install_goroots
    set GOPATH ($GOROOT/bin/go env GOPATH)
    for path in $GOPATH
      contains -- $path $install_gopaths || set -a install_gopaths $path
    end
  end
  echo

  set goversion (__goversion_select_option 'Select version' $versions)
  echo

  echo 'Binaries:'
  set binaries (echo $releases | __goversion_version_binaries $goversion)
  string collect $binaries | column

  __goversion_install_primary (__goversion_select_option 'Select binary' $binaries)
  echo

  if __goversion_prompt_yn 'Install extra versions?'
    echo 'Versions:'
    set extra_versions (__goversion_query_extra)
    string collect $extra_versions | column
    echo
    while true
      __goversion_install_extra (__goversion_select_option 'Select version' $extra_versions)
    end
  end
end
