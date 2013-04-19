#! /bin/bash

source ipa-config.sh

IP=`ip addr show eth0 | grep "inet " | cut -d ' ' -f6 | cut -d '/' -f1`
REALM=`hostname | cut -d '.' -f2- | tr '[:lower:]' '[:upper:]'`

if [ `grep $IP /etc/hosts | wc -l` -eq 0 ] ; then
    echo "Configuring /etc/hosts ..."
    sudo IP=$IP sh -c 'echo "$IP    `hostname`" >> /etc/hosts'
fi

echo "Enabling updates-testing repo ..."
sudo yum-config-manager --enable updates-testing > /dev/null

echo "Updating system packages ..."
sudo yum -y update

echo "Installing custom built IPA rpms ..."
sudo yum -y localinstall $GIT_DIR/dist/rpms/*.rpm

echo "Setting SELinux to permissive mode ..."
sudo setenforce 0

echo "Installing IPA server ..."
sudo ipa-server-install -a $PASSWORD -p $PASSWORD --setup-dns --no-forwarders -r $REALM -U

echo "Configuring firewalld ..."
sudo firewall-cmd --add-port  80/tcp
sudo firewall-cmd --add-port 443/tcp
sudo firewall-cmd --add-port 389/tcp
sudo firewall-cmd --add-port 636/tcp
sudo firewall-cmd --add-port  88/tcp
sudo firewall-cmd --add-port 464/tcp
sudo firewall-cmd --add-port  53/tcp
sudo firewall-cmd --add-port  88/udp
sudo firewall-cmd --add-port 464/udp
sudo firewall-cmd --add-port  53/udp
sudo firewall-cmd --add-port 123/udp
