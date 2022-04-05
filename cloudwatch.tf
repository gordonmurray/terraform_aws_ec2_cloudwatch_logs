// Cloudwatch log group for webserver logs
resource "aws_cloudwatch_log_group" "webserver_logs" {
  name              = "access.log"
  retention_in_days = 3
}

# Cloudwatch Subscription to process a Cloudwatch log group
resource "aws_cloudwatch_log_subscription_filter" "subscription" {
  name            = "cloudwatch-to-kinesis-firehose"
  role_arn        = aws_iam_role.cloudwatch_firehose.arn
  log_group_name  = "access.log"
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.rds_audit.arn
  distribution    = "Random"
}
