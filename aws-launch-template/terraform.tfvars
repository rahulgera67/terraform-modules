launch_template_name   = "ecs_launch_template"
instance_type          = "t4g.small"
aws_security_group_ids = ["sg-062cb8e84c68ffd41"]
tags = {
  environment = "dev"
  project     = "rolex"
}
