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
  config.vm.box_download_insecure = true

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
 # config.vm.network "forwarded_port", guest: 8080, host: 8080, host_ip: "127.0.0.1"
 # config.vm.network "forwarded_port", guest: 5050, host: 5050, host_ip: "127.0.0.1"
 # config.vm.network "forwarded_port", guest: 2181, host: 2181, host_ip: "127.0.0.1"
 # config.vm.network "forwarded_port", guest: 2888, host: 2888, host_ip: "127.0.0.1"
 # config.vm.network "forwarded_port", guest: 3888, host: 3888, host_ip: "127.0.0.1"

  #for i in 10000..11000
  #  config.vm.network :forwarded_port, guest: i, host: i
  #end

  #for i in 30000..35000
  #  config.vm.network :forwarded_port, guest: i, host: i
  #end

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


  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--memory", 4096, "--cpus", 2]
  end

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end


  config.vm.provision "shell", inline: <<-SHELL
     sudo apt-get update -y
     echo "install terraform client" 
     sudo apt-get install unzip  
     cd /vagrant
     wget -q https://releases.hashicorp.com/terraform/0.10.3/terraform_0.10.3_linux_amd64.zip
     unzip terraform_0.10*
     sudo mv terraform /usr/bin/
     echo "install ansible"
     sudo apt-get install -y software-properties-common
     sudo apt-add-repository ppa:ansible/ansible
     sudo apt-get update 
     sudo apt-get install -y ansible
     # set password ubuntu
     echo ubuntu:ubuntu | sudo /usr/sbin/chpasswd
     # copy key for tests
     cp /vagrant/silpion-test-key.pem /home/ubuntu/
     cp /vagrant/silpion-test-key.pub /home/ubuntu/
     chmod 400 /home/ubuntu/silpion-test-key.pem
     sudo chown ubuntu /home/ubuntu/silpion-test-key.pem
     sudo chown ubuntu /home/ubuntu/silpion-test-key.pub	 
  SHELL
end
