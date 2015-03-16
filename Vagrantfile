Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"

  output = nil
  range = 0..1

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
        run get_ip_address
        output = `#{get_ip_address}`.gsub("\n","")
        puts "Output received:\n----\n#{output}\n----"
        puts "==> spark-master: Available on DHCP IP address #{output.strip}"
        puts "Finished running :after trigger"
        run "vagrant ssh spark-master -c \"echo '#{output.strip} spark.master' | sudo tee --append /etc/hosts\""

        # We need to write to a file so people know what the master ip is
        file = File.open("tmp/master", "w")
        file.write(output)
        file.close
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

  range.each do |i|
    output = File.open('tmp/master', &:readline)

    config.vm.define "spark-slave#{i}" do |box|
      box.vm.hostname = "slave#{i}"
      box.vm.network "private_network", type: "dhcp"

      box.vm.provision "trigger", :option => "value" do |trigger|
        trigger.fire do
          # Add spark.master ip
          run "vagrant ssh spark-slave#{i} -c \"echo '#{output.strip} spark.master' | sudo tee --append /etc/hosts\""
          
          # Add own ip
          my_ip_address = %Q(vagrant ssh spark-master -c 'ifconfig | grep -oP "inet addr:\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | grep -oP "\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}" | tail -n 2 | head -n 1')
          my_ip_address = run my_ip_address
          run "vagrant ssh spark-slave#{i} -c \"echo '#{output.strip} spark.slave' | sudo tee --append /etc/hosts\""

        end
      end

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
end
