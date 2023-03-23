resource "tls_private_key" "private_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "ec2-kp-us-east-1-prod-vssummit-ecommerce"
  public_key = tls_private_key.private_key.public_key_openssh
}