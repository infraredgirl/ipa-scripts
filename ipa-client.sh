#! /bin/bash

USAGE="Usage: `basename $0` --server IPA_SERVER_HOSTNAME"

if [ -n "$1" ] ; then
    if [ "$1" = "--server" ] ; then
	SERVER=$2
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

source ipa-config.sh

DOMAIN=`echo $SERVER | cut -d '.' -f2-`
IP=`ip addr show eth0 | grep "inet " | cut -d ' ' -f6 | cut -d '/' -f1`

if [ `grep $IP /etc/hosts | wc -l` -eq 0 ] ; then
    echo "Configuring /etc/hosts ..."
    sudo IP=$IP sh -c 'echo "$IP    `hostname`" >> /etc/hosts'
fi

echo "Enabling updates-testing repo ..."
sudo yum-config-manager --enable updates-testing > /dev/null

echo "Updating system packages ..."
sudo yum -y update

echo "Installing custom built IPA rpms ..."
cd $GIT_DIR/dist/rpms
sudo yum -y localinstall freeipa-client* freeipa-python* freeipa-admintools*

echo "Setting SELinux to permissive mode ..."
sudo setenforce 0

echo "Installing IPA client ..."
sudo ipa-client-install --server=$SERVER --domain=$DOMAIN --enable-dns-updates -p admin -w $PASSWORD -U
