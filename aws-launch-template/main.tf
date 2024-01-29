resource "aws_launch_template" "ecs_launch_template" {
  name          = var.launch_template_name
  image_id      = data.aws_ami.ecs_ami.id
  instance_type = var.instance_type
  description   = "This launch template is to launch ec2 spot instances for ecs cluster"

  key_name               = data.aws_key_pair.key.key_name
  vpc_security_group_ids = var.aws_security_group_ids

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_ec2_instance_profile.name
  }

  instance_market_options {
    market_type = "spot"
  }

  tags = merge(
    {
      Name             = "ecs_launch_template"
      Instance_request = "spot"
    },
    var.tags
  )


  # we are not specifying the block_device_mapping as volume will come from ami snapshot ( 30 GB default)
  # If we want to increase root volume comment out below block and provide volume size as ( lets say 40 GB )
  # If you dont specify device_name as --> /dev/xvda it will consider this as additional ebs volume not root volume
  # so /dev/xvda means root volume

  #   block_device_mappings {
  #       device_name = "/dev/xvda"

  #     ebs {
  #       delete_on_termination = "true"
  #       encrypted             = "false"
  #       # snapshot_id           = "snap-01ebbc4ab165f13f3"
  #       volume_size = "8"
  #       volume_type = "gp3"
  #     }
  #   }

  user_data = filebase64("${path.module}/user_data.sh")
}


resource "aws_iam_instance_profile" "ecs_ec2_instance_profile" {
  name = "ecsInstanceRole-Profile"
  role = aws_iam_role.this.name
}

resource "aws_iam_role" "this" {
  name = "ecsInstanceRole"

  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "ec2.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )

  tags = merge(
    {
      Name = "ecsInstanceRole"
    },
    var.tags
  )
}

resource "aws_iam_role_policy_attachment" "ecs_policy_attach" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}
