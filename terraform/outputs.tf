output "website_bucket_name" {
  description = "Name (id) of the bucket"
  value       = aws_s3_bucket.app_bucket.id
}

output "bucket_endpoint" {
  description = "Bucket endpoint"
  value       = aws_s3_bucket.app_bucket.website_endpoint
}

output "domain_name" {
  description = "Website endpoint"
  value       = var.site_domain
}

output "webhook_secret" {
  description = "Webhook secret"
  value       = random_password.webhook_secret.result
  sensitive   = true
}

output "webhook_url" {
  description = "Webhook endpoint URL"
  value       = aws_codepipeline_webhook.codepipeline_github_webhook.url
}