resource "aws_autoscaling_group" "app_asg" {

  name                = "train-app-asg"
  vpc_zone_identifier = data.aws_subnets.default.ids

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  target_group_arns = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_launch_template.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 60

  instance_refresh {

    strategy = "Rolling"

    preferences {
      min_healthy_percentage = 50
      instance_warmup        = 60
    }

    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "train-app-instance"
    propagate_at_launch = true
  }
}
