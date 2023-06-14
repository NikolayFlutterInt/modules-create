resource "aws_security_group" "web_traffic_sg" {
  name   = "web-traffic-sg"
  vpc_id = aws_vpc.vpc_main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [lookup(var.cidr_block, "trusted_ip")]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [lookup(var.cidr_block, "default_route")]

  }

}

resource "aws_security_group" "intra_vpc_sg" {
  name   = "intra-vpc-sg"
  vpc_id = aws_vpc.vpc_main.id

  ingress {
    description     = "Traffic from http security group"
    from_port       = 80
    to_port         = 80
    protocol        = "TCP"
    security_groups = [aws_security_group.web_traffic_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [lookup(var.cidr_block, "default_route")]
  }
}