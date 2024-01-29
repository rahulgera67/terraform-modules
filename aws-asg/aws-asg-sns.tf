resource "aws_sns_topic" "this" {
  name = "spartans-topic"
}

resource "aws_sns_topic_subscription" "email_subscription1" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "rgera0901@gmail.com"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_sns_topic_subscription" "email_subscription2" {
  topic_arn = aws_sns_topic.this.arn
  protocol  = "email"
  endpoint  = "rahulgera417@gmail.com"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_notification" "this" {
  group_names = [aws_autoscaling_group.ecs_asg.name]

  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
  ]

  topic_arn = aws_sns_topic.this.arn
}
