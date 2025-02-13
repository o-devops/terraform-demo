output "sg_id" {
    description = "created security group id"
    value = aws_security_group.admin_ssh.id
}