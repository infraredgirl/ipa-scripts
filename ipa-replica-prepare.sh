#! /bin/bash

USAGE="Usage: `basename $0` --replica IPA_REPLICA_HOSTNAME"

if [ -n "$1" ] ; then
    if [ "$1" = "--replica" ] ; then
	REPLICA=$2
    else
	echo "Invalid option: $1"
	echo $USAGE
	exit 1
    fi
else
    echo "Please provde IPA replica hostname"
    echo $USAGE
    exit 1
fi

source config/config.sh
source lib/env-setup.sh

echo "Preparing replication info file ..."
sudo ipa-replica-prepare $REPLICA -p $PASSWORD

echo "Copying replication info file to replica ..."
sudo scp -o StrictHostKeyChecking=no -i ~/.ssh/id_rsa /var/lib/ipa/replica-info-$REPLICA.gpg $USER@$REPLICA:

echo "Restarting ntpd ..."
sudo systemctl restart ntpd.service
