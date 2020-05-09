# Failed attempt to use Fira Code

```sh
sudo apt install fonts-firacode -y
sudo apt install fontconfig -y
fc-list
sudo apt install fbterm -y
sudo setcap 'cap_sys_tty_config+ep' $(command -v fbterm)
sudo usermod -aG video andrew
```
