# Install Go

1. Visit https://golang.org/dl/
2. Find the latest release for Linux ARM64 (ARMv8)
3. Run:

   ```sh
   wget https://dl.google.com/go/go$VERSION.linux-arm64.tar.gz
   tar -C /usr/local -xzf go$VERSION.linux-arm64.tar.gz
    ```

4. Add `/usr/local/go/bin` to `PATH`:

   - For fish:

     ```sh
     echo 'set PATH $PATH /usr/local/go/bin' >> ~/.config/fish/config.fish
     ```

   - For bash:

     ```sh
     echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
     ```
