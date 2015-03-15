Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__exclude: ".git/"

  config.vm.define "spark-master" do |box|
    box.vm.hostname = "master"
    box.vm.network "forwarded_port", guest: 8081, host: 8080
    box.vm.network "forwarded_port", guest: 50070, host: 50070
    box.vm.network "forwarded_port", guest: 9000, host: 9000
    box.vm.network "forwarded_port", guest: 8088, host: 8088
    box.vm.network "forwarded_port", guest: 4040, host: 4040
    box.vm.network "private_network", type: "dhcp"

    box.vm.provision "trigger", :option => "value" do |trigger|
      trigger.fire do

        get_ip_address = %Q(vagrant ssh spark-master -c 'ifconfig | grep -oP "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oP "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1')
        puts "Running `#{get_ip_address}`"
        output = `#{get_ip_address}`.gsub("\n","")
        puts "Output received:\n----\n#{output}\n----"
        puts "==> spark-master: Available on DHCP IP address #{output.strip}"
        puts "Finished running :after trigger"
        run "vagrant ssh spark-master -c \"echo '#{output.strip} spark.master' | sudo tee --append /etc/hosts\""

        begin
          file = File.open("tmp/master", "w")
          file.write(output) 
        rescue IOError => e
          #some error occur, dir not writable etc.
        ensure
          file.close unless file == nil
        end
      end
    end

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
    box.vm.network "private_network", type: "dhcp"
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
    box.vm.network "private_network", type: "dhcp"
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
