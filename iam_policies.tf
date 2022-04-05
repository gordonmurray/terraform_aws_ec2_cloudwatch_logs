data "aws_region" "current" {}

resource "aws_iam_role_policy" "webserver" {
  name   = "webserver-policy"
  role   = aws_iam_role.assume_role.id
  policy = data.template_file.webserver_policy.rendered
}

resource "aws_iam_policy" "firehose" {
  name   = "webserver-firehose"
  path   = "/service-role/"
  policy = data.template_file.firehose_service_role_policy.rendered
}

data "template_file" "firehose_service_role_policy" {
  template = file("./files/firehose.template")
  vars = {
    bucket        = aws_s3_bucket.cloudwatch_logs_bucket.bucket
    firehose_name = "webserver-firehose"
    region        = data.aws_region.current.name
    aws_account_id = var.aws_account_id
  }
}

data "template_file" "webserver_policy" {
  template = file("./files/webserver.template")
}
