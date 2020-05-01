#----compute/main.tf#----
data "aws_ami" "server_ami" {
  most_recent = true

  owners = ["${var.ami_owner}"]

  filter {
    name   = "name"
    values = ["${var.ami_name}"]
  }
}

resource "aws_key_pair" "tf_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

data "template_file" "userdata" {
  count    = var.elk_master_instance_count
  template = file("${path.module}/userdata.tpl")

  vars = {
    ec2_elk_master_instance_name  = var.elk_master_instance_name[count.index]
  }
}
  

resource "aws_instance" "tf_server" {
  count         = var.elk_master_instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server_ami.id
  user_data     = element(data.template_file.userdata.*.rendered, count.index)

  tags = {
    Name = var.elk_master_instance_name[count.index]
  }
  key_name               = aws_key_pair.tf_auth.id
  subnet_id              = element(var.subnets, count.index)
  vpc_security_group_ids = [var.security_group]
}
