resource "aws_autoscaling_schedule" "scale_down_weekdays" {
  count                  = var.asg_action_enabled ? 1 : 0
  scheduled_action_name  = "scale-down-weekdays"
  min_size               = 0
  max_size               = 0
  desired_capacity       = 0
  recurrence             = "0 22 * * MON-FRI"
  time_zone              = "Asia/Kolkata"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
  start_time             = "2024-01-23T01:30:00Z" // starting time is 09-January-2024 at 01:30 UTC  ( 01:30 UTC = 01:30 + 5:30 = 6:00 IST )
}

resource "aws_autoscaling_schedule" "scale_up_weekdays" {
  count                  = var.asg_action_enabled ? 1 : 0
  scheduled_action_name  = "scale_up_weekdays"
  min_size               = 1
  max_size               = 1
  desired_capacity       = 0
  recurrence             = "0 10 * * MON-FRI"
  time_zone              = "Asia/Kolkata"
  autoscaling_group_name = aws_autoscaling_group.ecs_asg.name
  start_time             = "2024-01-23T01:30:00Z" // starting time is 09-January-2024 at 01:30 UTC  ( 01:30 UTC = 01:30 + 5:30 = 6:00 IST )
}
