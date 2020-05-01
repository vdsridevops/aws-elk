#----compute/main.tf#----
data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

data "template_file" "userdata" {
  count    = var.nginx_instance_count
  template = file("${path.module}/userdata.tpl")

  vars = {
    ec2_nginx_instance_name  = var.nginx_instance_name[count.index]
  }
}

resource "aws_instance" "tf_server" {
  count         = var.nginx_instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id
  user_data     = element(data.template_file.userdata.*.rendered, count.index)

  tags = {
    Name = var.nginx_instance_name[count.index]
  }
  key_name               = var.key_name
  subnet_id              = element(var.subnets, count.index)
  vpc_security_group_ids = [var.security_group]
}
