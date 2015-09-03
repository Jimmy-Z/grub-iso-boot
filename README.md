# grub-iso-boot
[GRUB](https://www.gnu.org/software/grub/) script to boot various Linux live CD/DVD ISO imagess

### usage:

1. install GRUB(2, not legacy) on your target device, like an USB flash drive
2. put this grub.cfg in /boot/grub/
3. put images files in /boot/iso/
4. change your BIOS settings to boot from this device

### currently supporting:

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
* [Fedora](https://getfedora.org/), and it's server counter part [CentOS Live](https://www.centos.org/)
* [openSUSE](https://www.opensuse.org/)

### some explanation:

GRUB is not able to do image boot on its own, the image boot procedure can be _loosely_ described like this:

1. GRUB loop mount(the loopback command) the image, load the Linux kernel and initrd from it.
2. GRUB boot the kernel, passing the initrd along with some parameters including the location of the image.
3. some script in initrd loop mount the image and continue the rest of boot procedure.

so, if the initrd itself doesn't implement this mechanism, it won't work.

and in step 2, different distributions tends to use different parameter schemes,
this is where this script kicks in:
it tries to determine the image type and feeds appropriate parameters accordingly.

this is not my idea, [super grub2 disk](http://www.supergrubdisk.org/super-grub2-disk/) does this too,
but this script support more distributions.

### notable unsupported:

* Debian Installer
* Mageia
* LXLE

