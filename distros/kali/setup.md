# Kali Linux setup

1. Login to default user `kali` with password `kali`.
2. Change password with `passwd`.
3. Logout, then copy your SSH key to `authorized_keys`:

    ```sh
    logout
    ssh-copy-id -i ~/.ssh/raspi_id_rsa blackberryi
    ssh blackberryi
    ```

4. Update package index and upgrade packages:

    ```sh
    sudo apt update && sudo apt upgrade
    ```

5. Install fish and set it as the user shell (takes effect after signing
   in again):

    ```sh
    sudo apt -y install fish
    chsh -s $(which fish)
    logout
    ssh blackberryi
    ```

6. Set timezone:

    ```sh
    sudo timedatectl set-timezone America/Los_Angeles
    ```

7. Set locale:

    ```sh
    localectl status
    locale
    locale -a
    sudo sed -i.bak -r 's/^#\s*(en_US\.UTF-8 UTF-8)/\1/' /etc/locale.gen
    sudo sed -i -r 's/^#\s*(de_DE\.UTF-8 UTF-8)/\1/' /etc/locale.gen
    sudo locale-gen
    sudo localectl set-locale LANG=en_US.UTF-8
    ```

8. Set hostname:

    ```sh
    hostnamectl set-hostname blackberryi
    hostnamectl set-hostname --pretty 'Blackberry i'
    echo '127.0.0.1 blackberryi' | sudo tee -a /etc/hosts
    sudo sed -i'' -r 's/^(127.0.0.1\s+)kali(\s+localhost)/\1blackberryi\2/' /etc/hosts
    ```

9. Setup git.

    1. Configure global settings:

        ```sh
        git config --global user.email 'name@example.com'
        git config --global user.name 'Full Name'
        git config --global pull.rebase false  # merge (the default strategy)
        ```

    2. Generate an SSH key and add it to your SSH config:

        ```sh
        ssh-keygen -t rsa -b 8192 -a 100 -f ~/.ssh/github_id_rsa
        echo 'Host *
          IdentitiesOnly yes

        Host github.com
          User git
          IdentityFile ~/.ssh/github_id_rsa' >> ~/.ssh/config
        ```

    3. Add the SSH key to your GitHub account at
       https://github.com/settings/keys.

10. Install dotfiles:

    ```sh
    mkdir -p ~/dev/github.com/andrewarchi
    cd ~/dev/github.com/andrewarchi
    git clone git@github.com:andrewarchi/config
    cd config
    rm ~/.bashrc ~/.bash_profile
    ./install.fish
    sudo apt -y install neofetch screenfetch
    ```

11. Install Go and other tools:

    ```sh
    sudo apt-get install golang aptitude
    ```

12. Start X session:

    ```sh
    startx
    ```

13. Install optional metapackages (see list at
    https://tools.kali.org/kali-metapackages):

    ```sh
    sudo apt install -y kali-linux-large
    ```

14. Install PowerShell Core.

    1. Install `powershell` package:

        ```sh
        apt -y install powershell
        pwsh
        ```

    2. If that fails, install manually (see instructions at
       https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-linux?view=powershell-7#raspbian):

        ```sh
        # Install libunwind8 and libssl1.0 (not libssl1.0-dev)
        sudo apt-get install '^libssl1.0.[0-9]$' libunwind8 -y

        wget https://github.com/PowerShell/PowerShell/releases/download/v7.0.2/powershell-7.0.2-linux-arm64.tar.gz
        sudo mkdir /usr/local/powershell
        sudo tar xvf powershell-7.0.2-linux-arm64.tar.gz -C /usr/local/powershell
        sudo ln -s /usr/local/powershell/pwsh /usr/local/bin/pwsh
        ```
