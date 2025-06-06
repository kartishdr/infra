provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "this" {
  name = "app-cluster"
}


module "compute" {
  source = "../tf-modules/compute"

 ecs_cluster_id  = aws_ecs_cluster.main.id         # or your cluster ID
  key_name        = "anu"                           # or from a variable
  subnet_id       = aws_subnet.private_subnet.id           # or from a list
  vpc_id          = aws_vpc.main.id                 # or from data source
  public_subnets  = [aws_subnet.public_subnet, aws_subnet.private_subnet]
}
