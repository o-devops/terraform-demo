provider "aws" {
  region = "us-east-1"
}


resource "aws_security_group" "admin_ssh" {
  name        = "mod_admin_ssh"
  description = "Allow SSH from admins"
  vpc_id      = var.vpc_id

  tags = {
    Name = "mod_admin_ssh"
  }
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