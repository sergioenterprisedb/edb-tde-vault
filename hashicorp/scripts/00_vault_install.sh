#!/bin/bash

. /vagrant_config/config.sh

cd /tmp
curl -O https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip
unzip vault_${VAULT_VERSION}_linux_amd64.zip
sudo mv vault /usr/bin/

cat >> /home/vagrant/.bash_profile <<EOF
# Vault
export VAULT_ADDR="http://127.0.0.1:8200"
EOF
source ~/.bash_profile