provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "this" {
  name = "app-cluster"
}


module "compute" {
  source = "../tf-modules/compute"


  ecs_cluster_id    = "arn:aws:ecs:us-east-1:151182331903:cluster/app-cluster"
  ecr_repo_name     = "myecr"
  ecs_cluster_name  = "app-cluster"
   ec2_ami           = "ami-0731becbf832f281e"
  ec2_instance_type = "t2.micro"
  subnet_id         = "subnet-0cdd720102c04a689" 
  key_name          = "anu.pem"
  vpc_id            = "vpc-08ca0bc18af0f4dd3"
  public_subnets  = ["subnet-0cdd720102c04a689", "subnet-0f48222fa480da235"]
}

