# Get the AMI created by Packer
data "aws_ami" "webserver" {
  most_recent = true

  filter {
    name   = "name"
    values = ["webserver"]
  }

  owners = [var.aws_account_id]

}

# Create EC2 instance
resource "aws_instance" "example" {
  ami                    = data.aws_ami.webserver.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.pem-key.key_name
  subnet_id              = aws_subnet.subnet-1a.id
  vpc_security_group_ids = [aws_security_group.example.id]
  iam_instance_profile   = aws_iam_instance_profile.webserver.name

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = "10"

    tags = {
      Name = "terraform-webserver-cloudwatch"
    }
  }

  tags = {
    Name = "terraform-webserver-cloudwatch"
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  user_data = data.template_file.webswebserver_user_data.rendered

}

# Prepare user_data via a template file
data "template_file" "webswebserver_user_data" {
  template = file("files/webserver.tpl")
}