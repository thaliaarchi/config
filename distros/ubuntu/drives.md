# Drives and file systems

## exFAT file system

Install support for exFAT:

```sh
sudo apt install exfat-fuse exfat-utils
```

## f3

f3 (Fight Flash Fraud) is a tool that tests flash drive and SD card
capacity and performance to see if the claimed specifications are
accurate.

f3probe is the fastest drive test and suitable for large disks because
it only writes what's necessary to test the drive. It operates directly
on the (unmounted) block device and needs to be run as a privileged
user:

```sh
sudo f3probe --destructive --time-ops /dev/sda
```

Source: https://github.com/AltraMayor/f3
