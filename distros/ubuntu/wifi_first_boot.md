# Setting up WiFi before first boot

Find and edit the `network-config` file in the root of the Raspberry
Pi's boot partition:

```sh
cd /Volumes/system-boot
cp -p network-config{,.bak}
vim network-config
```

Uncomment `wifis` section and add your network SSID and password. If the
SSID contains spaces, enclose it in quotes. Make sure to escape
backslashes in quoted strings for YAML.

```
# This file contains a netplan-compatible configuration which cloud-init
# will apply on first-boot. Please refer to the cloud-init documentation and
# the netplan reference for full details:
#
# https://cloudinit.readthedocs.io/
# https://netplan.io/reference
#
# Some additional examples are commented out below

version: 2
ethernets:
  eth0:
    dhcp4: true
    optional: true
wifis:
  wlan0:
    dhcp4: true
    optional: true
    access-points:
      myhomewifi:
        password: "S3kr1t"
      myworkwifi:
        password: "correct battery horse staple"
#      workssid:
#        auth:
#          key-management: eap
#          method: peap
#          identity: "me@example.com"
#          password: "passw0rd"
#          ca-certificate: /etc/my_ca.pem
```
