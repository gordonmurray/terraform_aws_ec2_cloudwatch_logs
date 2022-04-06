#!/bin/bash
sudo mv /home/ubuntu/amazon-cloudwatch-agent.json /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
sudo service amazon-cloudwatch-agent restart