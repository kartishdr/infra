provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "this" {
  name = "app-cluster"
}


module "compute" {
  source = "../../../tf-modules/compute"


  ecs_cluster_id    = aws_ecs_cluster.this.id
  ecr_repo_name     = var.ecr_repo_name
  ecs_cluster_name  = "app-cluster"
   ec2_ami           = var.ec2_ami
  ec2_instance_type = var.ec2_instance_type
  subnet_id         = var.subnet_id
  key_name          = var.key_name
  vpc_id            = var.vpc_id
  public_subnets  = var.public_subnets
}

