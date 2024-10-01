#!/bin/bash

# Colors
export N=$(tput sgr0)
export R=$(tput setaf 1)
export G=$(tput setaf 2)
export bold=$(tput bold)
export credentials=$(cat /vagrant/.edbtoken)
export LC_ALL=en_US.UTF-8

# IPs
#export PG1IP=192.168.1.11
#export PG2IP=192.168.1.12
export VAULT_IP=192.168.1.12

# Postgres
export pgversion=16

# TDE config without vault
#export PGDATAKEYWRAPCMD='openssl enc -e -aes256 -pass pass:ok -out %p'
#export PGDATAKEYUNWRAPCMD='openssl enc -d -aes256 -pass pass:ok -in %p'

# TDE config with Vault
export VAULT_VERSION=1.17.5
export VAULT_ADDR="http://${VAULT_IP}:8200"
export PGDATAKEYWRAPCMD='base64 | vault write -field=ciphertext transit/encrypt/pg-tde-master-1 plaintext=- > %p'
export PGDATAKEYUNWRAPCMD='vault write -field=plaintext transit/decrypt/pg-tde-master-1 ciphertext=- < %p | base64 -d'
