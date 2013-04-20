#! /bin/bash

echo "Updating system packages ..."
sudo yum update --enablerepo=updates-testing -y

echo "Setting SELinux to permissive mode ..."
sudo setenforce 0

echo "Turning off the firewall ..."
sudo systemctl stop firewalld.service
sudo systemctl disable firewalld.service
sudo iptables -F
