#!/bin/sh

#
# Perform all the steps necessary to update and install
# a linux-next kernel.
#

set -x

git checkout master || exit 1

git fetch origin || exit 1

git reset --hard origin/master || exit 1

git checkout jm || exit 1

read -r -p "reset 'jm' to master and destroy local changes? [y/N] " response
case $response in
	[yY])
		;;
	*)
		echo "stop"
		exit;
		;;
esac

git reset --hard master || exit 1

git am *.patch || exit 1

make oldconfig || exit 1

cp .config ~/linux-config/acer_c720/config-next || exit 1

make -j2 || exit 1

sudo make modules_install install || exit 1
