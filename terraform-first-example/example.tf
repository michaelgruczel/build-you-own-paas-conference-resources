provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region     = "eu-west-1"
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
