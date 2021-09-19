variable "aws_region" {
  type        = string
  description = "The AWS region to put the bucket into"
  default     = "eu-west-2"
}

variable "site_domain" {
  type        = string
  description = "The domain name to use for the static site"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "The zone id from Cloudflare"
}

variable "lambda_s3_bucket" {
  type        = string
  description = "The bucket to store files from the lambda function"
}

variable "artificial_bucket" {
  type        = string
  description = "The bucket to store the terraform state file"
}

variable "tf_log_bucket" {
  type        = string
  description = "The bucket to store access log files to from the other buckets"
}

variable "tf_user" {
  type        = string
  description = "The iam user used by terraform"
}

variable "auth_token" {
  type        = string
  description = "The authorization header token"
  sensitive   = true
}

variable "test_email_address" {
  type = string
  description = "Email address to recieve upload notifications"
}