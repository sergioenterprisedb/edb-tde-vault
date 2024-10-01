#!/bin/bash

if [ `whoami` != "postgres" ]
then
  printf "You must execute this as postgres\n"
  exit
fi

# Config
. /vagrant_config/config.sh

# PostgreSQL Initdb
/usr/pgsql-${pgversion}/bin/initdb -D /var/lib/pgsql/${pgversion}/data 

# Start instance
/usr/pgsql-${pgversion}/bin/pg_ctl start
