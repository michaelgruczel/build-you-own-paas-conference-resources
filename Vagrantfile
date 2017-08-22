# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/xenial64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 5050, host: 5050, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 2181, host: 2181, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 2888, host: 2888, host_ip: "127.0.0.1"
  config.vm.network "forwarded_port", guest: 3888, host: 3888, host_ip: "127.0.0.1"

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


  config.vm.provision "shell", inline: <<-SHELL
     apt-get update
     echo "install terraform client" 
     apt-get install -y unzip
     cd /vagrant
     unzip terraform_0.10.1_linux_amd64.zip
     sudo cp terraform /usr/bin/terraform
     rm terraform
     echo "install ansible"
     sudo apt-get install -y software-properties-common
     sudo apt-add-repository ppa:ansible/ansible
     sudo apt-get update 
     sudo apt-get install -y ansible
     echo "install docker"
     sudo apt-get install -y linux-image-extra-$(uname -r) linux-image-extra-virtual
     sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -    
     sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
     sudo apt-get update
     sudo apt-get install -y docker-ce
     sudo gpasswd -a ubuntu docker 
     newgrp docker
     echo "start local mesos sample" 
     echo "zookeeper"
     docker run -d -p 2181:2181 -p 2888:2888 -p 3888:3888 --name zookeeper zookeeper:3.4
     echo "master"
     docker run -d -p 5050:5050 --network=host -e MESOS_PORT=5050 -e MESOS_ZK=zk://127.0.0.1:2181/mesos -e MESOS_QUORUM=1 -e MESOS_REGISTRY=in_memory -e MESOS_LOG_DIR=/var/log/mesos -e MESOS_WORK_DIR=/var/tmp/mesos -v "$(pwd)/log/mesos:/var/log/mesos" -v "$(pwd)/tmp/mesos:/var/tmp/mesos" mesosphere/mesos-master:1.2.1
     echo "slave"
     docker run -d -p 5051:5051 --network=host --privileged -e MESOS_PORT=5051 -e MESOS_MASTER=zk://127.0.0.1:2181/mesos -e MESOS_SWITCH_USER=0 -e MESOS_CONTAINERIZERS=docker,mesos -e MESOS_LOG_DIR=/var/log/mesos -e MESOS_WORK_DIR=/var/tmp/mesos -v "$(pwd)/log/mesos:/var/log/mesos" -v "$(pwd)/tmp/mesos:/var/tmp/mesos" -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/usr/local/bin/docker mesosphere/mesos-slave:1.2.1
     echo "marathon"
     docker run -d -p 8080:8080 --network=host -e MARATHON_MASTER=zk://127.0.0.1:2181/mesos -e MESOS_ZK=zk://zookeeper:2181/marathon mesosphere/marathon:v1.4.5

  SHELL
end
