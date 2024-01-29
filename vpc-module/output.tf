output "aws_vpc_id" {
  value = aws_vpc.this.id
}

output "aws_vpc_arn" {
  value = aws_vpc.this.arn
}

output "aws_vpc_igw_id" {
  value = aws_internet_gateway.this.id
}

output "aws_vpc_igw_arn" {
  value = aws_internet_gateway.this.arn
}

output "aws_vpc_s3_gateway_endpoint_id" {
  value = aws_vpc_endpoint.s3_endpoint.id
}

output "aws_vpc_s3_gateway_endpoint_arn" {
  value = aws_vpc_endpoint.s3_endpoint.arn
}

output "aws_eip_id" {
  value = var.create_eip_for_natgw ? aws_eip.this[0].id : "EIP not created"
}

output "aws_nat_gateway_id" {
  value = var.create_eip_for_natgw ? aws_nat_gateway.this[0].id : "AWS Nat Gateway not created"
}

output "aws_nat_gateway_public_ip" {
  value = var.create_eip_for_natgw ? aws_nat_gateway.this[0].public_ip : "AWS Nat Gateway not created"
}

output "aws_nat_gateway_private_ip" {
  value = var.create_eip_for_natgw ? aws_nat_gateway.this[0].private_ip : "AWS Nat Gateway not created"
}
