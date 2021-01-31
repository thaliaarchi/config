# Pi-hole

Flash `2021-01-11-raspios-buster-armhf-lite.zip` onto a microSD card.

Create an empty `ssh` file in `/boot` with `touch /boot/ssh`.

Create `wpa_supplicant.conf` in `/boot`, replacing `SSID` and `PASSWORD`
with your WiFi network credentials:

```
country=US
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
  ssid="SSID"
  scan_ssid=1
  psk="PASSWORD"
  key_mgmt=WPA-PSK
}
```

In the interactive wizard, I chose these settings:

- Upstream DNS: OpenDNS (ECS, DNSSEC)
- Your static IPv4 address: 10.10.10.10/8
- Your static IPv4 gateway: 10.10.10.10
- IPv4 address: 10.10.10.10/8
- IPv6 address:
- Web Interface On
- Web Server On
- Logging On

There appears to be an IPv6 issue. Perhaps it's because I changed the IP
from the default.

```
Unable to find IPv6 ULA/GUA address, IPv6 adblocking will not be enabled
```
