data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.public_key.key_name
  #   key_name               = var.key_name // we can add this if want to attach keys from aws
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.dynamic_sg.id]
  availability_zone      = var.availability_zone

  tags = merge(
    {
      Name = "${var.project}-ec2"
    },
    var.tags
  )

  # Specify the root EBS volume
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_ebs_volume # specify your desired size in GB
    delete_on_termination = true
  }

  # Attach an additional EBS volume
  dynamic "ebs_block_device"{
    for_each = var.include_additional_volume ? [1] : []
    content {
    device_name           = "/dev/sdh" # specify the desired name
    volume_type           = "gp3"
    volume_size           = var.additional_ebs_volume # specify your desired size in GB
    delete_on_termination = true
    }
  } 

  # Include the user script from a file
  # user_data = file("${path.module}/user-data-script.sh") #${path.module} --> means main foler where main.tf is
  user_data = file("${var.user_data_script_path}")
}
