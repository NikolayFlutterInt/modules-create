#############################################
############## LOAD BALANCER ################
#############################################

resource "aws_lb" "load_balancer" {
  name               = "load-balancer-web"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_traffic_sg.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  enable_deletion_protection = false
  
  tags = {
    Name = "load-balancer-web"
  }
}

#############################################
############## LB TARGET GROUP ##############
#############################################
resource "aws_lb_target_group" "lb_target_group" {
  name     = "lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc_main.id
  
  tags = {
    Name = "lb-target-group"
  }
}

#############################################
############## LB LISTENER ##################
#############################################

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target_group.arn
  }
}

