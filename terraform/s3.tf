resource "aws_s3_bucket" "artificial_bucket" {
  bucket = "richardnpaul-tf"
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
    target_bucket = aws_s3_bucket.richardnpaul_tf_log_bucket.id
    target_prefix = "log/richardnpaul-tf"
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
    target_bucket = aws_s3_bucket.richardnpaul_tf_log_bucket.id
    target_prefix = "log/richardnpaul-tf-app"
  }
}

resource "aws_s3_bucket" "richardnpaul_tf_log_bucket" {
  bucket = "richardnpaul-tf-log-bucket"
  acl    = "log-delivery-write"
}