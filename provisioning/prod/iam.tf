resource "aws_iam_instance_profile" "profile" {
  name = aws_iam_role.role.name
  role = "ec2-role-prod-vssummit-ecommerce"
}

resource "aws_iam_role" "role" {
  name                = "ec2-role-prod-vssummit-ecommerce"
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3FullAccess", 
    "arn:aws:iam::aws:policy/service-role/AWSShieldDRTAccessPolicy", 
    "arn:aws:iam::aws:policy/AWSWAFFullAccess",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", 
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess",
    "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
  ]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}
