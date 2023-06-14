#############################################
############ LAUNCH TEMPLATE ################
#############################################

resource "aws_launch_template" "webserver_template" {
  name_prefix            = "nginx-webserver-template"
  image_id               = var.ami_id
  instance_type          = var.instance_type
  update_default_version = true
  iam_instance_profile {
    name = aws_iam_instance_profile.iam_instance_profile.name
  }

  vpc_security_group_ids = [aws_security_group.intra_vpc_sg.id]

  user_data = base64encode(
    <<-EOF
    #!/bin/bash
    amazon-linux-extras install -y nginx1
    systemctl enable nginx --now
    EOF
  )
  tags = {
    Name = "nginx-webserver-template"
  }
}

#############################################
################## ROLES ####################
#############################################

resource "aws_iam_role" "ec2_ssm_role" {
  name = "es2-ssm-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ssm_role_policy_attach" {
  role       = aws_iam_role.ec2_ssm_role.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "instance-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

