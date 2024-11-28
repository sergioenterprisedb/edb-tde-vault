#!/bin/bash

. /vagrant_config/config.sh

vault server -dev -dev-root-token-id=root -dev-listen-address="0.0.0.0:8200" &
#vault server -config /vagrant/config/vault-server.hcl
#vault server -dev -dev-root-token-id=root
