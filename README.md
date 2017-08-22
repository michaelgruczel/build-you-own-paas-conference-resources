# build-you-own-paas-conference-resources
resources and examples as appendis to the conference talk about builing your own PAAS

## vagrant 

Vagrant provides a declarative configuration file which describes all your software requirements, packages, operating system configuration, users, and more. Using a provider like virtal box you can automate creation and orchestration of vms. This is useful in order to create reproducable development environments which are as equal as possible to the production system.

Install vagrant and virtual box and execute:

    $ vagrant up
    $ vagrant ssh
    $ cd /vagrant

on windows you need maybe a tools like putty (user ubuntu, password vagrant, port 2222) to ssh into the vm or a unix like shell like cygwin or gitbash.


## Terraform

Terraform is used to create, manage, and manipulate infrastructure resources. Examples of resources include physical machines, VMs, network switches, containers, etc. Almost any infrastructure noun can be represented as a resource in Terraform.

Terraform is agnostic to the underlying platforms by supporting providers. A provider is responsible for understanding API interactions and exposing resources. Providers generally are an IaaS (e.g. AWS, GCP, Microsoft Azure, OpenStack), PaaS (e.g. Heroku), or SaaS services (e.g. Terraform Enterprise, DNSimple, CloudFlare).

Terraform builds a graph of resources. This tells Terraform not only in what order to create resources, but also what resources can be created in parallel. In our example, since the IP address depended on the EC2 instance, they could not be created in parallel.

install Terraform:
* Download archieve from https://www.terraform.io/downloads.html
* unzip it
* put the terraform binary in PATH

test it:

    $ terraform --version

Example AWS

example.tf:

<PRE>

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
  key_name   = "silpion-test-key"
}

resource "aws_key_pair" "silpion-test-key" {
  key_name   = "silpion-test-key"
  public_key = "ssh-rsa....."
}

resource "aws_instance" "firsthost" {
  ami           = "ami-785db401"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.firsthost.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.firsthost.id}"
}

</PRE>	

let's create an EC2 instance on aws:

    $ cd terraform-first-example
    $ export AWS_ACCESS_KEY_ID="an accesskey"
    $ export AWS_SECRET_ACCESS_KEY="a secretkey"
    $ terraform init
    $ terraform plan
    # terraform plan shows what changes Terraform will apply to your infrastructure
    $ terraform apply
    $ terraform show

let's destroy it:

    $ terraform plan -destroy
    $ terraform destroy

let us move some code into a module.
Modules in Terraform are self-contained packages of Terraform configurations that are managed as a group. Modules are used to create reusable components, improve organization, and to treat pieces of infrastructure as a black box.

<PRE>

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
}

module "example-module" {
  source = "./modules/example-module"
}

</PRE>	

In ./modules/example-module" I have added the known definition:

<PRE>	

resource "aws_instance" "firsthost" {
  ami           = "ami-785db401"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.firsthost.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.firsthost.id}"
}

</PRE>	

    $ cd terraform-second-example
    $ export AWS_ACCESS_KEY_ID="an accesskey"
    $ export AWS_SECRET_ACCESS_KEY="a secretkey"
    $ terraform init
    # download modules if needed
    $ terraform get
    $ terraform plan
    # terraform plan shows what changes Terraform will apply to your infrastructure
    $ terraform apply
    $ terraform show
    $ terraform graph

more information here https://www.terraform.io/docs/modules/index.html.
More examples https://github.com/terraform-providers/terraform-provider-aws.git

Just to be more complete a vSphere example could look like this:

<PRE>

# Configure the VMware vSphere Provider
provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"

  # if you have a self-signed cert
  allow_unverified_ssl = true
}

# Create a folder
resource "vsphere_folder" "frontend" {
  path = "frontend"
}

# Create a file
resource "vsphere_file" "ubuntu_disk" {
  datastore        = "local"
  source_file      = "/home/ubuntu/my_disks/custom_ubuntu.vmdk"
  destination_file = "/my_path/disks/custom_ubuntu.vmdk"
}

# Create a disk image
resource "vsphere_virtual_disk" "extraStorage" {
  size       = 2
  vmdk_path  = "myDisk.vmdk"
  datacenter = "Datacenter"
  datastore  = "local"
}

# Create a virtual machine within the folder
resource "vsphere_virtual_machine" "web" {
  name   = "terraform-web"
  folder = "${vsphere_folder.frontend.path}"
  vcpu   = 2
  memory = 4096

  network_interface {
    label = "VM Network"
  }

  disk {
    template = "centos-7"
  }
}

</PRE>	

## Ansible

TODO

Let us install docker on the created VM on AWS.
First change ip in inventory file accordingly to the created vm, then execute:

    $ cd /vagrant/ansible-first-example
    $ export ANSIBLE_HOST_KEY_CHECKING=False
    $ ansible-playbook -i inventory-local install-docker.yml


cd /vagrant
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_FORCE_COLOR=true

TODO 

## Zookeeper, Mesos, Marathon

ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services.

Mesos runs on every machine and provides applications with API’s for
resource management and scheduling across entire datacenter and cloud environments.

Marathon is a production-grade container orchestration platform for Mesos.
Multiple container runtimes. Marathon has first-class support for both Mesos containers (using cgroups) and Docker.

Lets's take a look in a local installation.
If you created the vagrant vm then you should be able to open. 

    $ http://127.0.0.1:5050
    $ http://127.0.0.1:8080

Ok, let's install it on on AWS
Let us install a single node mesos cluster on the created VM on AWS where we already added docker via ansible.

    $ cd /vagrant/mesos-first-example
    $ ansible-playbook ....

more examples under:

* https://medium.com/@gargar454/deploy-a-mesos-cluster-with-7-commands-using-docker-57951e020586
* https://github.com/mesosphere/docker-containers/tree/master/mesos
* https://mesosphere.github.io/marathon/docs/application-basics.html
