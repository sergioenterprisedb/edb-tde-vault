# HashiCorp Vault with EDB Postgres Advanced Server (TDE)
HashiCorp Vault and EDB integration patterns.
This demo will allow you to deploy 3 VM's:
- HashiCorp Vault or HashiCorp Vault Enterprise
- EDB Postgres Advanced Server 16
- PostgreSQL 16

# Prerequisites
- VirtualBox
- Vagrant
- EDB account to download EDB Postgres Advanced Server (EPAS)
- HashiCorp license to download HashiCorp Vault Enterprise if you decide to use KMIP engine (default engine)
# Deploying HashiCorp Vault
There is 1 VM containing HashiCorp Vault [here](./hashicorp/README.md).

# Deploying Postgres
There are 2 VM's [here](./edb/README.md):
- EDB Postgres Advanced Server 16
- PostgreSQL 16
