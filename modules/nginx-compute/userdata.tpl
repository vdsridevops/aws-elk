#!/bin/bash
hostnamectl set-hostname ${ec2_nginx_instance_name}
sed -i 's/#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
sed -i 's/#PubkeyAuthentication/PubkeyAuthentication/g' /etc/ssh/sshd_config
systemctl reload sshd
