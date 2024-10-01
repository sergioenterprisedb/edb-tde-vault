#!/bin/bash

# bat installation
# https://www.linode.com/docs/guides/how-to-install-and-use-the-bat-command-on-linux/
cd /tmp
curl -o bat.zip -L https://github.com/sharkdp/bat/releases/download/v0.18.2/bat-v0.18.2-x86_64-unknown-linux-musl.tar.gz
tar -xvzf bat.zip
sudo mv bat-v0.18.2-x86_64-unknown-linux-musl /usr/local/bat
cd -
# bat installation

#cat >> ~/.bash_profile <<EOF
#alias bat="/usr/local/bat/bat -pp"
#EOF
#source ~/.bash_profile

#enterprisedb
#sudo bash -c 'cat >> /var/lib/edb/.bash_profile <<EOF
#alias bat="/usr/local/bat/bat -pp"
#EOF'
