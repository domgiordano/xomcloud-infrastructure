# ========================================
# Outputs
# ========================================

output "ecr_authorizer_url" {
  value       = aws_ecr_repository.authorizer.repository_url
  description = "ECR repository URL for authorizer"
}

output "ecr_download_tracks_url" {
  value       = aws_ecr_repository.download_tracks.repository_url
  description = "ECR repository URL for download-tracks"
}

# output "ecs_cluster_name" {
#   description = "Name of the ECS cluster"
#   value       = aws_ecs_cluster.download_cluster.name
# }

# output "ecr_repository_url" {
#   description = "URL of the ECR repository"
#   value       = aws_ecr_repository.download_service.repository_url
# }

# output "alb_dns_name" {
#   description = "DNS name of the application load balancer"
#   value       = aws_lb.download_service.dns_name
# }

# output "download_service_url" {
#   description = "URL for the download service"
#   value       = "https://${aws_lb.download_service.dns_name}"
# }