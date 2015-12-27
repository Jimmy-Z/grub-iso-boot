# grub-iso-boot
[GRUB](https://www.gnu.org/software/grub/) script to boot various Linux live CD/DVD images

### usage:

1. Install GRUB(2, not legacy) on your target device, like an USB flash drive
	- for UEFI/EFI x64 systems:
		1. build bootx64.efi:

				grub-mkimage -o bootx64.efi -O x86_64-efi -p /boot/grub \
					boot linux linux16 chain \
					elf keylayouts minicmd extcmd normal configfile gzio cpio \
					efi_gop efi_uga all_video gfxterm gettext font \
					ls cat eval test cmp date datetime true time read \
					memdisk cpuid lspci halt reboot sleep\
					search search_fs_file search_fs_uuid search_label \
					loopback regexp probe \
					lvm msdospart part_msdos part_gpt \
					ext2 fat exfat ntfs iso9660 udf btrfs

		2. copy bootx64.efi to (USB)/efi/boot
	- for BIOS systems: `grub-install --target=i386-pc --boot-directory=/mnt/usb/boot /dev/sdb`
assuming your USB drive is /dev/sdb and mounted on /mnt/usb
2. Put this grub.cfg in (USB)/boot/grub/
3. Put images files in (USB)/boot/iso/
4. Change your BIOS settings to boot from this device

### Currently supporting:

* [Debian Live](http://live.debian.net/), and some derivatives like:
	- [GParted Live](http://gparted.org/livecd.php)
	- [Kali](https://www.kali.org/)
	- [Grml](https://grml.org/)
* [Ubuntu](http://www.ubuntu.com/), and some derivatives like:
	- [lubuntu](http://lubuntu.net/)
	- [Mint](http://www.linuxmint.com/)
	- [elementary OS](https://elementary.io/)
* [Arch](https://www.archlinux.org/), and some derivatives like:
	- [Antergos](http://antergos.com/)
	- [Manjaro](https://manjaro.github.io/)
* [Fedora](https://getfedora.org/), and it's server counterpart [CentOS Live](https://www.centos.org/)
* ~~[openSUSE](https://www.opensuse.org/)~~, since Leap/42.1, openSUSE does not provide Live images anymore.
* [PCLinuxOS](http://www.pclinuxos.com/)

### Some explanation:

GRUB is not able to do image boot on its own, the image boot procedure can be _loosely_ described like this:

1. GRUB loop mount(the loopback command) the image, load the Linux kernel and initrd from it.
2. GRUB boot the kernel, passing the initrd along with some parameters including the location of the image.
3. Some script in initrd loop mount the image and continue the rest of boot procedure.

So, if the initrd itself doesn't implement this mechanism, it won't work(hence the unsupported section).

And in step 2, different distributions tends to use different parameter schemes,
this is where this script kicks in:
it tries to determine the image vendor and feeds appropriate parameters accordingly.

This is not my idea, [super grub2 disk](http://www.supergrubdisk.org/super-grub2-disk/) does this too,
but this script support more distributions.

### Comparing with other methods:

Most Linux live images are hybrid FAT/ISO9660 so they can be written to a USB drive directly using dd and voila it's bootable, it's simpler if you want only one image, but destroys all data on the drive and the rest of the drive is not usable.

There are tools to put multiple distributions on a single USB drive, but mostly they are Windows only and they extract the image contents to the USB drive so they are slower, and needs to run the tool every time you want to add/remove a image.

Using this script, once the initial setup is done, you can simply copy/delete the image file, compatibility is not 100% but considerably usable.

### Notable unsupported:

* Debian Installer, funny the live initrd supports loop mount but installer initrd doesn't.
* Mageia, this is the only distribution that doesn't have loop mount in initrd on [distrowatch](http://distrowatch.com/) top 10 list.
* LXLE, this is actually a lubuntu derivative, while lubuntu works like other Ubuntu derivatives, I guess there are some breakage while ... uh ... derivating?

