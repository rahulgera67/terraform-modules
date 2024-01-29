resource "aws_key_pair" "public_key" {
  key_name   = "${var.project}-key"
  public_key = file("${var.full_path_of_public_key}")
  tags = {
    Name        = "${var.project}-key"
    # Environment = "dev"
  }
}

output "public_key" {
  value       = aws_key_pair.public_key.public_key
  sensitive   = true
}
