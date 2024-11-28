#!/bin/bash

. /vagrant_config/config.sh

cd /tmp
curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}${VAULT_ENTERPRISE}/vault_${VAULT_VERSION}${VAULT_ENTERPRISE}_linux_amd64.zip
unzip vault_${VAULT_VERSION}${VAULT_ENTERPRISE}_linux_amd64.zip
sudo mv vault /usr/bin/

cat >> /home/vagrant/.bash_profile <<EOF
# Vault
export VAULT_ADDR="http://127.0.0.1:8200"
EOF
source ~/.bash_profile

# # Install KMIP
sudo dnf -y install edb-tde-kmip-client
sudo yum -y install python3-pip
pip install setuptools

# Install PyKMIP with root
# cd /tmp/
# wget https://files.pythonhosted.org/packages/f8/3e/e343bb9c2feb2a793affd052cb0da62326a021457a07d59251f771b523e7/PyKMIP-0.10.0.tar.gz
# tar -xvf PyKMIP-0.10.0.tar.gz
# cd /tmp/PyKMIP-0.10.0/
# python3 setup.py install

sudo sh /vagrant_scripts/install_PyKMIP.sh
