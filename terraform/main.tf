provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "this" {
  name = "app-cluster"
}


module "compute" {
  source = "../tf-modules/compute"


  ecs_cluster_id    = arn:aws:ecs:us-east-1:151182331903:cluster/app-cluster
  ecr_repo_name     = myecr
  ecs_cluster_name  = "mycluster"
   ec2_ami           = ami-0731becbf832f281e
  ec2_instance_type = t2.micro
  subnet_id         = subnet-0fec3e10ad8729474 
  key_name          = anu.pem
  vpc_id            = vpc-0f1299c754e4b41a3 
  public_subnets  = ["10.0.0.0/28", "10.0.0.64/28"]
}

