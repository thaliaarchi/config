# Ubuntu login MOTD

To disable any of the default MOTD sections, remove its executable bit.

```sh
sudo chmod -x /etc/update-motd.d/10-help-text
```

Disable news:

```sh
sudo sed -i 's/ENABLED=1/ENABLED=0/' /etc/default/motd-news
```
