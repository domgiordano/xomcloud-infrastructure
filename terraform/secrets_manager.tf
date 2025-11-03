# ========================================
# Secrets Manager for SoundCloud Credentials
# ========================================

resource "aws_secretsmanager_secret" "soundcloud_credentials" {
  name        = "${var.app_name}-soundcloud-credentials"
  description = "SoundCloud API credentials"

  tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-soundcloud-credentials"}))
}

resource "aws_secretsmanager_secret_version" "soundcloud_credentials" {
  secret_id = aws_secretsmanager_secret.soundcloud_credentials.id
  secret_string = jsonencode({
    client_id     = var.soundcloud_client_id
    client_secret = var.soundcloud_client_secret
  })
}