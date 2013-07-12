#! /bin/bash

USAGE="Usage: `basename $0` --server-ip IPA_SERVER_IP_ADDRESS"

if [ -n "$1" ] ; then
    if [ "$1" = "--server-ip" ] ; then
	SERVER_IP=$2
    else
	echo "Invalid option: $1"
	echo $USAGE
	exit 1
    fi
else
    echo "Please provde IPA server hostname"
    echo $USAGE
    exit 1
fi

source config/config.sh
source lib/env-setup.sh

echo "Installing custom built IPA rpms ..."
cd $GIT_DIR/dist/rpms
sudo yum -y localinstall freeipa-client* freeipa-python* freeipa-admintools*

echo "Setting up /etc/resolv.conf ..."
sudo echo "nameserver $SERVER_IP" | cat - /etc/resolv.conf > /tmp/out && sudo mv -f /tmp/out /etc/resolv.conf

echo "Installing IPA client ..."
sudo ipa-client-install --enable-dns-updates -p admin -w $PASSWORD -U
