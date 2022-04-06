resource "aws_iam_role" "assume_role" {
  name               = "webserver-role"
  assume_role_policy = data.template_file.webserver_role.rendered
}

resource "aws_iam_instance_profile" "webserver" {
  name = "webserver-instance-proile"
  role = aws_iam_role.assume_role.name
}

resource "aws_iam_role" "firehose" {
  name = "webserver-firehose"
  path = "/service-role/"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "firehose.amazonaws.com"
          }
        },
      ]
      Version = "2012-10-17"
    }
  )
  force_detach_policies = false
  managed_policy_arns = [
    aws_iam_policy.firehose.arn
  ]
  max_session_duration = 3600
}

resource "aws_iam_role" "cloudwatch_firehose" {
  name = "webserver-cw-firehose"
  assume_role_policy = jsonencode(
    {
      Statement = [
        {
          Action = "sts:AssumeRole"
          Effect = "Allow"
          Principal = {
            Service = "s3.amazonaws.com"
          }
        }
      ]
      Version = "2012-10-17"
    }
  )
  description           = "Allow Cloudwatch subscriptions to deliver firehose streams"
  force_detach_policies = false
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonKinesisFirehoseFullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
  ]
  max_session_duration = 3600
}


data "template_file" "webserver_role" {
  template = file("./files/webserver_role.template")
}

data "template_file" "firehose_policy" {
  template = file("./files/firehose_policy.template")
}

