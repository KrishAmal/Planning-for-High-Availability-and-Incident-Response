output "aws_instance" {
  value = aws_instance.Ubuntu-Web
}

output "ec2_sg" {
  value = aws_security_group.ec2_sg.id
}
