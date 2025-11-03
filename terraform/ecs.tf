# ========================================
# ECS Cluster for Download Service
# ========================================

resource "aws_ecs_cluster" "download_cluster" {
  name = "${var.app_name}-download-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-cluster"}))
}

# ========================================
# ECR Repository for Download Service Image
# ========================================

resource "aws_ecr_repository" "download_service" {
  name                 = "${var.app_name}-download-service"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-service"}))
}

# ========================================
# ECS Task Definition
# ========================================

resource "aws_ecs_task_definition" "download_service" {
  family                   = "${var.app_name}-download-service"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "2048"  # 2 vCPU
  memory                   = "4096"  # 4 GB
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "download-service"
      image     = "${aws_ecr_repository.download_service.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
          protocol      = "tcp"
        }
      ]

      environment = [
        {
          name  = "SOUNDCLOUD_CLIENT_ID"
          value = var.soundcloud_client_id
        },
        {
          name  = "SOUNDCLOUD_CLIENT_SECRET"
          value = var.soundcloud_client_secret
        },
        {
          name  = "APP_ENV"
          value = "production"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_download_service.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:5000/api/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-service"}))
}

# ========================================
# ECS Service
# ========================================

resource "aws_ecs_service" "download_service" {
  name            = "${var.app_name}-download-service"
  cluster         = aws_ecs_cluster.download_cluster.id
  task_definition = aws_ecs_task_definition.download_service.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.download_service.arn
    container_name   = "download-service"
    container_port   = 5000
  }

  depends_on = [aws_lb_listener.download_service]

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-service"}))
}

# ========================================
# S3 Bucket for Download Storage (Optional)
# ========================================

resource "aws_s3_bucket" "downloads" {
  bucket = "${var.app_name}-downloads-${data.aws_caller_identity.web_app_account.account_id}"

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-downloads"}))
}

resource "aws_s3_bucket_lifecycle_configuration" "downloads" {
  bucket = aws_s3_bucket.downloads.id

  rule {
    id     = "delete-old-downloads"
    status = "Enabled"

    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_public_access_block" "downloads" {
  bucket = aws_s3_bucket.downloads.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ========================================
# Outputs
# ========================================

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.download_cluster.name
}

output "ecr_repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.download_service.repository_url
}

output "alb_dns_name" {
  description = "DNS name of the application load balancer"
  value       = aws_lb.download_service.dns_name
}

output "download_service_url" {
  description = "URL for the download service"
  value       = "https://${aws_lb.download_service.dns_name}"
}