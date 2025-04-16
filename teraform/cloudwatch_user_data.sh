#!/bin/bash
# Install CloudWatch Agent
yum update -y
yum install -y amazon-cloudwatch-agent

# Configure CloudWatch Agent
cat <<'CONFIG' > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/syslog",
            "log_group_name": "${aws_cloudwatch_log_group.dj_docker_log_group.name}",
            "log_stream_name": "{instance_id}"
          }
        ]
      }
    }
  }
}
CONFIG

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json