locals {
  public_subnets  = [for subnet in aws_subnet.subnets : subnet if subnet.map_public_ip_on_launch == true]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = merge(var.tags, {
    Name                                = "vpc-prod-vssummit-ecommerce-public-route-table",
    "kubernetes.io/cluster/vssummit-ecommerceprod" = "shared",
    "kubernetes.io/role/elb"            = "1"
  })
}

resource "aws_route_table_association" "public_route_table_association" {
  count          = length(local.public_subnets)
  subnet_id      = local.public_subnets[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}
