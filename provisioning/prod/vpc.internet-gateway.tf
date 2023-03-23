resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
  tags   = merge(var.tags, { Name = "vpc-prod-vssummit-ecommerce-internet-gateway" })
  depends_on = [
    aws_vpc.main
  ]
}
