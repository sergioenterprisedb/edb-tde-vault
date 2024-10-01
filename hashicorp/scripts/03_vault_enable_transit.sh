#!/bin/bash

. /vagrant_config/config.sh

# Enable transit
vault secrets enable transit
#Success! Enabled the transit secrets engine at: transit/

