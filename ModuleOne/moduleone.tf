###########
# Variables
###########
variable "aws_access_key" {}

variable "aws_secret_key" {}

variable "private_key_path" {}

variable "key_name" {
  default = "terraform_hello_world"
}

provider "aws" {
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
  region     = "us-west-1"
}

###########
# Resources
###########

resource "aws_instance" "nginx" {
  ami           = "ami-9abbb3fa"
  instance_type = "t2.micro"
  key_name      = "${var.key_name}"

  #################################################
  # commented out because of timeouts
  #################################################
  # connection {
  #   user        = "ec2-user"
  #   private_key = "${file(var.private_key_path)}"
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "sudo apt-get update",
  #     "sudo apt-get install ngxinx",
  #     "sudo service nginx start",
  #   ]
  # }
}

###########
# Output
###########

output "aws_instance_public_ip" {
  value = "${aws_instance.nginx.public_dns}"
}
