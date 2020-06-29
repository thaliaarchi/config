# Arch Linux setup

1. Sign into the alarm account with the default password `alarm` and
   change its password:

    ```sh
    ssh alarm@192.168.1.46
    passwd
    ```

2. Switch to root with the default password `root` and change its
   password:

    ```sh
    su -
    passwd
    ```

3. Enable remote SSH sign-in for root and restart sshd:

    ```sh
    sed -i.bak 's/^#PermitRootLogin prohibit-password$/PermitRootLogin yes/g' /etc/ssh/sshd_config
    systemctl restart sshd
    ```

4. Logout from root and alarm, then SSH directly into root:

    ```sh
    logout
    logout
    ssh root@192.168.1.46
    ```

5. Set the static and pretty hostname and add the hostname to `hosts`:

    ```sh
    hostnamectl set-hostname marionberryphi
    hostnamectl set-hostname --pretty 'Marionberry Phi'
    echo '127.0.0.1 marionberryphi' | sudo tee -a /etc/hosts
    ```

6. Rename alarm user:

    ```sh
    killall -u alarm
    id alarm
    usermod -l andrew alarm
    groupmod -n andrew alarm
    usermod -d /home/andrew -m andrew
    usermod -c 'Andrew Archibald' andrew
    id andrew
    ```

7. Allow the wheel group to execute any command:

    ```sh
    groups andrew
    pacman -S sudo vim
    EDITOR=vim visudo
    ```

    It should look like this:

    ```sh
    less /etc/sudoers
    ...
    ## Uncomment to allow members of the group wheel to execute any command
    %wheel ALL=(ALL) ALL
    ...
    ```

8. Disable SSH sign-in for root and logout:

    ```sh
    mv /etc/ssh/sshd_config{.bak,}
    systemctl restart sshd
    logout
    ```

9. Generate and copy an SSH key:

    ```sh
    ssh-keygen -t rsa -b 8192 -a 100 -f ~/.ssh/id_raspi
    ssh-copy-id -i ~/.ssh/id_raspi andrew@192.168.1.46
    ```

10. Add an entry to your SSH config:

    ```sh
    echo 'Host marionberryphi
        HostName 192.168.1.38
        User andrew
        IdentityFile ~/.ssh/id_raspi
        IdentitiesOnly yes' >> ~/.ssh/config
    ```

11. Sign in and set change shell to fish:

    ```sh
    ssh marionberryphi
    sudo pacman -S fish
    chsh -s $(which fish)
    logout
    ssh marionberryphi
    ```

12. Install configuration:

    ```sh
    sudo pacman -S git wget
    mkdir -p ~/dev/github.com/andrewarchi
    cd ~/dev/github.com/andrewarchi
    git clone https://github.com/andrewarchi/config
    cd config
    rm ~/.bashrc ~/.bash_profile
    ./install.fish
    ```

13. Set the timezone to your location:

    ```sh
    timedatectl list-timezones
    sudo timedatectl set-timezone America/Los_Angeles
    sudo timedatectl set-timezone America/Denver
    sudo timedatectl set-timezone Europe/Berlin
    ```

14. Set the locale.

    1. Display the currently set locale and list all enabled locales:

        ```sh
        locale
        locale -a
        localectl status
        ```

    2. Uncomment the desired locales in `/etc/locale.gen` and generate
       the locales:

        ```sh
        sudo sed -i.bak -r 's/^#\s*(en_US\.UTF-8 UTF-8)/\1/' /etc/locale.gen
        sudo sed -i -r 's/^#\s*(de_DE\.UTF-8 UTF-8)/\1/' /etc/locale.gen
        sudo locale-gen
        ```

    3. Set the system locale:

        ```sh
        sudo localectl set-locale LANG=en_US.UTF-8
        ```

    4. Login again for locale changes to take effect.

15. Install other packages:

    ```sh
    sudo pacman -S man tmux screen
    ```
