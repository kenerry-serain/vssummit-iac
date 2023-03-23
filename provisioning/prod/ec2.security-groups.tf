resource "aws_security_group" "web_access" {
  name        = "vpc-prod-vssummit-ecommerce-web-access"
  description = "Providing WEB access to instances"
  vpc_id      = aws_vpc.main.id

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "all"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "all"
    cidr_blocks = ["0.0.0.0/0"] #Change 
  }

  tags = merge(var.tags)
}
