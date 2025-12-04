# resource "aws_lambda_function" "download_tracks" {

#   function_name     = "${var.app_name}-download-tracks"
#   package_type      = "Image"
#   image_uri         = "${aws_ecr_repository.download_tracks.repository_url}:latest"
#   handler           = "handler.handler"
#   runtime           = var.lambda_runtime
#   memory_size       = 1024
#   timeout           = 300
#   role              = aws_iam_role.lambda_role.arn
#   environment {
#     variables = merge(local.lambda_variables, { S3_DOWNLOAD_BUCKET_NAME = aws_s3_bucket.downloads.id })
#   }

#   vpc_config {
#     subnet_ids         = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]
#     security_group_ids = [aws_security_group.lambda_sg.id]
#   }

#   tags = merge(local.standard_tags, tomap({"name" = "${var.app_name}-download-tracks"}))



#   tracing_config {
#     mode = var.lambda_trace_mode
#   }



#   lifecycle {
#     ignore_changes = [
#       description,
#       filename,
#       source_code_hash,
#       layers
#     ]
#   }

#   depends_on = [
#     aws_iam_role_policy.lambda_role_policy,
#     aws_iam_role.lambda_role
#   ]
# }