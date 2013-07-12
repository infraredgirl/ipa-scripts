#! /bin/bash

USAGE="Usage: `basename $0` --patch /path/to/patch/to/apply"

if [ -n "$1" ] ; then
    if [ "$1" = "--patch" ] ; then
	PATCH=$2
    else
	echo "Invalid option: $1"
	echo $USAGE
	exit 1
    fi

    if [ -z "$PATCH" ] ; then
	echo "Please provide the path to patch"
	echo $USAGE
	exit 1
    fi

    if [ ! -f "$PATCH" ] ; then
	echo "Invalid file: $2"
	echo $USAGE
	exit 1
    fi

fi

source config/config.sh
source lib/env-setup.sh

echo "Installing build dependencies ..."
cd $GIT_DIR
make
sudo yum-builddep freeipa.spec --enablerepo=updates-testing -y

echo "Updating git working tree..."
git checkout master
git reset --hard origin/master
git pull

if [ -n "$PATCH" ] ; then
    echo "Applying patch $PATCH  ..."
    git am $PATCH
else
    # If there are RPMs from current master already built, don't do anything
    HASH=`git log --pretty=format:"%h" -1`
    if [ -f $GIT_DIR/dist/rpms/freeipa-client-*$HASH*.rpm  ]; then
	echo "RPMs already present, exiting."
	exit 0
    fi
fi

echo "Cleaning git working tree ..."
git clean -dfx

echo "Building rpms ..."
make rpms
