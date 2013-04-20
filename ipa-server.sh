#! /bin/bash

source config/config.sh
source lib/env-setup.sh

IP=`ip addr show eth0 | grep "inet " | cut -d ' ' -f6 | cut -d '/' -f1`
REALM=`hostname | cut -d '.' -f2- | tr '[:lower:]' '[:upper:]'`

if [ `grep $IP /etc/hosts | wc -l` -eq 0 ] ; then
    echo "Configuring /etc/hosts ..."
    sudo IP=$IP sh -c 'echo "$IP    `hostname`" >> /etc/hosts'
fi

echo "Installing custom built IPA rpms ..."
sudo yum -y localinstall $GIT_DIR/dist/rpms/*.rpm

echo "Installing IPA server ..."
sudo ipa-server-install -a $PASSWORD -p $PASSWORD --setup-dns --no-forwarders -r $REALM -U
