# Use Terraform to create a webserver on AWS with logs sent to Cloudwatch

Creates everything from a VPC, subnets, route tables all the way up to an EC2 instance, with Apache webserver logs sent to Cloudwatch

### Cost estimate

Powered by Infracost.

```

 Name                                                 Monthly Qty  Unit   Monthly Cost

 aws_instance.example
 ├─ Instance usage (Linux/UNIX, on-demand, t3.micro)          730  hours         $8.32
 └─ root_block_device
    └─ Storage (general purpose SSD, gp2)                      10  GB            $1.10

 OVERALL TOTAL                                                                   $9.42
──────────────────────────────────
15 cloud resources were detected:
∙ 1 was estimated, it includes usage-based costs, see https://infracost.io/usage-file
∙ 14 were free, rerun with --show-skipped to see details                                                               $9.42
 ```