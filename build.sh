#!/bin/sh

# Build the kernel and send an email when it is done.

set -x

yes "" | make oldconfig || exit 1

make -j2 || exit 1

sudo make modules_install install || exit 1

mail -s 'kernel build done' "$EMAIL" < /dev/null
