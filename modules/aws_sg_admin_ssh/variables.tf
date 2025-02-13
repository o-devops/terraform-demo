variable "admin_ips" {
  description = "les ip's des admins"
  default     = ["8.8.8.8", "1.1.1.1"]
}

variable "mon_ip" {
  description = "mon ip a moa"
  type        = string
  default     = "92.151.128.188"
}

variable "vpc_id" {
  description = "L'id du vpc auquel on rattache notre security group"
}