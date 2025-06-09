provider "aws" {
  region = "us-east-1"
}

# Discover the VPC (e.g. the default, or use tag filters)
data "aws_vpc" "existing" {
  default = true
}

# Discover public subnets in that VPC
data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}

module "compute" {
  source            = "../tf-modules/compute"

  vpc_id            = data.aws_vpc.existing.id
  public_subnets    = data.aws_subnets.public.ids

  ec2_instance_type = "t2.micro"
  ecr_repo_name     = "my-ecr-repo"
  ecs_cluster_name  = "my-ecs-cluster"
  alb_name          = "my-alb"
}

