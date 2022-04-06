resource "aws_s3_bucket_public_access_block" "cloudwatch_logs_bucket_access" {
  bucket                  = aws_s3_bucket.cloudwatch_logs_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket" "cloudwatch_logs_bucket" {
  bucket        = "ec2-webserver-logs-bucket"
  acl           = "private"
  force_destroy = false

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  versioning {
    enabled    = true
    mfa_delete = false
  }

  lifecycle_rule {
    id                                     = "change-storage-class"
    enabled                                = true
    abort_incomplete_multipart_upload_days = 30
    tags                                   = {}

    transition {
      days          = 14
      storage_class = "GLACIER"
    }

  }
}
