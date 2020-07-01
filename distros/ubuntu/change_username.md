# Change username

Set password for root account:

```sh
sudo passwd root
```

Sign in as root account and run:

```sh
killall -u oldname
id oldname
usermod -l newname oldname
groupmod -n newname oldname
usermod -d /home/newname -m newname
usermod -c "Full Name" newname
id newname
```
