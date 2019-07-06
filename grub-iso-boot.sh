#!/bin/sh
# Code inspired by and dervied from https://github.com/Jimmy-Z/grub-iso-boot

if [ "$#" -ne 1 ]
then
    echo ""
    echo "GRUB ISO Boot";
    echo ""
    echo "This script allows your drive to boot multiple Linux ISOs"
    echo "After running this script, add your ISOs to <DEVICE_MOUNTPOINT>/boot/iso"
    echo "The ISOs will then be detected when you boot from the drive"
    echo ""
    echo "Usage: $0 /dev/sdx"
    echo ""
    exit 1
fi

set -x;

USB_DEVICE=$1; # pass this in from args

sudo umount "$USB_DEVICE"*;
sudo parted -s $USB_DEVICE -- mklabel msdos;
sudo parted -s $USB_DEVICE -- mkpart primary 0% 100%;
sudo mkfs.vfat "$USB_DEVICE"1 -n "ISOTester";
sudo partprobe;
sudo mount "$USB_DEVICE"1 /mnt; 
sudo mkdir -p /mnt/EFI/BOOT;
sudo grub-mkimage -o /mnt/EFI/BOOT/bootx64.efi -O x86_64-efi -p /boot/grub \
	boot linux linux16 normal configfile \
	part_gpt part_msdos fat iso9660 udf \
	test keystatus loopback regexp probe \
	efi_gop efi_uga all_video gfxterm font \
	echo read help ls cat halt reboot;
sudo grub-install --target=i386-pc --boot-directory=/mnt/boot $USB_DEVICE;
sudo wget https://raw.githubusercontent.com/Jimmy-Z/grub-iso-boot/master/grub.cfg -O /mnt/boot/grub/grub.cfg;
sudo mkdir -p /mnt/boot/iso; 

