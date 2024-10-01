#!/bin/bash

. /vagrant_config/config.sh

# Create key
vault write -f transit/keys/pg-tde-master-1
