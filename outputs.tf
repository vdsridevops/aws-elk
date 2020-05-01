#----root/outputs.tf-----

#---Networking Outputs -----

output "Public_Subnets" {
  value = join(", ", module.networking.public_subnets)
}

output "Subnet_IPs" {
  value = join(", ", module.networking.subnet_ips)
}

output "Public_Security_Group" {
  value = module.networking.public_sg
}

#---ELK Master Compute Outputs ------

output "ELK_Master_Public_Instance_IDs" {
  value = module.elk-master-compute.server_id
}

output "ELK_Master_Public_Instance_IPs" {
  value = module.elk-master-compute.server_public_ip
}

output "ELK_Master_Private_Instance_IPs" {
  value = module.elk-master-compute.server_private_ip
}


#---ELK Data Compute Outputs ------

output "ELK_Data_Public_Instance_IDs" {
  value = module.elk-data-compute.server_id
}

output "ELK_Data_Public_Instance_IPs" {
  value = module.elk-data-compute.server_public_ip
}

output "ELK_Data_Private_Instance_IPs" {
  value = module.elk-data-compute.server_private_ip
}


#---Nginx Compute Outputs ------

output "Nginx_Public_Instance_IDs" {
  value = module.nginx-compute.server_id
}

output "Nginx_Public_Instance_IPs" {
  value = module.nginx-compute.server_public_ip
}

output "Nginx_Private_Instance_IPs" {
  value = module.nginx-compute.server_private_ip
}


/*

#---APM Compute Outputs ------

output "APM_Public_Instance_IDs" {
  value = module.apm-compute.server_id
}

output "APM_Public_Instance_IPs" {
  value = module.apm-compute.server_public_ip
}

output "APM_Private_Instance_IPs" {
  value = module.apm-compute.server_private_ip
}

*/
