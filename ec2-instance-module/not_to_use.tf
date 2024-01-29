# resource "aws_security_group" "mysg" {
#     vpc_id = var.aws_vpc_id
#     description = "aj"
#     name = "mysg-1"

#     tags = merge(
#         {
#             Name = "my-sg-1"
#         },
#         var.tags
#     )

#     lifecycle {
#       create_before_destroy = true
#     }

#     egress = {
#         from_port = 0
#         to_port = 0
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     dynamic "ingress" {
#       for_each = var.ports
#       iterator = "port"
#       content {
#         from_port = port.value
#         to_port = port.value
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#       }
#     }
# }
