output "ecs_ami_id" {
  value = data.aws_ami.ecs_ami.id
}

output "public_key" {
  value = data.aws_key_pair.key.public_key
}
