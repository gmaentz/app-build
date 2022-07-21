
#
# DO NOT DELETE THESE LINES UNTIL INSTRUCTED TO!
#
# Your AMI ID is:
#
#     "ami-00482f016b2410dc8"
#
# Your subnet ID is:
#   

# "subnet-0f2d9015eaa4b1f7a"

#
# Your VPC security group ID is:
#  

# "sg-0fd84edd1a373a896"

#
# Your Identity is:
#
#     "awsaccount"
#


variable "access_key" {
  description = "AWS Access Key"
}

variable "secret_key" {
  description = "AWS Secret Key"
}

variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ami" {
  description = "Server Image ID"
}

variable "subnet_id" {
  description = "Server Subnet ID"
}

variable "identity" {
  description = "Server Name"
}

variable "vpc_security_group_ids" {
  description = "Server Security Group ID(s)"
  type        = list(any)
}

provider "aws" {
  access_key = var.access_key
  secret_key = var.secret_key
  region     = var.region
}

variable "server_os" {
  type        = string
  description = "Server Operating System"
  default     = "ubuntu_20_04"
}

locals {
  servers = {
    server-apache = {
      server_os              = "ubuntu_20_04"
      identity               = "${var.identity}-ubuntu"
      subnet_id              = var.subnet_id
      vpc_security_group_ids = var.vpc_security_group_ids
    }
  }
}

module "server" {
  # source                 = "./server"
  source  = "app.terraform.io/gabe-training-advanced-072022/server/aws"
  version = "0.0.4"
  for_each               = local.servers
  server_os              = each.value.server_os
  identity               = each.value.identity
  subnet_id              = each.value.subnet_id
  vpc_security_group_ids = each.value.vpc_security_group_ids
}

output "public_ip" {
  description = "Public IP of the Servers"
  value       = { for p in sort(keys(local.servers)) : p => module.server[p].public_ip }
}

output "public_dns" {
  description = "Public DNS names of the Servers"
  value       = { for p in sort(keys(local.servers)) : p => module.server[p].public_dns }
}

