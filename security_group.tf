resource "aws_security_group" "sg" {
  name        = "${local.name}-sg"
  description = "Allow outbound traffic"
  vpc_id      = aws_vpc.test.id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    // Allow traffic only from lb
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}