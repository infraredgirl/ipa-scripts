#! /bin/bash 

source config/config.sh
source lib/env-setup.sh

echo "Installing python-nose and selenium ..."
sudo yum install python-nose --enablerepo=updates-testing -y
sudo pip install selenium

echo "Configuring testing environment ..."
mkdir -p ~/.ipa
rm -f ~/.ipa/default.conf
ln -s /etc/ipa/default.conf ~/.ipa/
sudo sh -c 'echo "wait_for_attr=True" >> /etc/ipa/default.conf'
rm -f $GIT_DIR/ipatests/test_xmlrpc/service.crt
echo "$PASSWORD" | kinit admin

echo "Running tests ... "
cd $GIT_DIR
make
./make-testcert
./make-test
