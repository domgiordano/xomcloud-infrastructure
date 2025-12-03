# # ========================================
# # Application Load Balancer
# # ========================================

# resource "aws_lb" "download_service" {
#   name               = "${var.app_name}-download-alb"
#   internal           = false
#   load_balancer_type = "application"
#   security_groups    = [aws_security_group.alb_sg.id]
#   subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

#   enable_deletion_protection = false

#   tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-alb"}))
# }

# resource "aws_lb_target_group" "download_service" {
#   name        = "${var.app_name}-download-tg"
#   port        = 5000
#   protocol    = "HTTP"
#   vpc_id      = aws_vpc.main.id
#   target_type = "ip"

#   health_check {
#     enabled             = true
#     healthy_threshold   = 2
#     interval            = 30
#     matcher             = "200"
#     path                = "/api/health"
#     port                = "traffic-port"
#     protocol            = "HTTP"
#     timeout             = 5
#     unhealthy_threshold = 3
#   }

#   deregistration_delay = 30

#   tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-tg"}))
# }

# resource "aws_lb_listener" "download_service" {
#   load_balancer_arn = aws_lb.download_service.arn
#   port              = "443"
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
#   certificate_arn   = aws_acm_certificate.main.arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.download_service.arn
#   }
# }

# resource "aws_lb_listener" "download_service_http" {
#   load_balancer_arn = aws_lb.download_service.arn
#   port              = "80"
#   protocol          = "HTTP"

#   default_action {
#     type = "redirect"

#     redirect {
#       port        = "443"
#       protocol    = "HTTPS"
#       status_code = "HTTP_301"
#     }
#   }
# }