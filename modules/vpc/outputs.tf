output "vpc_id" {
  description = "VPC ID "
  value = aws_vpc.vpc.id
}

output "vpc_cidr_block" {
  description = "VPC ID cidr block"
  value = aws_vpc.vpc.cidr_block
}

output "public_subnets_id" {
  description = "Lists of public subnets IDs"
  value = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

output "private_subnets_id" {
  description = "List of private subnets IDs"
  value = [aws_subnet.private_subnet1.id, aws_subnet.private_subnet2.id]
}
