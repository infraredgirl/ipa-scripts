#! /bin/bash

source config/config.sh
source lib/env-setup.sh

REALM=`dnsdomainname | tr '[:lower:]' '[:upper:]'`

echo "Installing custom built IPA rpms ..."
sudo yum -y localinstall $GIT_DIR/dist/rpms/*.rpm

echo "Installing IPA server ..."
sudo ipa-server-install -a $PASSWORD -p $PASSWORD --setup-dns --no-forwarders -r $REALM -U
