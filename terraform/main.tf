provider "aws" {
  region = "us-east-1"
}


resource "aws_ecs_cluster" "this" {
  name = "app-cluster"
}


module "compute" {
  source = "../tf-modules/compute"
