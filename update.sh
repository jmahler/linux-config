#!/bin/sh

#
# Perform all the steps necessary to update and install
# a linux-next kernel.
#

set -x

if ls *.patch 1>/dev/null 2>&1; then
	echo "Please remove any local patches before updating."
	exit 1
fi

git checkout jm || exit 1

git format-patch master || exit 1

git checkout master || exit 1

git fetch origin master || exit 1

git reset --hard origin/master || exit 1

git checkout jm || exit 1

git reset --hard master || exit 1

if ls *.patch 1>/dev/null 2>&1; then
	git am *.patch || exit 1
fi

yes "" | make oldconfig || exit 1

if [ -e ~/linux-config/current/config-next ]; then
	cp .config ~/linux-config/current/config-next || exit 1
else
	echo "The 'current' directory does not exist, skipping."
	echo "Perhaps a link needs to be added?"
	echo "  cd ~/linux-config"
	echo "  ln -s your-config-name current"
fi

make -j2 || exit 1

sudo make modules_install install || exit 1

mail -s 'kernel build done' "$EMAIL" < /dev/null
