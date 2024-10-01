#!/bin/bash

psql postgres > /tmp/tde_file.log <<EOF
-- Create table
drop table if exists users;
create table users (userid int, user_name varchar(10), password varchar(100));
insert into users values (1, 'sergio', 'Thisismypassword01#');

create table companies (
  id serial primary key,
  url varchar(255),
  name varchar(255),
  description text,
  last_update date);

insert into companies (url, name, description, last_update) 
values (
'https://www.enterprisedb.com',
'EnterpriseDB',
'Demo TDE with EDB Postgres Advanced Server (EPAS) and HashiCorp Vault',
now()
);
insert into companies (url, name, description, last_update) 
values (
'https://www.hashicorp.com',
'HashiCorp',
'Demo TDE with EDB Postgres Advanced Server (EPAS) and HashiCorp Vault',
now()
);

-- Select table
select * from users;

-- Flush dirty pages
checkpoint;

select pg_relation_filepath('users');

-- Check Encryption activated
select data_encryption_version from pg_control_init;
EOF

export tde_file=`grep base /tmp/tde_file.log`
export tde_pgdata=`echo $PGDATA`
echo "tde_pgdata: $tde_pgdata"
echo "tde_file: $tde_file"
export tde_file=`echo $tde_file | tr -s ' '`
echo "Press ENTER to continue"
read
hexdump -C ${PGDATA}/${tde_file}
