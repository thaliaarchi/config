# Install Arch Linux on a Raspberry Pi 4

Instructions adapted from
https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4

1. Identify the device name of the SD card. It will be in the form of
   `sdX` (i.e. `sda` or `sdb`).

    ```sh
    lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
    ```

2. Start `fdisk` to partition the SD card:

    ```sh
    fdisk /dev/sdX
    ```

3. At the `fdisk` prompt, delete old partitions and create two new ones:

    1. `o` to clear partitions
    2. `p` to list partitions. There should be no partitions left
    3. `n` to create the first partition:
        1. `p` for primary
        2. `1` for the first partition on the drive
        3. ENTER to accept the default first sector
        4. `+100M` for the last sector
    4. `t`, then `c` to set the first partition to type `W95 FAT32 (LBA)`
    5. `n` to create the second partition:
        1. `p` for primary
        2. `2` for the second partition on the drive
        3. ENTER to accept the default first sector
        4. ENTER to accept the default last sector
    6. `w` to write the partition table and exit

4. Create and mount the FAT filesystem:

    ```sh
    mkfs.vfat /dev/sdX1
    mkdir boot
    mount /dev/sdX1 boot
    ```

5. Create and mount the ext4 filesystem:

    ```sh
    mkfs.ext4 /dev/sdX2
    mkdir root
    mount /dev/sdX2 root
    ```

6. Download and extract the root filesystem (as root, not via sudo):

    ```sh
    wget http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-4-latest.tar.gz
    bsdtar -xpf ArchLinuxARM-rpi-4-latest.tar.gz -C root
    sync
    ```

7. Move boot files to the first partition:

    ```sh
    mv root/boot/* boot
    ```

8. Unmount the two partitions:

    ```sh
    umount boot root
    ```

9. Insert the SD card into the Raspberry Pi, connect ethernet, and apply
   5V power.

10. Use the serial console or SSH to the IP address given to the board
    by your router.

    - Login as the default user alarm with the password alarm.
    - The default root password is root.

11. Initialize the pacman keyring and populate the Arch Linux ARM
    [package signing](https://archlinuxarm.org/about/package-signing)
    keys:

    ```sh
    pacman-key --init
    pacman-key --populate archlinuxarm
    ```
