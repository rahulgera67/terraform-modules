vpc_cidr             = "10.0.0.0/16"
public_subnets_cidr  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
private_subnets_cidr = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
region               = "us-east-1"
availability_zones   = ["us-east-1a", "us-east-1b", "us-east-1c"]
project              = "myproject"
tags = {
  "ENV" = "dev"
}
create_eip_for_natgw = false
# create_nat_gateway = false
