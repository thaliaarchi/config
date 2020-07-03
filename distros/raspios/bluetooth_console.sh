#!/bin/bash -e

# Adapted from https://github.com/DrRowland/RPi-Bluetooth-Console/blob/master/setup.sh
# Read more at https://hacks.mozilla.org/2017/02/headless-raspberry-pi-configuration-over-bluetooth/

echo 'Raspberry Pi Bluetooth console'
echo 'Run once, reboot, and do not run again.'
echo

if ! command -v bluetoothctl > /dev/null 2>&1; then
  echo 'bluetoothctl must be installed. Run:'
  echo
  echo '    sudo apt install bluez'
  exit 2
fi

sudo bluetoothctl <<EOF > /dev/null
discoverable on
EOF

# Enable Bluetooth services
sudo sed -i: 's|^Exec.*toothd$|\
ExecStart=/usr/lib/bluetooth/bluetoothd -C\
ExecStartPost=/usr/bin/sdptool add SP\
ExecStartPost=/bin/hciconfig hci0 piscan\
|g' /lib/systemd/system/bluetooth.service

# Enable the Bluetooth serial port from systemctl
sudo cat <<EOF | sudo tee /etc/systemd/system/rfcomm.service > /dev/null
[Unit]
Description=RFCOMM service
After=bluetooth.service
Requires=bluetooth.service

[Service]
ExecStart=/usr/bin/rfcomm watch hci0 1 getty rfcomm0 115200 vt100 -a pi

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable rfcomm

echo
echo 'Now reboot, pair and connect.'
echo 'In macOS, pair, then run:'
echo
echo '    screen /dev/cu.raspberrypi-SerialPort 115200'
