variable "launch_template_name" {
  type        = string
  description = "Name of launch template"
}

variable "instance_type" {
  type = string
}

variable "aws_security_group_ids" {
  type    = list(string)
  default = ["sg-04d6ed556093a810c", "sg-05f84e59f48cca8ad"]
}

variable "tags" {
  type = map(string)
}
