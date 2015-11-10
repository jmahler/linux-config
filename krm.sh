#!/bin/sh

#
# Given a pattern, remove the files from
# /boot and /lib/modules/
#
#  ./krm.sh *3.18.0-rc6+
#

sudo rm -fr /boot/$1
sudo rm -fr /lib/modules/$1
