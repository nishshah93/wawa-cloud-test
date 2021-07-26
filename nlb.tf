resource "aws_eip" "nlb_sub1" {
  tags = {
    Name = "eip1"
  }
}

resource "aws_eip" "nlb_sub2" {
  tags = {
    Name = "eip2"
  }
}

resource "aws_lb" "load_balancer" {
  name               = "${local.name}-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id     = aws_subnet.public_1.id
    allocation_id = aws_eip.nlb_sub1.id
  }

  subnet_mapping {
    subnet_id     = aws_subnet.public_2.id
    allocation_id = aws_eip.nlb_sub2.id
  }

  access_logs {
    bucket  = aws_s3_bucket.cw_bucket.bucket
    enabled = true
    prefix  = "${local.name}-alb"
  }
}

resource "aws_lb_target_group" "test" {
  name                 = "${local.name}-tg"
  port                 = 80
  protocol             = "TCP"
  target_type          = "instance"
  vpc_id               = aws_vpc.test.id
  deregistration_delay = 60
}


resource "aws_lb_listener" "ip" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.test.arn
  }

  lifecycle {
    ignore_changes = [
      default_action,
    ]
  }
}


