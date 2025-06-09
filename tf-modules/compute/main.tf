data "aws_vpc" "selected" {
  default = true
}


# 2. Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
  tags = { 
    Name = "demo-igw"
  }
}

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


resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.ec2_instance_type
  subnet_id     = var.public_subnets[0]

  tags = {
    Name = "example-ec2"
  }
}
resource "aws_ecr_repository" "this" {
  name = var.ecr_repo_name
}

resource "aws_ecs_cluster" "this" {
  name = var.ecs_cluster_name
}

resource "aws_lb" "this" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets
}
                                                           58,1          89%


