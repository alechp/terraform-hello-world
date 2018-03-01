variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "private_key_path" {}

variable "key_name" {
  default = "terraform_hello_world"
}

variable "network_address_space" {
  default = "10.1.0.0/16"
}

variable "subnet1_address_space" {
  default = "10.1.0.0/24"
}

variable "subnet2_address_space" {
  default = "10.1.1.0/24"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_seceret_key}"
  region     = "us-east-1"
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "vpc" {
  cidr_block           = "${var.network_address_space}"
  enable_dns_hostnames = "true"
}

resource "aws_internet_gateway" "igw" {
  # egress out of VPC into internet & ingress from internet into VPC
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_subnet" "subnet1" {
  cidr_block              = "${var.subnet1_address_space}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"                                              #automatically assign public and private IP
  availability_zone       = "${data.aws_availability_zones.available.names[0]}" #refer by number instead of name
}

resource "aws_subnet" "subnet2" {
  cidr_block              = "${var.subnet2_address_space}"
  vpc_id                  = "${aws_vpc.vpc.id}"
  map_public_ip_on_launch = "true"                                              #setting this to true makes it a "public subnet"
  availability_zone       = "${data.aws_availability_zones.available.names[1]}"
}

resource "aws_route_table" "rtb" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.igw.id}"
  }
}

resource "aws_route_table_association" "rta-subnet1" {
  subnet_id      = "${aws_subnet.subnet2.id}"  # why subnet ID instead of cidr_block like in subnet1 ? 
  route_table_id = "${aws_route_table.rtb.id}"
}

resource "aws_security_group" "nginx-sg" {
  name   = "nginx_sg"
  vpc_id = "${aws_vpc.vpc.id}"

  # SSH access from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_Blocks = ["0.0.0.0/0"] #use enterprise IP when in production instead of from anywhere
  }

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_Blocks = ["0.0.0.0/0"] #use this (anywhere) in production because people should be able to access site
  }

  #outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "nginx1" {
  ami                    = "ami-824c4ee2"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.subnet1.id}"
  vpc_security_group_ids = ["${aws_security_group.nginx-sg.id}"]
  key_name               = "${var.key_name}"

  connection {
    user        = "ec2-user"
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum install nginx -y",
      "sudo service nginx start",
      "echo '<html><head><title>Blue Server</title></head><body>Hello World</body></html>",
    ]
  }
}

output "aws_instance_public_dns" {
  value = "${aws_instance.ngxin1.public_dns}"
}
