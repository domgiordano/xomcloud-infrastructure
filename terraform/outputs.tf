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