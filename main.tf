#----root/main.tf-----
provider "aws" {
  version = "~> 2.49"
  region  = var.aws_region
}


# Deploy Networking Resources
module "networking" {
  source            = "./modules/networking"
  vpc_cidr          = var.vpc_cidr
  public_cidrs      = var.public_cidrs
  accessip          = var.accessip
  availability_zone = var.availability_zone
}

# Deploy ELK Master Compute Resources
module "elk-master-compute" {
  source                       = "./modules/elk-master-compute"
  elk_master_instance_count    = var.elk_master_instance_count
  key_name                     = var.key_name
  public_key_path              = var.public_key_path
  instance_type                = var.server_instance_type
  elk_master_instance_name     = var.elk_master_instance_name
  ami_owner                    = var.ami_owner
  ami_name                     = var.ami_name
  subnets                      = module.networking.public_subnets
  security_group               = module.networking.public_sg
  subnet_ips                   = module.networking.subnet_ips
}

# Deploy ELK Data Compute Resources
module "elk-data-compute" {
  source                       = "./modules/elk-data-compute"
  elk_data_instance_count      = var.elk_data_instance_count
  key_name                     = module.elk-master-compute.aws_key_pair
  public_key_path              = var.public_key_path
  instance_type                = var.server_instance_type
  elk_data_instance_name       = var.elk_data_instance_name
  ami_owner                    = var.ami_owner
  ami_name                     = var.ami_name
  subnets                      = module.networking.public_subnets
  security_group               = module.networking.public_sg
  subnet_ips                   = module.networking.subnet_ips
}

# Deploy Nginx Compute Resources
module "nginx-compute" {
  source                  = "./modules/nginx-compute"
  nginx_instance_count    = var.nginx_instance_count
  key_name                = module.elk-master-compute.aws_key_pair
  public_key_path         = var.public_key_path
  instance_type           = var.server_instance_type
  ami_owner               = var.ami_owner
  ami_name                = var.ami_name
  nginx_instance_name     = var.nginx_instance_name
  subnets                 = module.networking.public_subnets
  security_group          = module.networking.public_sg
  subnet_ips              = module.networking.subnet_ips
}


data "template_file" "ec2_public_ip" {
  template   = file("${var.terraform_path}/ec2_public_ip")
  depends_on = [ module.elk-master-compute, module.elk-data-compute, module.nginx-compute ]

  vars = {
     elk-master-ip         = join("\n", module.elk-master-compute.srv_public_ip.*)
     elk-data-ip           = join("\n", module.elk-data-compute.srv_public_ip.*)
     nginx-ip              = join("\n", module.nginx-compute.srv_public_ip.*)
  }
}

resource "null_resource" "ec2-public-ip" {
  triggers = {
    template_rendered = data.template_file.ec2_public_ip.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ec2_public_ip.rendered}' > '${var.ansible_path}/hosts'"
  }
}


data "template_file" "ec2_private_ip" {
  template   = file("${var.terraform_path}/ec2_private_ip")
  depends_on = [ module.elk-master-compute ]

  vars = {
    elk-master-private-ip  = join(" ", module.elk-master-compute.srv_private_ip.*)
  }
}

resource "null_resource" "ec2-private-ip" {
  triggers = {
    template_rendered = data.template_file.ec2_private_ip.rendered
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.ec2_private_ip.rendered}' > '${var.ansible_path}/group_vars/env_variables'"
  }
}


resource "null_resource" "ansible-play" {
  depends_on = [ module.elk-master-compute, module.elk-data-compute, module.nginx-compute ]

  provisioner "local-exec" {
    command = <<EOT
$elkdeployment
$nginxdeployment
$elkpostsetup
EOT

    environment = {
      elkdeployment    = "ansible-playbook -i ${var.ansible_path}/hosts ${var.ansible_path}/elk_setup.yml"
      nginxdeployment  = "ansible-playbook -i ${var.ansible_path}/hosts ${var.ansible_path}/nginx.yml"
      elkpostsetup     = "ansible-playbook -i ${var.ansible_path}/hosts ${var.ansible_path}/elk_post_setup.yml"
    }
  }
}


