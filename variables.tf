# Variables used
variable "my_ip_address" {
  type        = string
  description = "Your current IP address so you can SSH in to instances"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID, needed for Kinesis firehose"
}
