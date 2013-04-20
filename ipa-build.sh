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

echo "Installing selinux-policy-devel ..."
sudo yum install selinux-policy-devel --enablerepo=updates-testing -y

echo "Updating git working tree..."
cd $GIT_DIR
git reset --hard origin/master
git pull

if [ -n "$PATCH" ] ; then
    echo "Applying patch $PATCH  ..."
    git am $PATCH
fi

echo "Cleaning git working tree ..."
git clean -dfx

echo "Building rpms ..."
make rpms
