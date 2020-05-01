#----compute/variables.tf----
variable "key_name" {}

variable "public_key_path" {}

variable "subnet_ips" {}

variable "nginx_instance_count" {}

variable "instance_type" {}

variable "security_group" {}

variable "subnets" {}

variable "nginx_instance_name" {
  type = list
}

variable "ami_owner" {}

variable "ami_name" {}
