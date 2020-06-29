# git setup

```sh
git config --global user.email "you@example.com"
git config --global user.name "Your Name"
```

## GitHub SSH key

Generate an SSH key and add it to your SSH config:

```sh
ssh-keygen -t rsa -b 8192 -a 100 -f ~/.ssh/id_github
echo 'Host *
  IdentitiesOnly yes

Host github.com
  User git
  IdentityFile ~/.ssh/id_github' >> ~/.ssh/config
```

Add the SSH key to your GitHub account at
https://github.com/settings/keys.
