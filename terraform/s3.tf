resource "aws_s3_bucket" "artificial_bucket" {
  bucket = var.artificial_bucket
  tags   = {}

  server_side_encryption_configuration {
    rule {
      bucket_key_enabled = false

      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }

  logging {
    target_bucket = aws_s3_bucket.tf_log_bucket.id
    target_prefix = "log/${var.artificial_bucket}"
  }
}

resource "aws_s3_bucket" "app_bucket" {
  bucket = var.site_domain
  acl    = "public-read"
  tags   = {}

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }

  logging {
    target_bucket = aws_s3_bucket.tf_log_bucket.id
    target_prefix = "log/${var.site_domain}"
  }
}

resource "aws_s3_bucket" "tf_log_bucket" {
  bucket = var.tf_log_bucket
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket" "lambda_s3_bucket" {
  bucket = var.lambda_s3_bucket
  versioning {
    enabled    = false
    mfa_delete = false
  }

  logging {
    target_bucket = aws_s3_bucket.tf_log_bucket.id
    target_prefix = "log/${var.lambda_s3_bucket}"
  }
}