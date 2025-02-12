# terraform {
#   backend "s3" {
#     bucket = "tf-demo-state-oclock"
#     key    = "terraform.tfstate"
#     region = "us-east-1"
#   }
# }

provider "dns" {}

provider "aws" {
  region = "us-east-1"
}

variable "ec2_type" {
  description = "Le type d'instance qu'on souhaite"
  type = string
  default = "t4g.nano"
}

variable "ec2_archi" {
  description = "Architecture to use"
  type = string
  default = "arm64"
}

data "aws_ami" "monubuntu" {
  # executable_users = ["self"]
  most_recent      = true
  owners = ["amazon"]
  
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = [var.ec2_archi]
  }
}


resource "aws_instance" "mavm" {
  ami           = "ami-0a7a4e87939439934"
  instance_type = var.ec2_type
  key_name      = "vockey"
  tags = {
    Name = "mavm"
  }
}

data "dns_a_record_set" "google" {
  host = "google.com"
}

output "google_addrs" {
  value = join(",", data.dns_a_record_set.google.addrs)
}

output "public_ip" {
  value = aws_instance.mavm.public_ip
}

output "private_ip" {
  value = aws_instance.mavm.private_ip
}

output "mon_ami_id" {
  value = data.aws_ami.monubuntu.id
}

output "mon_ami_name" {
  value = data.aws_ami.monubuntu.name
}