#############################################
############ AUTO SCAKING GROUP #############
#############################################

resource "aws_autoscaling_group" "autoscaling_group_webserver" {
  name_prefix         = "autoscaling_group_webserver"
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  vpc_zone_identifier = [aws_subnet.private_subnet_3.id, aws_subnet.private_subnet_4.id]
  target_group_arns   = [aws_lb_target_group.lb_target_group.arn]
  launch_template {
    id      = aws_launch_template.webserver_template.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "auto-scaled-instances"
    propagate_at_launch = true
  }
}

#############################################
############ AUTO SCAKING POLICY ############
#############################################

resource "aws_autoscaling_policy" "autoscalinng_policy" {
  name                   = "autoscalinng-policy"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group_webserver.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 4
}

#############################################
############ AUTO POLICY ATTACH #############
#############################################

resource "aws_autoscaling_attachment" "asg_attachment_lb" {
  autoscaling_group_name = aws_autoscaling_group.autoscaling_group_webserver.id
  lb_target_group_arn    = aws_lb_target_group.lb_target_group.arn
}


#############################################
############### CLOUDWATCH ##################
#############################################

resource "aws_cloudwatch_metric_alarm" "cloudwatch_check_cpu" {
  alarm_name          = "check-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 60
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric is responsible for tracking the CPU utilization of EC2 instances."
  alarm_actions       = [aws_autoscaling_policy.autoscalinng_policy.arn]

  tags = {
    Name = "check-cpu-alarm"
  }
}


