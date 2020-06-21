## [GRUB](https://www.gnu.org/software/grub/) script to boot various Linux live CD/DVD images

### Usage:

0. Your target device, like a USB flash drive, should be formatted as FAT(32).
	- That's because (most) UEFI/EFI supports only FAT(32),
	if you target BIOS systems only, you can use ext4/btrfs/exFAT/NTFS, or whatever grub supports.
1. Install GRUB(2, not legacy) on your target device:
	(assuming your USB drive is `/dev/sdb` and mounted on `/mnt/usb/`.)
	- For UEFI/EFI x64 systems: `grub-install --target=x86_64-efi --boot-directory=/mnt/usb/boot /dev/sdb`
	- For BIOS systems: `grub-install --target=i386-pc --boot-directory=/mnt/usb/boot /dev/sdb`
	- You can install both.
	- Alternative way for UEFI/EFI x64 systems:
		1. Build `bootx64.efi`:
			```
			grub-mkimage -o bootx64.efi -O x86_64-efi -p /boot/grub \
				boot linux linux16 chain normal configfile \
				part_gpt part_msdos fat iso9660 udf \
				test true keystatus loopback regexp probe \
				efi_gop efi_uga all_video gfxterm font \
				echo read help ls cat halt reboot
			```
		2. Copy `bootx64.efi` to `(USB)/efi/boot/`.
2. Put [`grub.cfg` from this repository](https://raw.githubusercontent.com/Jimmy-Z/grub-iso-boot/master/grub.cfg) in `(USB)/boot/grub/`.
3. Put image files in `(USB)/boot/iso/`.
4. Boot from this device, that depends on your system/motherboard vendor.
	- On some modern PCs, you can press F12 to select from a list of boot devices during POST.
	- Configure BIOS/EFI to boot from this device.
	- [More detailed document from Debian](https://www.debian.org/releases/stable/amd64/ch03s06.en.html#boot-dev-select-x86).

### Currently supporting:

* [Debian Live](https://www.debian.org/devel/debian-live/)
	- [non-free images](https://cdimage.debian.org/cdimage/unofficial/non-free/images-including-firmware/current-live/)
	are recommended for better hardware support, notably (wireless) network adapters.
	- Debian Installer images like
	[netinst image](https://www.debian.org/distrib/netinst)
	or [CD/DVD image](https://www.debian.org/CD/)
	are not supported, read the Extra section below.
* And some Debian derivatives like:
	- [Kali](https://www.kali.org/)
	- [Grml](https://grml.org/)
	- [GParted Live](http://gparted.org/livecd.php)
	- [Clonezilla Live](https://clonezilla.org/clonezilla-live.php)
* [Ubuntu](http://www.ubuntu.com/),
* And some Ubuntu derivatives like:
	- [lubuntu](http://lubuntu.net/)
	- [Mint](http://www.linuxmint.com/)
	- [elementary OS](https://elementary.io/)
* [Arch](https://www.archlinux.org/)
* And some Arch derivatives like:
	- [Manjaro](https://manjaro.github.io/)
	- [Antergos](http://antergos.com/)
* [Fedora Live](https://getfedora.org/)
	- Only tested on workstation live image.
* [CentOS](https://www.centos.org/)
	- Both the live and installer(like Minimal) images are supported.
* [openSUSE](https://www.opensuse.org/)
	- There is no live image, the installer image is supported though.
* [PCLinuxOS](http://www.pclinuxos.com/)

### Some explanation:

GRUB is not able to do image boot on its own, the image boot procedure can be _loosely_ described like this:

1. GRUB loop mount the image, load the Linux kernel and initrd from it.
	- the [loopback](https://www.gnu.org/software/grub/manual/grub/grub.html#loopback) command.
2. GRUB boot the kernel, passing the initrd along with some parameters including the location of the image.
3. Some script in initrd loop mount the image and continue the rest of the boot procedure.

So, if the initrd itself doesn't implement this mechanism, it won't work(hence the unsupported section).

And in step 2, different distributions tends to use different parameter schemes,
this is where this script kicks in:
it tries to determine the image vendor and feeds appropriate parameters accordingly.

### Comparing with other methods:

The official way to make a bootable live USB drive suggested by most distributions is dd the image,
those images are cleverly made FAT/ISO9660 hybrids so they work that way, depends on almost nothing,
simpler to setup but also monogamy, destroys all data on the drive and the rest of the drive is not usable.

There are tools to put multiple distributions on a single USB drive,
but mostly they are Windows only and they extract the image contents to the USB drive so they are slower,
and needs to run the tool every time you want to add/remove a image.

Using this script, once the initial setup is done, you can simply copy/delete the image file,
compatibility is not 100% but considerably usable.

### Extra:

* Debian Installer, initrd in the image doesn't support loop,
but Debian provided an [alternative initrd](https://www.debian.org/releases/stable/amd64/ch04s02.en.html),
copy `vmlinuz` and `initrd` from the `hd-media` directory
to `(USB)/boot/debian-installer/amd64/`
and your choice of installer image
([like this](http://cdimage.debian.org/cdimage/unofficial/non-free/image-including-firmware/current/))
to `(USB)/` (not `(USB)/boot/iso/`).
	* Do not mix arch, for example you should use amd64 image with amd64 kernel and initrd.
	* Do not use live images.
	* Official document about this method is
	[here](https://www.debian.org/releases/stable/amd64/ch04s03.en.html#usb-copy-flexible).
* EFI binary chainloading, simply copy to `(USB)/efi/*/bootx64.efi`, useful examples like:
	* [UEFI shell](https://github.com/tianocore/edk2/releases/), get the `ShellBinPkg.zip`,
		UEFI in most consumer boards doesn't come with shell, could be handy sometimes.
	* [memtest86](https://www.memtest86.com/), you need to extract the disk image.

### Notable unsupported
* Proxmox VE, it's based on Debian but the boot script is their own, too bad this is one of my favorite distributions.
* Mageia, doesn't have loop mount in initrd.
* LXLE, it is actually a lubuntu derivative, while lubuntu works like other Ubuntu derivatives, it doesn't, strangely.
