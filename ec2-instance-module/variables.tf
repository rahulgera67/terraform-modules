variable "aws_vpc_id" {
  description = "The CIDR block of the vpc"
}

variable "subnet_id" {
  description = "The CIDR block of the vpc"
}
variable "instance_type" {
  description = "The CIDR block of the vpc"
  type        = string
}

variable "full_path_of_public_key" {
  description = "Path of pub key to be used for ec2"
  type = string
  default = "/home/gera/.ssh/aws-ec2.pub"
}
# variable "public_subnets_cidr" {
#   type        = list(any)
#   description = "The CIDR block for the public subnet"
# }

# variable "private_subnets_cidr" {
#   type        = list(any)
#   description = "The CIDR block for the private subnet"
# }

variable "region" {
  description = "Region in which vpc & other resources will be created"
  type = string
  default = "us-east-1"
}

variable "availability_zone" {
  type        = string
  description = "The az that the resources will be launched"
}

variable "project" {
  description = "Enter your project name"
}

variable "ports" {
  description = "Enter the port numbers"
  type        = list(any)
}

variable "root_ebs_volume" {
  description = "Root ebs volume for ec2"
  type = string
  default = "8"
}

variable "additional_ebs_volume" {
  description = "additional ebs volume for ec2 ( if required )"
  default = "2"
}

variable "include_additional_volume" {
  description = "Provide input in true or false to create additional ebs volume"
  type = bool
  default = false
}

# variable "key_name" {
#   description = "Key name that is already created and available in aws"
#   type        = string
#   default     = "my-key-pair"
# }

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default = {
    "Environment" = "QA"
  }
}

variable "user_data_script_path" {
  description = "path of user data script"
  default = "./user-data-script.sh"
  type = string
}

variable "profile" {
  type = string
}
