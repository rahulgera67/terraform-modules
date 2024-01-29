resource "aws_autoscaling_group" "ecs_asg" {
  name = var.asg_name

  launch_template {
    id = var.launch_template_id
    # name    = "workers-ecs-ec2-spot-template"  // no need of this as id of launch template is sufficient
    version = "$Latest" // it uses the latest version of launch template in ASG
  }

  # availability_zones  = var.availability_zones // no need of this is subnet Ids is choosen already 
  vpc_zone_identifier = var.subnet_ids # instance to launch in these subnets ( based on AZ )

  desired_capacity = var.desired_capacity
  max_size         = var.max_size
  min_size         = var.min_size

  lifecycle {   // this is added as it is handled by asg autoscaling
    ignore_changes = [ 
      max_size, min_size, desired_capacity
     ]
  }

  default_cooldown        = "300"
  default_instance_warmup = "300"
  protect_from_scale_in   = "false" // use this as false otherwise instances will not scale in

  force_delete              = "false" // if this set to true, tf can delete asg even before destroying ec2 
  health_check_grace_period = "300"
  health_check_type         = var.health_check_type # choose ELB --> if this is attached to ELB ( IF ELB choosen, then ELB + EC2 both health checkups
  # will be enabled otherwise if health_check_type not choosen, by default ec2 will be enabled)

  instance_maintenance_policy {
    max_healthy_percentage = var.max_healthy_percentage
    min_healthy_percentage = var.min_healthy_percentage
  }

  wait_for_capacity_timeout = "10m"  // default 
  capacity_rebalance        = "true" // this is necessary in case of spot ec2s

  tag {
    key                 = "AmazonECSManaged"
    propagate_at_launch = "true"
    value               = "ECS"
  }

  tag {
    key                 = "ECS_CLUSTER"
    propagate_at_launch = "true"
    value               = "workers"
  }

  tag {
    key                 = "Instance_type"
    propagate_at_launch = "true"
    value               = "spot"
  }

  tag {
    key                 = "Name"
    propagate_at_launch = "true"
    value               = "workers-spot-ec2"
  }

}

# This reosurce will handle autoscaling policy for that ec2s created by asg
resource "aws_autoscaling_policy" "cpu_utilization" {
  name                      = "cpu-utilization-tracking"
  policy_type               = "TargetTrackingScaling"
  autoscaling_group_name    = aws_autoscaling_group.ecs_asg.name
  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}


# This will attach target groups ( ALB/NLB target groups) to Autoscaling Group
resource "aws_autoscaling_attachment" "example" {
  count = var.attach_lb_with_asg ? 1 : 0 
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.id
  lb_target_group_arn    = var.load_balancer_arn
}
