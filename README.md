# build-you-own-paas-conference-resources
resources and examples as appendis to the conference talk about builing your own PAAS

## Terraform

install Terraform:
* Download archieve from https://www.terraform.io/downloads.html
* unzip it
* put the terraform binary in PATH

test it:

    $ terraform --version

Terraform is used to create, manage, and manipulate infrastructure resources. Examples of resources include physical machines, VMs, network switches, containers, etc. Almost any infrastructure noun can be represented as a resource in Terraform.

Terraform is agnostic to the underlying platforms by supporting providers. A provider is responsible for understanding API interactions and exposing resources. Providers generally are an IaaS (e.g. AWS, GCP, Microsoft Azure, OpenStack), PaaS (e.g. Heroku), or SaaS services (e.g. Terraform Enterprise, DNSimple, CloudFlare).

Terraform builds a graph of resources. This tells Terraform not only in what order to create resources, but also what resources can be created in parallel. In our example, since the IP address depended on the EC2 instance, they could not be created in parallel.

Example AWS

example.tf:

<PRE>

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
}

resource "aws_instance" "firsthost" {
  ami           = "ami-1446b66d"
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "echo ${aws_instance.firsthost.public_ip} > ip_address.txt"
  }
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.firsthost.id}"
}

</PRE>	

let's create an ec2 instance it:

    $ cd terraform-first-example
    $ export AWS_ACCESS_KEY_ID="accesskey"
    $ export AWS_SECRET_ACCESS_KEY="secretkey"
    $ export AWS_DEFAULT_REGION="eu-west-1"
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
  ami           = "ami-1446b66d"
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
    $ export AWS_ACCESS_KEY_ID="accesskey"
    $ export AWS_SECRET_ACCESS_KEY="secretkey"
    $ export AWS_DEFAULT_REGION="eu-west-1"
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

...more coming soon...

