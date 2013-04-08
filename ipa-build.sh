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

source ipa-config.sh

echo "Disabling updates-testing repo ..."
sudo sed -i 's/enabled=1/enabled=0/g' /etc/yum.repos.d/fedora-updates-testing.repo

echo "Updating system packages ..."
sudo yum -y update

echo "Installing selinux-policy-devel ..."
sudo yum -y install selinux-policy-devel

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
