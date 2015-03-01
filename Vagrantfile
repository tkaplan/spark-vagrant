# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
yarnNamenode = {:hostname => 'yarn-namenode',  :ip => '10.0.1.1', :box => 'ubuntu/trusty64', :ram => 512},

Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.
  config.vm.box = "ubuntu/trusty64"
  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end



  
  # node_config.vm.box = node[:box]
  # node_config.vm.box_url = 'http://files.vagrantup.com/' + node_config.vm.box + '.box'
  # node_config.vm.hostname = node[:hostname] + '.' + domain
  # node_config.vm.network :private_network, ip: node[:ip]

  # if node[:fwdhost]
  #   node_config.vm.network :forwarded_port, guest: node[:fwdguest], host: node[:fwdhost]
  # end

  # memory = node[:ram] ? node[:ram] : 256;
  # node_config.vm.provider :virtualbox do |vb|
  #   vb.customize [
  #     'modifyvm', :id,
  #     '--name', node[:hostname],
  #     '--memory', memory.to_s
  #   ]
  # end

  # node_config.vm.provision :puppet do |puppet|
  #   puppet.manifests_path = 'provision/manifests'
  #   puppet.module_path = 'provision/modules'
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.define "yarn-master" do |box|
    box.vm.hostname = "yarn.master"
    box.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "master.pp"
    end
  end

  # config.vm.define "yarn-resourcemanager" do |box|
  #   box.vm.provision "puppet" do |puppet|
  #     puppet.module_path = "modules"
  #     puppet.manifests_file = "manifests/yarn-resourcemanager"
  #   end
  # end

  # # Configure a puppet master which will then provision the slaves
  # # I'm not sure if spark should be installed on this node.
  # config.vm.define "spark-master" do |box|
  #   box.vm.provision "puppet" do |puppet|
  #     puppet.module_path = "modules"
  #     puppet.manifests_file = "manifests/spark-master.pp"
  #   end
  # end

  # # Slaves, spark will be installed on this node. 
  # config.vm.provision "spark-slave" do |box|
  #   box.vm.provision "puppet" do |puppet|
  #     puppet.module_path = "modules"
  #     puppet.manifests_file = "manifests/spark-slave.pp"
  #   end
  # end
end
