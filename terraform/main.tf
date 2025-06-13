provider "aws" {
  region = "us-east-1"  # You can change to your preferred region
}

module "network" {
  source              = "../tf-modules/network"
}
data "aws_subnets" "in_vpc" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.existing.id]
  }
}
module "storage" {
  source              = "../tf-modules/storage"
  vpc_id              = data.aws_vpc.existing.id
 security_group_id    = "sg-06bc8415c084c4a56"
db_subnet_group_name  = "my-db-subnet-group"
subnet_ids = data.aws_subnets.in_vpc.ids
}
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
