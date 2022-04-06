# Kinesis firehose delivery stream to s3
resource "aws_kinesis_firehose_delivery_stream" "webserver" {
  destination = "extended_s3"
  name        = "webserver"

  extended_s3_configuration {
    bucket_arn          = aws_s3_bucket.cloudwatch_logs_bucket.arn
    buffer_interval     = 300
    buffer_size         = 5
    compression_format  = "UNCOMPRESSED"
    error_output_prefix = "errors/"
    prefix              = ""
    role_arn            = aws_iam_role.firehose.arn
    s3_backup_mode      = "Disabled"

    processing_configuration {
      enabled = false
    }
  }
  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }
}
