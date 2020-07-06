function github_new_repo -d 'Create a new GitHub repository'
  argparse --min-args=1 --max-args=1 'h/help' 'd/desc=' 'o/org=' 'p/private' -- $argv
  or return

  if test -n "$_flag_help"
    echo 'Create a new GitHub repository'
    echo
    echo "    $_argparse_cmd [options] repo_name"
    echo
    echo '        -d, --desc        Repo description'
    echo '        -o, --org name    Organization under which to create the repo'
    echo '        -p, --private     Private visibility'
    echo '        -t, --token       GitHub API token with repo scope'
    echo
    echo 'A GitHub API token must be specified, either with the environment'
    echo 'variable GITHUB_API_TOKEN or with --token. A personal access token can'
    echo 'generated at https://github.com/settings/tokens. To create a public'
    echo 'repository, the token must have public_repo scope or repo scope. To'
    echo 'a private repository, it must have repo scope.'
    return
  end

  if test -z "$GITHUB_API_TOKEN"
    if test -z "$_flag_token"
      echo 'A GitHub API token must be specified, either with the environment' >&2
      echo 'variable GITHUB_API_TOKEN or with --token. A personal access token can' >&2
      echo 'generated at https://github.com/settings/tokens. To create a public' >&2
      echo 'repository, the token must have public_repo scope or repo scope. To' >&2
      echo 'a private repository, it must have repo scope.' >&2
      return 1
    end
    set GITHUB_API_TOKEN $_flag_token
  end

  set repo $argv[1]
  if test -z "$repo"
    echo 'Repo name cannot be empty' >&2
    return 1
  end

  if ! command -q jq
    echo 'jq must be installed' >&2
    return 1
  end

  # API reference:
  # https://developer.github.com/v3/repos/#create-a-repository-for-the-authenticated-user
  # https://developer.github.com/v3/repos/#create-an-organization-repository

  set data (jq -n -c \
    --arg name "$repo" \
    --arg description "$_flag_desc" \
    --arg private "$_flag_private" \
    '{"name": $name, "description": $description, "private": ($private != "")}')

  set url https://api.github.com/user/repos
  if test -n "$_flag_org"
    set url https://api.github.com/orgs/$_flag_org/repos
  end

  curl -H "Authorization: token $GITHUB_API_TOKEN" -d $data $url
end
