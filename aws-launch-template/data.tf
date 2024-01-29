data "aws_key_pair" "key" {
  key_name           = "terraform_aws_key"
  include_public_key = true // if set true you can get public key in output, if you define in output.tf
  #   key_pair_id        = "key-0b9d0fd242b7a1394"
}


data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-arm64-ebs*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

}
