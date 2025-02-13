provider "aws" {
  region = "us-east-1"
}

locals {
  subnet_list = toset(["subnet-0259333aec231062d", "subnet-05ddb429c8a79cac1"])
}

resource "aws_security_group" "admin_ssh" {
  name        = "admin_ssh"
  description = "Allow SSH from admins"
  vpc_id      = "vpc-022f458c280ac21a5"

  tags = {
    Name = "admin_ssh"
  }
}

variable "admin_ips" {
  description = "les ip's des admins"
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "mon_ip" {
  description = "mon ip a moa"
  type        = string
  default     = "92.151.128.188"
}

resource "aws_vpc_security_group_ingress_rule" "ssh-in" {
  security_group_id = aws_security_group.admin_ssh.id
  cidr_ipv4         = "${var.mon_ip}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ssh-ins" {
  for_each          = toset(var.admin_ips)
  security_group_id = aws_security_group.admin_ssh.id
  cidr_ipv4         = "${each.value}/32"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "all-out" {
  security_group_id = aws_security_group.admin_ssh.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_instance" "mavmeuh" {
  for_each               = local.subnet_list
  ami                    = "ami-0a7a4e87939439934"
  instance_type          = "t4g.nano"
  subnet_id              = each.value
  vpc_security_group_ids = [aws_security_group.admin_ssh.id]
  key_name               = "vockey"
  tags = {
    Name = "mavmeuh"
  }
}