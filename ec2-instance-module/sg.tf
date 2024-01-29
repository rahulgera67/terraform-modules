# This Security group will reside in the vpc that we created in this project
# it can be used for ec2, elb etc in this region that is var.region
# This sg is using dynamic block to add,update,delete port 

resource "aws_security_group" "dynamic_sg" {
  name        = "${var.project}-sg"
  description = "Security group to allow inbound/outbound from the VPC"
  vpc_id      = var.aws_vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(
    {
      Name = "${var.project}-sg"
    },
    var.tags
  )

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"] // [aws_vpc.this.cidr_block] --> you can also use this to allow limited inbound traffic 
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
