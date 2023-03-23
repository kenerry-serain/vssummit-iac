resource "aws_vpc" "main" {
  cidr_block           = var.vpc.cidr_block
  enable_dns_hostnames = true
  tags                 = merge(var.tags, { Name = var.vpc.name })
}

resource "aws_main_route_table_association" "association" {
  vpc_id         = aws_vpc.main.id
  route_table_id = aws_route_table.public_route_table.id
}
