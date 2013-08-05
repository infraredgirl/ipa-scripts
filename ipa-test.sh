#! /bin/bash 

source config/config.sh
source lib/env-setup.sh

echo "Installing packages needed for testing FreeIPA ..."
sudo yum install python-nose PyYAML -y
sudo pip install selenium

echo "Configuring testing environment ..."
mkdir -p ~/.ipa
rm -f ~/.ipa/default.conf
ln -s /etc/ipa/default.conf ~/.ipa/
sudo sh -c 'echo "wait_for_attr=True" >> /etc/ipa/default.conf'
rm -f $GIT_DIR/ipatests/test_xmlrpc/service.crt
echo "$PASSWORD" | kinit admin

cp -f config/ui_test.template.conf ~/.ipa/ui_test.conf
sed -i "s/ipa_password: .*/ipa_password: $PASSWORD/g" ~/.ipa/ui_test.conf
sed -i "s/ipa_server: .*/ipa_server: `hostname`/g" ~/.ipa/ui_test.conf
sed -i "s/ipa_ip: .*/ipa_ip: $IP/g" ~/.ipa/ui_test.conf
sed -i "s/ipa_domain: .*/ipa_domain: $DOMAIN/g" ~/.ipa/ui_test.conf
sed -i "s/ipa_realm: .*/ipa_realm: $REALM/g" ~/.ipa/ui_test.conf

echo "Running tests ... "
cd $GIT_DIR
make
./make-testcert
./make-test
