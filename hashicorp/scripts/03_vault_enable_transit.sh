#!/bin/bash

. /vagrant_config/config.sh

# Enable transit
vault secrets enable transit

# Enable kmip-pki
vault secrets enable -path=kmip-pki pki
# Enable kmip
vault secrets enable kmip
# Write kmip scope
vault write -f kmip/scope/edb
# Write role
vault write kmip/scope/edb/role/admin operation_all=true
# Read role
vault read kmip/scope/edb/role/admin

# Setup a root certificate for the PKI
# This creates a self-signed root CA certificate with a long TTL (10 years in this case).
vault write -field=certificate kmip-pki/root/generate/internal \
  common_name="KMIP Root CA" \
  ttl=87600h > ca.pem

# https://developer.hashicorp.com/vault/tutorials/enterprise/kmip-engine
vault write kmip/config listen_addrs=0.0.0.0:5696 \
      tls_ca_key_type="rsa" \
      tls_ca_key_bits=2048

# Generate certificates
vault write -f -field=certificate \ kmip/scope/edb/role/admin/credential/generate > /vagrant_scripts/certificates/kmip-cert.pem

cd /vagrant_scripts/certificates
./split_file.sh 
mv cert_part1.pem key.pem
mv cert_part2.pem cert.pem
cat cert_part3.pem cert_part4.pem > ca.pem
rm -f cert_part3.pem cert_part4.pem
cd -

