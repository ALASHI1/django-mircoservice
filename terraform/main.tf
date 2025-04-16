provider "aws" {
  region = "eu-north-1" # change to your preferred region
}


data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "dj_docker_sg" {
  name        = "dj-docker-sg"
  description = "Security group for EC2 instance"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "MyEC2SecurityGroup"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.dj_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  description       = "Allow SSH access"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.dj_docker_sg.id
  ip_protocol       = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "django" {
  security_group_id = aws_security_group.dj_docker_sg.id
  ip_protocol       = "tcp"
  from_port         = 8000
  to_port           = 8000
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.dj_docker_sg.id
  ip_protocol       = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_ipv4         = "0.0.0.0/0"
}

# Egress rule: Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.dj_docker_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}

# create an EC2 instance
resource "aws_instance" "dj_docker" {
  ami           = "ami-0274f4b62b6ae3bd5"
  instance_type = "t3.micro"

  key_name               = "django-docker"
  vpc_security_group_ids = [aws_security_group.dj_docker_sg.id]
  iam_instance_profile = aws_iam_instance_profile.cloudwatch_profile.name

  user_data = file("${path.module}/cloudwatch_user_data.sh")
  monitoring   = true


  tags = {
    Name = "MyAmazonLinuxEC2"
  }
}


#cloudwatch

resource "aws_iam_role" "dj_docker_cloudwatch_role" {
  name = "dj_docker-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "cloudwatch_logs_attach" {
  role       = aws_iam_role.dj_docker_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.dj_docker_cloudwatch_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "cloudwatch_profile" {
  name = "dj_docker-cloudwatch-profile"
  role = aws_iam_role.dj_docker_cloudwatch_role.name
}

resource "aws_cloudwatch_log_group" "dj_docker_log_group" {
  name              = "/aws/ec2/dj_docker-log-group"
  retention_in_days = 30
}


resource "aws_eip" "dj_docker_eip" {
  domain = "vpc"
}


resource "aws_eip_association" "dj_docker_eip_assoc" {
  instance_id   = aws_instance.dj_docker.id
  allocation_id = aws_eip.dj_docker_eip.id
}