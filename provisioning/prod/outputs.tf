output "create_vpc" {
  value = aws_vpc.main.arn
}

output "created_subnets" {
  value = aws_subnet.subnets.*.arn
}

output "created_ssh_key"{
  sensitive = true
  value = tls_private_key.private_key.private_key_pem
  # terraform output -raw created_ssh_key >private_key.pem
}