#!/bin/sh

# Update this local repository with upstream.

set -x

if ls *.patch 1>/dev/null 2>&1; then
	echo "Please remove any local patches before updating."
	exit 1
fi

# switch to our working branch
git checkout jm || exit 1

# export all patches in the working branch (not in master)
git format-patch master || exit 1

# update master with upstream
git checkout master || exit 1
git fetch origin master || exit 1
git reset --hard origin/master || exit 1

# switch to the working branch merge in upstream changes
git checkout jm || exit 1
git reset --hard master || exit 1

# Apply any patches that were exported from the working branch.
# If it fails here, it might be because the patch was added to
# upstream.
if ls *.patch 1>/dev/null 2>&1; then
	git am *.patch || exit 1
fi

# update the config using all the default options
yes "" | make oldconfig || exit 1

# save our updated config
if [ -e ~/linux-config/current/config-next ]; then
	cp .config ~/linux-config/current/config-next || exit 1
else
	echo "The 'current' directory does not exist, skipping."
	echo "Perhaps a link needs to be added?"
	echo "  cd ~/linux-config"
	echo "  ln -s your-config-name current"
fi

# remove any of the exported patches
if ls *.patch 1>/dev/null 2>&1; then
	rm -f *.patch || exit 1
fi

#./build.sh || exit 1
