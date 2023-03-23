resource "aws_subnet" "subnets" {
  count                   = length(var.vpc.subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.vpc.subnets[count.index].cidr_block
  map_public_ip_on_launch = var.vpc.subnets[count.index].should_be_public_available
  availability_zone       = var.vpc.subnets[count.index].availability_zone
  tags                    = var.vpc.subnets[count.index].should_be_public_available ? merge(var.tags,
    {
      Name                                = var.vpc.subnets[count.index].name,
      "kubernetes.io/cluster/vssummit-ecommerceprod" = "shared"
    },
    {
      "kubernetes.io/role/elb" : 1
    }) : merge(var.tags,
    {
      Name                                = var.vpc.subnets[count.index].name,
      "kubernetes.io/cluster/vssummit-ecommerceprod" = "shared"
    },
    {
      "kubernetes.io/role/internal-elb" : 1
  })
}
