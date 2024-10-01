output "bot_access_key_id" {
  description = "User access key id."
  value       = aws_iam_access_key.bot.id
}

output "bot_access_key_secret" {
  description = "User access key secret."
  value       = aws_iam_access_key.bot.secret
  sensitive   = true
}

output "ecr_repo_app" {
  description = "ECR repository url for the app docker image."
  value       = aws_ecr_repository.app.repository_url
}
