#! /bin/bash 

source ipa-config.sh

echo "Enabling updates-testing repo ..."
sudo yum-config-manager --enable updates-testing > /dev/null

echo "Updating system packages ..."
sudo yum -y update

echo "Installing python-nose ..."
sudo yum -y install python-nose

echo "Configuring testing environment ..."
mkdir -p ~/.ipa

if [ ! -f ~/.ipa/default.conf ] ; then
    ln -s /etc/ipa/default.conf ~/.ipa/
fi

if [ `grep wait_for_attr=True /etc/ipa/default.conf | wc -l` -eq 0 ] ; then
    sudo sh -c 'echo "wait_for_attr=True" >> /etc/ipa/default.conf'
fi

cd $GIT_DIR
rm -f tests/test_xmlrpc/service.crt
echo "$PASSWORD" | kinit admin

echo "Running tests ... "
make
./make-testcert
./make-test
