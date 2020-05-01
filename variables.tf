#----root/variables.tf-----
variable "aws_region" {}


#-------networking variables
variable "vpc_cidr" {}
variable "public_cidrs" {}
variable "accessip" {}
variable "availability_zone" {}

#-------compute variables
variable "key_name" {}
variable "public_key_path" {}
variable "server_instance_type" {}
variable "elk_master_instance_count" {
  default = 1
}
variable "elk_data_instance_count" {
  default = 1
}
variable "nginx_instance_count" {
  default = 1
}
variable "apm_instance_count" {
  default = 1
}
variable "elk_master_instance_name" {
  type = list
}
variable "elk_data_instance_name" {
  type = list
}
variable "nginx_instance_name" {
  type = list
}
variable "apm_instance_name" {
  type = list
}

variable "ami_owner" {}
variable "ami_name" {}


variable "terraform_path" {}
variable "ansible_path" {}
