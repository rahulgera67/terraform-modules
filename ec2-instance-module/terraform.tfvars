aws_vpc_id    = "vpc-03db723cb372b51aa"
subnet_id     = "subnet-02a8f600ab4d6d3b3"
instance_type = "t4g.small"
full_path_of_public_key  = "/home/gera/.ssh/aws-ec2.pub"
# key_name = "terraform_aws_key"
# public_subnets_cidr  = ["10.0.0.0/20", "10.0.16.0/20", "10.0.32.0/20"]
# private_subnets_cidr = ["10.0.128.0/20", "10.0.144.0/20", "10.0.160.0/20"]
region            = "us-east-1"
availability_zone = "us-east-1c"
project           = "myproject"
ports             = ["80", "443", "22"]
root_ebs_volume = "8"
additional_ebs_volume = "2"
include_additional_volume = false
user_data_script_path = "./user-data-script.sh"
tags = {
  "ENV" = "dev"
}
