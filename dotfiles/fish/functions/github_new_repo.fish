set -l USAGE \
'Create a new GitHub repository

    github_new_repo [OPTIONS] REPO_NAME

        -d, --desc        Repo description
        -o, --org name    Organization under which to create the repo
        -p, --private     Private visibility
        -t, --token       GitHub API token with repo scope'

set -l TOKEN_USAGE \
'A GitHub API token must be specified, either with the environment
variable GITHUB_API_TOKEN or with --token. A personal access token can
generated at https://github.com/settings/tokens. To create a public
repository, the token must have public_repo scope or repo scope. To
a private repository, it must have repo scope.'

function github_new_repo -d 'Create a new GitHub repository'
  argparse --max-args=1 'h/help' 'd/desc=' 'o/org=' 'p/private' -- $argv
  or return

  if test -n "$_flag_help"
    echo $USAGE
    echo
    echo $TOKEN_USAGE
    return
  end

  set -l repo $argv[1]
  if ! count $argv > /dev/null || test -z "$repo"
    echo 'Repo name cannot be empty' >&2
    return 1
  end

  if test -z "$GITHUB_API_TOKEN"
    if test -z "$_flag_token"
      echo $TOKEN_USAGE >&2
      return 1
    end
    set GITHUB_API_TOKEN $_flag_token
  end

  if ! command -q jq
    echo 'jq must be installed' >&2
    return 1
  end

  # API reference:
  # https://developer.github.com/v3/repos/#create-a-repository-for-the-authenticated-user
  # https://developer.github.com/v3/repos/#create-an-organization-repository

  set -l data (jq --null-input --compact-output \
    --arg name "$repo" \
    --arg description "$_flag_desc" \
    --arg private "$_flag_private" \
    '{"name": $name, "description": $description, "private": ($private != "")}')

  set -l url https://api.github.com/user/repos
  if test -n "$_flag_org"
    set url https://api.github.com/orgs/$_flag_org/repos
  end

  curl -H "Authorization: token $GITHUB_API_TOKEN" -d $data $url
end
