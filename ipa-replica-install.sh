#! /bin/bash

USAGE="Usage: `basename $0` --master IPA_MASTER_HOSTNAME"

if [ -n "$1" ] ; then
    if [ "$1" = "--master" ] ; then
	MASTER=$2
    else
	echo "Invalid option: $1"
	echo $USAGE
	exit 1
    fi
else
    echo "Please provde IPA master hostname"
    echo $USAGE
    exit 1
fi

source config/config.sh
source lib/env-setup.sh

echo "Installing custom built IPA rpms ..."
sudo yum -y localinstall $GIT_DIR/dist/rpms/*.rpm

echo "Syncing time with master ..."
sudo ntpdate $MASTER

echo "Installing replica ..."
sudo ipa-replica-install ~/replica-info-`hostname`.gpg -p $PASSWORD -w $PASSWORD -U
