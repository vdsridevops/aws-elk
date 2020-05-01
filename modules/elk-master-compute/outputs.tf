#-----compute/outputs.tf-----

output "server_id" {
  value = join(", ", aws_instance.tf_server.*.id)
}

output "server_public_ip" {
  value = join(", ", aws_instance.tf_server.*.public_ip)
}

output "server_private_ip" {
  value = join(", ", aws_instance.tf_server.*.private_ip)
}

output "aws_key_pair" {
  value = aws_key_pair.tf_auth.id
}

output "srv_public_ip" {
  value = aws_instance.tf_server.*.public_ip
}

output "srv_private_ip" {
  value = aws_instance.tf_server.*.private_ip
}

