// Create this launch template to create ec2 instance with code and apache
resource "aws_launch_template" "wawa_test" {
  name = "wawa-test"

 // Dont need this for now 
//   block_device_mappings {
//     device_name = "/dev/sda1"

//     ebs {
//       volume_size = 8
//     }
//   }

  credit_specification {
    cpu_credits = "standard"
  }

  // Dont really need this for testing 
  disable_api_termination = false

  ebs_optimized = false

  iam_instance_profile {
    arn = aws_iam_instance_profile.test_profile.arn
  }

  image_id = data.aws_ami.amazon-linux-2.image_id

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = "t2.micro"

  key_name = local.key_name

  // Could be useful 
  monitoring {
    enabled = true
  }

  network_interfaces {
    subnet_id = aws_subnet.private_1.id
    security_groups = [aws_security_group.sg.id]
  }

  placement {
    availability_zone = "us-east-1a"
  }

  //vpc_security_group_ids = [aws_security_group.sg.id]

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = local.name
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}

resource "aws_autoscaling_group" "test" {
  name               = "${local.name}-asg"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_type  = "ELB"
  target_group_arns  = [aws_lb_target_group.test.arn]
  launch_template {
    id      = aws_launch_template.wawa_test.id
    version = "$Latest"
  }
  vpc_zone_identifier = [aws_subnet.private_1.id, aws_subnet.private_2.id]
}
