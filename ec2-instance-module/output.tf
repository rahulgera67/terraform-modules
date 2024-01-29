output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}

output "aws_instance_key_name" {
  value = aws_instance.web.key_name
}

output "aws_instance_public_dns" {
  value = aws_instance.web.public_dns
}

output "aws_instance_public_ip" {
  value = aws_instance.web.public_ip
}

output "aws_instance_private_ip" {
  value = aws_instance.web.private_ip
}

output "aws_instance_private_dns" {
  value = aws_instance.web.private_dns
}

output "aws_security_group_id" {
  value = aws_security_group.dynamic_sg.id
}

