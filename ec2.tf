data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

# Create EC2 instance
resource "aws_instance" "example" {
  ami                    = data.aws_ami.ubuntu.id
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

  provisioner "file" {
    // upload the index.html file
    source      = "files/index.html"
    destination = "/home/ubuntu/index.html"
  }

  provisioner "file" {
    // upload the cloudwatch agent config file
    source      = "files/amazon-cloudwatch-agent.json"
    destination = "/home/ubuntu/amazon-cloudwatch-agent.json"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt upgrade -y",
      "sudo apt install apache2-bin ssl-cert apache2 -y",
      "sudo mv /home/ubuntu/index.html /var/www/html/index.html",
      "wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb",
      "sudo dpkg -i -E ./amazon-cloudwatch-agent.deb",
      "sudo cp /home/ubuntu/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json",
      "sudo usermod -aG adm cwagent",
      "sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -m ec2 -a start"
    ]
  }

  connection {
    // connect over ssh
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    port        = "22"
    host        = aws_instance.example.public_dns
  }

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

}
