# Disk speed test

Adapted from https://www.shellhacks.com/disk-speed-test-read-write-hdd-ssd-perfomance-linux/.

## Write speed

```sh
$ sync; dd if=/dev/zero of=tempfile bs=1M count=1024; sync
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 31.4418 s, 34.2 MB/s
```

## Read speed

Before measuring read speed, the cache should be cleared, otherwise read
speeds would be reported as higher than actual because `tempfile` is
cached.

```sh
$ sudo /sbin/sysctl -w vm.drop_caches=3
vm.drop_caches = 3
$ dd if=tempfile of=/dev/null bs=1M count=1024
1024+0 records in
1024+0 records out
1073741824 bytes (1.1 GB, 1.0 GiB) copied, 23.4078 s, 45.9 MB/s
```

## Read speed with hdparm

hdparm can view and set hard drive hardware parameters as well as
benchmark drive speed.

```sh
$ sudo apt install hdparm
$ lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
$ sudo hdparm -Tt /dev/mmcblk0
/dev/mmcblk0:
 Timing cached reads:   1852 MB in  2.00 seconds = 926.36 MB/sec
 HDIO_DRIVE_CMD(identify) failed: Invalid argument
 Timing buffered disk reads: 132 MB in  3.02 seconds =  43.75 MB/sec
```
