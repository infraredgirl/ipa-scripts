#! /bin/bash

echo "Updating system packages ..."
sudo yum clean all
sudo yum update --enablerepo=updates-testing -y

echo "Setting SELinux to permissive mode ..."
sudo setenforce 0

echo "Turning off the firewall ..."
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo iptables -F

IP=`ip addr show eth0 | grep "inet " | cut -d ' ' -f6 | cut -d '/' -f1`
if [ `grep $IP /etc/hosts | wc -l` -eq 0 ] ; then
    echo "Configuring /etc/hosts ..."
    sudo IP=$IP sh -c 'echo "$IP    `hostname`" >> /etc/hosts'
fi

echo "Setting environment variables ..."
DOMAIN=`dnsdomainname`
REALM=`dnsdomainname | tr '[:lower:]' '[:upper:]'`

source lib/current-workarounds.sh
