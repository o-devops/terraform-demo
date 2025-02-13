provider "aws" {
  region = "us-east-1"
}

locals {
  subnet_list = toset(["subnet-0259333aec231062d", "subnet-05ddb429c8a79cac1"])
}

module "admin_ssh_sg" {
  source = "./modules/aws_sg_admin_ssh"
  vpc_id = "vpc-022f458c280ac21a5"
}

resource "aws_instance" "mavmeuh" {
  for_each               = local.subnet_list
  ami                    = "ami-0a7a4e87939439934"
  instance_type          = "t4g.nano"
  subnet_id              = each.value
  vpc_security_group_ids = [module.admin_ssh_sg.sg_id]
  key_name               = "vockey"
  tags = {
    Name = "mavmeuh"
  }
}