# Creating a VPC endpoint for S3
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id = aws_vpc.this.id
  # ID of the VPC: This specifies the VPC where the S3 endpoint is to be created, 
  # ensuring that the endpoint is associated with your specific VPC.

  service_name = "com.amazonaws.${var.region}.s3"
  # S3 service name for the region: It's formatted as 'com.amazonaws.[region].s3',
  # where [region] is dynamically set based on your deployment. This identifies the 
  # AWS service that the endpoint will connect to, in this case, S3.

  vpc_endpoint_type = "Gateway"
  # Type of endpoint - Gateway: Specifies the endpoint type. For S3, a gateway-type 
  # endpoint is used, which allows direct, private connectivity to S3 without requiring 
  # internet access through an Internet Gateway or NAT device.

  route_table_ids = [aws_route_table.private_route_table.id]
  # Route Table IDs: This field specifies the route table(s) associated with the S3 endpoint. 
  # By associating it with the private route table, we ensure that instances in private subnets 
  # can access S3 directly. Public subnets are typically excluded as they can access S3 via the Internet Gateway.

  tags = {
    Name = "${var.project}-s3-vpc-endpoint"
  }

  # Policy to control access to the S3 service from within the VPC.
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action    = "*",
        Effect    = "Allow",
        Resource  = "*",
        Principal = "*",
      },
    ]
  })
  # Endpoint Policy: This JSON-encoded policy dictates how the resources within the VPC can interact 
  # with S3. In this example, the policy is permissive, allowing all actions (`*`) from any principal (`*`)
  # on any S3 resource (`*`). This should be tailored to enforce least privilege based on specific use cases.
}
