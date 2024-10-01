#resource "aws_launch_template" "web_a_g_template" {
#  name_prefix   = "web"
#  image_id      = var.web_ami
#  instance_type = "t2.micro"
#}


resource "aws_launch_configuration" "web_launch_configuration" {
  name            = "web-launch-configuration"
  image_id        = var.web_ami
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.web_ag_sg.id]

  iam_instance_profile = aws_iam_instance_profile.web_ag_instance_profile.name
  #iam_instance_profile = aws_iam_role.web_ag_role.id

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "web_a_g" {
  name                      = "web_a_g"
  max_size                  = 3
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  #placement_group           = aws_placement_group.test.id
  #launch_configuration      = aws_launch_configuration.foobar.name
  #vpc_zone_identifier = [ "${aws_subnet.public_subnets[*].id}" ]
  #vpc_zone_identifier = [ var.public_subnet_cidrs ]
  #vpc_zone_identifier = [ aws_vpc.main.id ]
  vpc_zone_identifier = aws_subnet.public_subnets[*].id
  #vpc_zone_identifier = [ element(aws_subnet.public_subnets[*].id, count.index) ]

  launch_configuration = aws_launch_configuration.web_launch_configuration.id

  instance_maintenance_policy {
    min_healthy_percentage = 90
    max_healthy_percentage = 120
  }

  #launch_template {
  #  id      = aws_launch_template.web_a_g_template.id
  #  version = "$Latest"
  #}

  # initial_lifecycle_hook {
  #   name                 = "foobar"
  #   default_result       = "CONTINUE"
  #   heartbeat_timeout    = 2000
  #   lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"
  #
  #    notification_metadata = jsonencode({
  #      foo = "bar"
  #    })

  #   notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
  #   role_arn                = "arn:aws:iam::123456789012:role/S3Access"
  # }
}



# Create a new load balancer
resource "aws_lb" "web_alb" {
  name = "web-alb"
  # availability_zones = var.azs
  subnets            = aws_subnet.public_subnets[*].id
  security_groups    = [aws_security_group.web_lb_sg.id]
  internal           = false
  load_balancer_type = "application"
  # access_logs {
  #   bucket        = "foo"
  #   bucket_prefix = "bar"
  #    interval      = 60
  #  }

  #  listener {
  #    instance_port     = 8000
  #    instance_protocol = "http"
  #    lb_port           = 80
  #    lb_protocol       = "http"
  #  }


  # health_check {
  #   healthy_threshold   = 2
  #   unhealthy_threshold = 2
  #   timeout             = 3
  #   target              = "HTTP:8000/"
  #   interval            = 30
  # }

  # instances                   = [aws_instance.foo.id]
  #cross_zone_load_balancing   = true
  #idle_timeout                = 400
  #connection_draining         = true
  #connection_draining_timeout = 400
  #
  enable_deletion_protection = false
  tags = {
    Name = "web-alb"
  }
}


resource "aws_lb_target_group" "web_target_group" {
  name     = "web-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
  health_check {
    port     = 8081
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_target_group.arn
  }
}

# Create a new load balancer attachment
resource "aws_autoscaling_attachment" "example" {
  autoscaling_group_name = aws_autoscaling_group.web_a_g.id
  #elb                    = aws_elb.web_elb.id
  lb_target_group_arn = aws_lb_target_group.web_target_group.arn
}
