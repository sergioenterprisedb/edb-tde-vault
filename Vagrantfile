# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

params = YAML.load_file './config/vagrant.yaml'

var_box        = "generic/rocky9"

# EPAS
epas_vm_name       = params['epas']['vm_name']
epas_mem_size      = params['epas']['mem_size']
epas_cpus          = params['epas']['cpus']
epas_public_ip     = params['epas']['public_ip']
epas_port          = params['epas']['port']

# POSTGRES
postgres_vm_name   = params['postgres']['vm_name']
postgres_mem_size  = params['postgres']['mem_size']
postgres_cpus      = params['postgres']['cpus']
postgres_public_ip = params['postgres']['public_ip']
postgres_port      = params['postgres']['port']

Vagrant.configure("2") do |config|
  config.vm.provision :hosts, :sync_hosts => true
  #config.vm.network "forwarded_port", guest: 8200, host: 8200
  #config.vm.network "forwarded_port", guest: 5444, host: 5444
  #config.vm.network "private_network", ip: epas_public_ip, name: "HostOnly", virtualbox__intnet: true
  # EPAS
  config.vm.define "epas" do |epas|
    epas.vm.box = var_box
    epas.vm.hostname= epas_vm_name
    epas.vm.network "forwarded_port", guest: 5444, host: 5444
    #epas.vm.network "forwarded_port", guest: 8200, host: 8200
    epas.vm.network "private_network", ip: epas_public_ip, name: "HostOnly", virtualbox__intnet: true
    epas.vm.provider "virtualbox" do |vmepas|
      vmepas.memory = epas_mem_size
      vmepas.cpus = epas_cpus
      vmepas.name = epas_vm_name
    end
    epas.vm.synced_folder ".", "/vagrant"
    epas.vm.synced_folder "./scripts", "/vagrant_scripts"
    epas.vm.synced_folder "./config", "/vagrant_config"
    epas.vm.provision "shell", inline: <<-SHELL
      sudo sh /vagrant_scripts/firewall.sh
      sudo sh /vagrant_scripts/bat_install.sh
      sudo sh /vagrant_scripts/install_epas.sh
      #sudo su - enterprisedb -c "/vagrant_scripts/install_tde.sh"
      #sudo su - enterprisedb -c "/vagrant_scripts/test_tde.sh"
      SHELL
  end

  # Postgres
  config.vm.define "postgres" do |postgres|
    postgres.vm.box = var_box
    postgres.vm.hostname= "postgres"
    postgres.vm.network "private_network", ip: postgres_public_ip, name: "HostOnly", virtualbox__intnet: true
    postgres.vm.network "forwarded_port", guest: postgres_port, host: "5432"
    postgres.vm.provider "virtualbox" do |vmpostgres|
      vmpostgres.memory = postgres_mem_size
      vmpostgres.cpus = postgres_cpus
      vmpostgres.name = postgres_vm_name
    end
    postgres.vm.synced_folder ".", "/vagrant"
    postgres.vm.synced_folder "./scripts", "/vagrant_scripts"
    postgres.vm.synced_folder "./config", "/vagrant_config"
    postgres.vm.provision "shell", inline: <<-SHELL
      sudo sh /vagrant_scripts/bat_install.sh
      sudo sh /vagrant_scripts/install_postgres.sh
    SHELL
  end

end
