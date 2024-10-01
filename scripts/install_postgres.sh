#!/bin/bash

. /vagrant_config/config.sh

# Configure repo
curl -1sLf "https://downloads.enterprisedb.com/${credentials}/enterprise/setup.rpm.sh" | sudo -E bash

# Install PostgreSQL
sudo dnf -y install postgresql${pgversion}-server postgresql${pgversion}-contrib

# Configure .bash_profile
cat >> ~/.bash_profile <<EOF
export PATH=$PATH:/usr/pgsql-${pgversion}/bin
alias stop="pg_ctl stop"
alias start="pg_ctl start"
alias bat="/usr/local/bat/bat -pp"
EOF
source ~/.bash_profile

cat >> /var/lib/pgsql/.bash_profile <<EOF
alias stop="pg_ctl stop"
alias start="pg_ctl start"
alias bat="/usr/local/bat/bat -pp"
EOF

# Print message
printf "\n"
printf "${G}${bold}Next steps:${N}\n"
printf "${G}"
printf "\n"
printf "  - Connect to VM postgres\n"
printf "  - Connect as postgres\n"
printf "  - Install Postgres cluster\n"
printf "  - Test TDE (no TDE installed here)\n"
printf "\n"
printf "${bold}Scripts${N}\n"
printf "${G}"
printf "\n"
printf "vagrant ssh postgres\n"
printf "sudo su - postgres\n"
printf "cd /vagrant_scripts\n"
printf "./install_postgres_cluster.sh\n"
printf "./test_tde.sh\n"
printf "\n${N}"
