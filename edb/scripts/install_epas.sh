#!/bin/bash

. /vagrant_config/config.sh

# Configure repo
curl -1sLf "https://downloads.enterprisedb.com/${credentials}/enterprise/setup.rpm.sh" | sudo -E bash

# Install EPAS
sudo dnf -y install edb-as16-server

# Configure .bash_profile
#cat >> ~/.bash_profile <<EOF
cat >> /var/lib/edb/.bash_profile <<EOF
export PATH=$PATH:/usr/edb/as${pgversion}/bin
alias stop="pg_ctl stop"
alias start="pg_ctl start"
alias bat="/usr/local/bat/bat -pp"

# Vault
export VAULT_ADDR="http://${VAULT_IP}:8200"

# Psotgres
export PGDATABASE=postgres
EOF
source ~/.bash_profile

# Print message
printf "\n"
printf "${G}${bold}Next steps:${N}\n"
printf "${G}"
printf "\n"
printf "  - Connect to the VM epas\n"
printf "  - Connect as enterprisedb\n"
printf "  - Install HashiCorp Vault\n"
printf "  - Install EPAS cluster (with TDE activated)\n"
printf "  - Test TDE\n"
printf "\n"
printf "${bold}Scripts${N}\n"
printf "${G}"
printf "\n"
printf "vagrant ssh epas\n"

# Install vault
printf ". /vagrant_scripts/vault_install.sh\n"

# Install EPAS
printf "sudo su - enterprisedb\n"
printf "cd /vagrant_scripts\n"
printf "\n"

printf "./install_epas_cluster.sh\n"
printf "./test_tde.sh\n"
printf "\n${N}"
