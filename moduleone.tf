# Variables

variable "aws_access_key" {
  #  default = "AKIAI25QBZNCB4SKNPQQ"
}

variable "aws_secret_key" {
  # default = "VPIc4mEm1sLofl5jB4dImNGW5jtiScrzdYGRqvIP"
}

variable "private_key_path" {}

variable "key_name" {
  default = "HelloWorldKeys"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
}

resource "aws_instance" "nginx" {
  ami           = "ami-c58c1dd3"
  instance_type = "t2.nano"
  key_name      = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }
}

provisioner "remote-exec" {
  inline = [
    "sudo yum install nginx -y",
    "sudo service nginx start",
  ]
}

output "aws_instance_public_ip" {
  value = "${aws_instance.nginx.public_dns}"
}
