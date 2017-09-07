provider "aws" {
  access_key = "xxx"
  secret_key = "xxx"
  region     = "eu-west-1"
}

resource "aws_instance" "firsthost" {
  ami           = "ami-785db401"
  instance_type = "m4.large"
  key_name   = "silpion-test-key"
  security_groups = [
        "allow_all_in"
    ]
}

resource "aws_key_pair" "silpion-test-key" {
  key_name   = "silpion-test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/LY5wXMyK40xj3/4PwoikjZE4gpB4qEhbXS99WxbMfncnxRks14jEhuLbOOucvxzS97HWpdGiaMtIaVI6Di6Zhccgpgf5xBUJgej02a84M86ynPbqpSbh95tfp8t1jezgAvcsGPSNhFtvhj3Y/IO4Qm1LTLhF7nyyVWk0NEOmiQKqj2BhmhIxtxa1M8CxdTC+AvBYYhJCOe+CEnjuV4fV11mU8t1cSJKSbQ6w6/VqHdPwOMH3UHQgynbBai5wCeSJoz2H4T5ZK8EOfMNCERthwbnJGSj3NJt24iJbp69czGOlHDQEn9OCLapZKDqkFJ87wXalOqH/qRN0xMk4ugyP ubuntu@ubuntu-xenial"
}

resource "aws_security_group" "allow_all_in" {
  name        = "allow_all_in"
  description = "Allow all inbound traffic"

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 0
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol  = "tcp"
    self      = true
    from_port = 0
    to_port = 65535
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_eip" "ip" {
  instance = "${aws_instance.firsthost.id}"
}
