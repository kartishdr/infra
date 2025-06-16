provider "aws" {
  region = "us-east-1" # Change as needed
}

# Get default VPC
data "aws_vpc" "selected" {
  default = true
}

# Get subnets in the default VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.selected.id]
  }
}

# Fetch Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"]
}

# 2. EC2 Instance
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"  # Replace with desired instance type
  subnet_id     = data.aws_subnets.public.ids[0]

  tags = {
    Name = "example-ec2"
  }
}

# 3. ECR Repository
resource "aws_ecr_repository" "this" {
  name = "my-ecr-repo"  # Replace with your preferred name
}

# 4. ECS Cluster
resource "aws_ecs_cluster" "this" {
  name = "my-ecs-cluster"  # Replace as needed
}

# 5. Application Load Balancer
resource "aws_lb" "this" {
  name               = "my-alb"  # Replace with desired name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [] # You can add SGs via data if needed
  subnets            = data.aws_subnets.public.ids
}

