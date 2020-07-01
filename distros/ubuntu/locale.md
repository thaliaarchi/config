# Set locale

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
