#!/bin/bash

# Colors
export N=$(tput sgr0)
export R=$(tput setaf 1)
export G=$(tput setaf 2)
export bold=$(tput bold)
export credentials=$(cat /vagrant/.edbtoken)
export LC_ALL=en_US.UTF-8

# IPs
export VAULT_IP=192.168.1.12

# Postgres
export pgversion=16

#
# Vault configuration
#

# Engine: kmip|transit
vault_engine='kmip'
export VAULT_ENTERPRISE="+ent"
export VAULT_VERSION=1.18.1
export VAULT_ADDR="http://${VAULT_IP}:8200"

if [ "$vault_engine" == "transit" ]; then
  # TDE config with transit engine
  export PGDATAKEYWRAPCMD='base64 | vault write -field=ciphertext transit/encrypt/pg-tde-master-1 plaintext=- > %p'
  export PGDATAKEYUNWRAPCMD='vault write -field=plaintext transit/decrypt/pg-tde-master-1 ciphertext=- < %p | base64 -d'
elif [ "$vault_engine" == "kmip" ]; then
  # KMIP Vault config
  export kmip_path="/vagrant_scripts/certificates"
  export secret=$(cat /tmp/secret)
  export PGDATAKEYWRAPCMD='python3 ${kmip_path}/edb_tde_kmip_client.py encrypt --pykmip-config-file=${kmip_path}/pykmip.conf --key-uid=${secret} --out-file=%p --variant=pykmip'
  export PGDATAKEYUNWRAPCMD='python3 ${kmip_path}/edb_tde_kmip_client.py decrypt --pykmip-config-file=${kmip_path}/pykmip.conf --key-uid=${secret} --in-file=%p --variant=pykmip'
else
# TDE config without vault
  export PGDATAKEYWRAPCMD='openssl enc -e -aes256 -pass pass:ok -out %p'
  export PGDATAKEYUNWRAPCMD='openssl enc -d -aes256 -pass pass:ok -in %p'
fi
