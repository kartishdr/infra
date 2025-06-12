output "vpc_id" {
  value = aws_vpc.main.id
  description = "The ID of the VPC"
}

output "subnet_id" {
  value = aws_subnet.public_subnet.id
  description = "The ID of the subnet"
}

output "internet_gateway_id" {
  value = aws_internet_gateway.gw.id
  description = "The ID of the internet gateway"
}


output "public_subnet_id" {
  value = aws_subnet.public_subnet.id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

