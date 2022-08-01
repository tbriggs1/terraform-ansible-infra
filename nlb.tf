

resource "aws_lb" "main-nw-lb" {
  name = "main-nw-lb"
  internal = false
  load_balancer_type = "network"
  

  enable_deletion_protection = false

  subnet_mapping {
    subnet_id = aws_subnet.main-public-1.id
    allocation_id = "eipalloc-064918cb1b9be04f5"
  }


  tags = { 
    Environment = "production"
  }

}

resource "aws_lb_target_group" "nlb_tg" {
  name = "nlb-main-tg"
  port = 80
  protocol = "TCP"
  vpc_id = aws_vpc.main.id
  target_type = "alb"
}

resource "aws_lb_target_group" "nlb_tg_https" {
  name = "nlb-main-tg-https"
  port = 81
  protocol = "TCP"
  vpc_id = aws_vpc.main.id
  target_type = "alb"
}

resource "aws_lb_target_group_attachment" "tg_attachment_https" {
  target_group_arn = aws_lb_target_group.nlb_tg_https.arn
  target_id = module.alb.lb_arn

  port = 81
}

resource "aws_lb_target_group_attachment" "tg_attachment" {
  target_group_arn = aws_lb_target_group.nlb_tg.arn
  target_id = module.alb.lb_arn

  port = 80
}

resource "aws_lb_listener" "alb_listener" {
 load_balancer_arn = aws_lb.main-nw-lb.arn
 port = "80"
 protocol = "TCP"

 default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.nlb_tg.arn
 }
}

resource "aws_lb_listener" "alb_listener_secure81" {
 load_balancer_arn = aws_lb.main-nw-lb.arn
 port = "81"
 protocol = "TCP"

 default_action {
   type = "forward"
   target_group_arn = aws_lb_target_group.nlb_tg_https.arn
 }
}