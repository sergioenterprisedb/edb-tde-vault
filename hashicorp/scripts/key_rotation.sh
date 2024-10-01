#!/bin/bash

# Connect to vault
. /vagrant_config/config.sh
vault login root

# Create key
#vault secrets enable transit
vault write -f transit/keys/pg-tde-master-2

# Decrypt
vault write -field=plaintext transit/decrypt/pg-tde-master-1 ciphertext=- < key.bin | base64 --decode > key.bin.decrypted

# Encrypt
vault write -field=ciphertext transit/encrypt/pg-tde-master-2 plaintext="$(base64 < key.bin.decrypted)" > key.bin.new

# Move
mv key.bin.new key.bin

# Change postgresql.conf. Replace transit/keys/pg-tde-master-1 by transit/keys/pg-tde-master-2



