#!/bin/sh

# Build the kernel and send an email when it is done.

#set -x

yes "" | make oldconfig || exit 1

make -j2 || exit 1

sudo make modules_install install || exit 1

if [ ! -x "$(which mail)" ]; then
	echo "mail command not found.";
	echo "Do you need to install mailutils?"
	echo "  apt-get install mailutils"
else
	RELEASE=$(make kernelrelease)
	HOST=$(hostname)
	SUBJ="$HOST: kernel $RELEASE built"
	BODY="Build of kernel $RELEASE on $HOST complete."

	echo "$BODY" | mail -s "$SUBJ" "$EMAIL"
fi
