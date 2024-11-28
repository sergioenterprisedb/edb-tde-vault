#!/bin/bash

. /vagrant_config/config.sh

cd /vagrant_scripts/certificates/
# Print the code
secret=$(python3 create_certificates.py)
echo $secret > /tmp/secret

# Test in /tmp/test.bin file
printf secret | python3 /vagrant_scripts/certificates/edb_tde_kmip_client.py encrypt \
--out-file=/tmp/test.bin \
--pykmip-config-file=/vagrant_scripts/certificates/pykmip.conf \
--key-uid=$secret \
--variant=pykmip
