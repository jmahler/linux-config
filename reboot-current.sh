#!/bin/sh

#
# Run this from a linux kernel build directory to
# tell Grub to boot the last built kernel next time.
#
#  ~/linux-next$ make -j2
#  ~/linux-next$ sudo make modules_install install
#  ~/linux-next$ ./reboot-current.sh
#  ~/linux-next$ sudo shutdown -r now
# 
# The GRUB_DEFAULT must be set to 'saved' for this to work.
#
#  (/etc/default/grub)
#  ...
#  GRUB_DEFAULT=saved
#  ...
#
# And be sure to run update-grub if the configuration
# is changed.
#

KERNELRELEASE=$(make kernelrelease) || exit 1

MENUENTRY='1>'$(grep $KERNELRELEASE /boot/grub/grub.cfg |
				grep menuentry |
				head -n 1 |
				awk -F \' '{print $2}')

sudo grub-reboot "$MENUENTRY" || exit 1
