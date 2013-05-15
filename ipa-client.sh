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

source config/config.sh
source lib/env-setup.sh

DOMAIN=`echo $SERVER | cut -d '.' -f2-`

echo "Installing custom built IPA rpms ..."
cd $GIT_DIR/dist/rpms
sudo yum -y localinstall freeipa-client* freeipa-python* freeipa-admintools*

echo "Installing IPA client ..."
sudo ipa-client-install --server=$SERVER --domain=$DOMAIN --enable-dns-updates -p admin -w $PASSWORD -U
