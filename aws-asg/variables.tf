variable "asg_name" {
  type    = string
  default = "spartans-asg"
}

variable "launch_template_id" {
  type    = string
  default = "lt-07684ee279ef3b329"
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "subnet_ids" {
  type    = list(string)
  default = ["subnet-05d782c15b5a50f1e", "subnet-09d740546274e63b4"]
}

variable "desired_capacity" {
  type    = number
  default = 0
}

variable "max_size" {
  type    = number
  default = 1
}

variable "min_size" {
  type    = number
  default = 0
}

variable "health_check_type" {
  type        = string
  description = "The health check type for the Auto Scaling group (ELB or EC2)."
  default     = "EC2"

  validation {
    condition     = var.health_check_type == "ELB" || var.health_check_type == "EC2"
    error_message = "Invalid health check type. Must be either 'ELB' or 'EC2'."
  }
}

variable "min_healthy_percentage" {
  type    = number
  default = 100
}

variable "max_healthy_percentage" {
  type    = number
  default = 150
}

variable "asg_action_enabled" {
  type    = bool
  default = false
  description = "If this set to true, asg scheduling actions will be created in asg"
}

variable "attach_lb_with_asg" {
  type = bool
  default = false
}

variable "load_balancer_arn" {
  type = string
  default = "value"
}
