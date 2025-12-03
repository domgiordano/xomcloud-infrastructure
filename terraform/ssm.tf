# AWS
resource "aws_ssm_parameter" "access_key"{
    name        = "/${var.app_name}/aws/ACCESS_KEY"
    description = "AWS Access Key"
    type        = "SecureString"
    value       = var.access_key
    tags        = merge(local.standard_tags, tomap({"name" = "${var.app_name}-aws-access-key"}))
}
resource "aws_ssm_parameter" "secret_key"{
    name        = "/${var.app_name}/aws/SECRET_KEY"
    description = "AWS Secret Key"
    type        = "SecureString"
    value       = var.secret_key
    tags        = merge(local.standard_tags, tomap({"name" = "${var.app_name}-aws-secret-key"}))
}

# SOUNDCLOUD
resource "aws_ssm_parameter" "soundcloud_client_id"{
    name        = "/${var.app_name}/soundcloud/CLIENT_ID"
    description = "Soundcloud Web API Client ID"
    type        = "SecureString"
    value       = var.soundcloud_client_id
    tags        = merge(local.standard_tags, tomap({"name" = "${var.app_name}-soundcloud-client-id"}))
}
resource "aws_ssm_parameter" "soundcloud_client_secret"{
    name        = "/${var.app_name}/soundcloud/CLIENT_SECRET"
    description = "SoundCloud API Client Secret"
    type        = "SecureString"
    value       = var.soundcloud_client_secret
    tags        = merge(local.standard_tags, tomap({"name" = "${var.app_name}-soundcloud-client-secret"}))
}
