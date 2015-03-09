Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.define "spark-master" do |box|
    box.vm.hostname = "master"
    box.vm.network "forwarded_port", guest: 8080, host: 8080
    box.vm.network "forwarded_port", guest: 50070, host: 50070
    box.vm.network "forwarded_port", guest: 9000, host: 9000
    box.vm.network "forwarded_port", guest: 8088, host: 8088
    box.vm.network "private_network", ip: "10.0.0.2"
    box.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "spark-master.pp"
    end

    box.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    end
  end

  config.vm.define "spark-slave0" do |box|
    box.vm.hostname = "slave0"
    box.vm.network "private_network", ip: "10.0.0.3"
    box.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "spark-slave.pp"
    end

    box.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    end
  end

  config.vm.define "spark-slave1" do |box|
    box.vm.hostname = "slave1"
    box.vm.network "private_network", ip: "10.0.0.4"
    box.vm.provision "puppet" do |puppet|
      puppet.module_path = "modules"
      puppet.manifests_path = "manifests"
      puppet.manifest_file = "spark-slave.pp"
    end

    box.vm.provider "virtualbox" do |vb|
      vb.memory = 2048
      vb.cpus = 2
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
      vb.customize ["modifyvm", :id, "--cpuexecutioncap", "100"]
    end
  end
end
