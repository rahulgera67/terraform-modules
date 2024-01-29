# 1. Creating vpc 
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr //  ipv4 cidr block for vpc
  enable_dns_support   = true         //  Enables DNS support within the VPC ( always set this true )--> default true
  enable_dns_hostnames = true         //  Allows instances to have DNS hostnames ( always set this true ) --> default false
  instance_tenancy     = "default"    //  tenancy could be default or dedicated ( not to use dedicated--> more charges)

  tags = merge(
    {
      Name = "${var.project}-vpc"
      # "kubernetes.io/cluster/${var.project}_ekscluster" = "shared"
    },
    var.tags
  )
}


// ------------------------- Resources for public  subnet--------------------------- //

# 2. # Creating an Internet Gateway and attaching it to the VPC
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id // VPC ID to which the IGW is attached.

  tags = merge(
    {
      Name = "${var.project}-igw"
    },
    var.tags
  )
}

# 3. Creating public subnets within the VPC ( If there are 3 Azs defined with 3 subnets cidr in variables, 3 subnets will be created )
# and each subnet will be associated with AZ using that index 
# like [AZ1, AZ2, AZ3]
#  index 0    1    2
# [pub_cidr_1, pub_cidr_2, pub_cidr_3]
# index 0        1          2
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.this.id                               // Associates subnets with the created VPC.
  count                   = length(var.public_subnets_cidr)               // Counts the public-subnets 
  cidr_block              = element(var.public_subnets_cidr, count.index) // CIDR blocks for each public subnet.
  map_public_ip_on_launch = true                                          // Automatically assigns public IP to instances in these subnets.
  availability_zone       = element(var.availability_zones, count.index)  // Sets the availability zone for each subnet.

  tags = merge(
    {
      Name = "${var.project}-public-subnet-${count.index + 1}"
      # "kubernetes.io/cluster/${var.project}-cluster" = "shared"
      # "kubernetes.io/role/elb" 
    },
    var.tags
  )
}

# 4. Creating a route table for public subnets
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.this.id // Associates the route table with the created VPC.
  tags = merge(
    {
      Name = "${var.project}-public-route-table"
    },
    var.tags
  )
}

# 4.1 Defining a route in the public route table to the Internet Gateway
resource "aws_route" "route_to_igw" {
  route_table_id         = aws_route_table.public_route_table.id // The ID of the public route table.
  destination_cidr_block = "0.0.0.0/0"                           // Represents all IP addresses (internet traffic).
  gateway_id             = aws_internet_gateway.this.id          // The ID of the Internet Gateway
}

# 4.2 Route table associations (if there are 3 subnets, 3 subnets will be asscoiated with that public route table )
# here will attach each subnets to that route table called route table association
resource "aws_route_table_association" "public_RTA" {
  route_table_id = aws_route_table.public_route_table.id               // Defines which route table id to take
  count          = length(var.public_subnets_cidr)                     // Number of associations based on the number of public subnets.
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index) // Associates each public subnet with the route table defined above in route_table_id
}


// ------------------------- Resources for private subnet--------------------------- //


# Creating an Elastic IP for the NAT Gateway
resource "aws_eip" "this" {
  count      = var.create_eip_for_natgw ? 1 : 0
  domain     = "vpc"                       # Allocates the EIP in the VPC ( we can avoid this, default option )  
  depends_on = [aws_internet_gateway.this] // means if igw exits it will be created otherwise not 
  tags = merge(
    {
      "Name" = "${var.project}_eip"
    },
    var.tags
  )
}

#  Creating nat gateway in public subnet but for private subnet
resource "aws_nat_gateway" "this" {
  count         = var.create_eip_for_natgw ? 1 : 0
  allocation_id = aws_eip.this[0].id # Associates the EIP with the NAT Gateway
  # we are creating the nat-gw only for subnet1 ( means AZ 1 ) --> check below index is set to 0 
  # It places the NAT Gateway in the first public subnet 
  # count = var.create_nat_gateway ? 1 : 0  // if true use count = 1 otherwise count = 0 in false condition
  subnet_id  = element(aws_subnet.public_subnet.*.id, 0) // nat gateway will be created in public subnet (check subnet_id is of public subnet)
  depends_on = [aws_internet_gateway.this, aws_eip.this] // depends on aws igw ( if IGW not created this will not be created )
  tags = merge(
    {
      Name = "${var.project}_nat_gateway"
    },
    var.tags
  )
}

# Creating Private subnet ands associate with vpc using vpc_id (create it as per the number of Availaibilty zones) 
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.this.id
  count                   = length(var.private_subnets_cidr)               // Counts the private-subnets 
  cidr_block              = element(var.private_subnets_cidr, count.index) // CIDR blocks for each private subnet.
  availability_zone       = element(var.availability_zones, count.index)   // Sets the availability zone for each subnet.
  map_public_ip_on_launch = false                                          # Disables public IP assignment on instance launch in this subnet ( as it is private subnet )

  tags = merge(
    {
      Name = "${var.project}-private-subnet-${count.index + 1}"
      #     "kubernetes.io/cluster/${var.project}-cluster" = "shared"
      #     "kubernetes.io/role/internal-elb"              = 1
    },
    var.tags
  )
}


# Creating Routing table for private subnet
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.this.id # Defining the vpc id in which private route table will be created

  tags = merge(
    {
      Name = "${var.project}-private-route-table"
    },
    var.tags
  )
}

# Providing route to private subnet using nat gateway
resource "aws_route" "route_to_nat_gw" {
  count                  = var.create_eip_for_natgw ? 1 : 0
  route_table_id         = aws_route_table.private_route_table.id # Defines private RT to be used for routing using NAT GW
  destination_cidr_block = "0.0.0.0/0"                            # any request to 0.0.0.0/0 will go via nat-gw ( means if instances 
  # in private subnets wants to go interent ( 0.0.0.0./0 ) will go first to nat gw then natgw will send this request to internet, 
  # but vice versa not possible using NAT GW, possible via load-balancers or bastion host)
  nat_gateway_id = aws_nat_gateway.this[0].id # Defines which nat gw to choose for routing 
}

# Associating Private Subnets with Route Table
resource "aws_route_table_association" "private_RTA" {
  route_table_id = aws_route_table.private_route_table.id               # Defines which route table id to take
  count          = length(var.private_subnets_cidr)                     # Creates an association for each private subnet
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index) # Subnet ID for association
}
