resource "aws_instance" "firsthost" {
  ami           = "ami-1446b66d"
  instance_type = "t2.micro"
  key_name   = "silpion-test-key"

  provisioner "local-exec" {
    command = "echo ${aws_instance.firsthost.public_ip} > ip_address.txt"
  }
}

resource "aws_key_pair" "silpion-test-key" {
  key_name   = "silpion-test-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpSfLu8STO5EiIyGzQkd1ahg8nlhYA0+D7xrZWryWDZBjHRFIsrYjy/HP7TyEePAxauP9IwvkFcTnBrGxg+oMzaDNJn8wuBu8/wtg4pI5w83+jNKdt6DOXlU2xfCkAGyMqV7n0cjQ/HlKw5xJdLSve1Y2TdPdxl5hFowpUCDPIpTLJM+7JlHdODAe9On6Xbs4SyGi0fHpJr2WA+xGxrM7GaSz+cCg6Bvb5vxF2yPxqebTp07USIttVPFT9N6dRhR9Ad5rVMIAuRcELuOpIyxJVodQNVE0McuIVTGy9JpIMikTie+rNFDWfEDwrALp41CO7HxuBd9XuKr+WknhzoIXn vagrant@precise64"
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.firsthost.id}"
}