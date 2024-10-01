#!/bin/bash

if [ `whoami` != "enterprisedb" ]
then
  printf "You must execute this as enterprisedb\n"
  exit
fi

# Config
. /vagrant_config/config.sh

# TDE variables
# Check PGDATAKEYWRAPCMD and PGDATAKEYUNWRAPCMD variables in /vagrant_config/config.sh file.

# Login vault
vault login root

# PostgreSQL Initdb
/usr/edb/as${pgversion}/bin/initdb --data-encryption=256 -D /var/lib/edb/as${pgversion}/data 

# Start instance
/usr/edb/as${pgversion}/bin/pg_ctl start
