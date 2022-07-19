

module "alb" {
    source  = "terraform-aws-modules/alb/aws"
    version = "~> 6.0"

    name = "main-alb"

    load_balancer_type = "application"

    vpc_id = "${aws_vpc.main.id}"
    subnets = [ "${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}", "${aws_subnet.main-public-3.id}" ]
    security_groups = [ "${aws_security_group.allow-http.id}" ]
    
    target_groups = [
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "${aws_instance.ansible_target_1.id}"
          port = 80
        }
      ]
    },
    {
      name_prefix      = "pref-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = [
        {
          target_id = "${aws_instance.ansible_target_2.id}"
          port = 80
        }
      ]
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
     {
      port               = 81
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]
}