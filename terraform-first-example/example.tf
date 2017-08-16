provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "eu-west-1"
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
