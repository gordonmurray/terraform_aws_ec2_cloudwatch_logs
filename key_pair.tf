resource "aws_key_pair" "pem-key" {
  key_name   = "terraform-webserver-cloudwatch-key"
  public_key = file("~/.ssh/id_rsa.pub")
}
