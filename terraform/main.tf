provider "aws" {
  region = "us-east-1"  # You can change to your preferred region
}

module "network" {
  source              = "../tf-modules/network"
}
terraform {
  backend "s3" {
    bucket         = "dev-kpro-ue1-account-no-tf-state"               # S3 bucket name
    key            = "env/us-east-1/network/terraform.tfstate"        # Path inside the bucket
    region         = "us-east-1"                                      # Region of S3 bucket
 #   dynamodb_table = "terraform-locks"                                # Optional: for state locking
    encrypt        = true                                             # Encrypt state at rest
  }
}

module "storage" {
  source              = "../tf-modules/storage"
  depends_on          = [module.network]
   vpc_id               = "vpc-065e7588e40c7c2b3"
 security_group_id     = "sg-06bc8415c084c4a56"
db_subnet_group_name  = "my-db-subnet-group"
}

module "compute" {
  source              = "../tf-modules/compute"
  depends_on          = [module.storage]
  vpc_id            = data.aws_vpc.existing.id
  public_subnets    = data.aws_subnets.public.ids
  ec2_instance_type = "t2.micro"
  ecr_repo_name     = "my-ecr-repo"
  ecs_cluster_name  = "my-ecs-cluster"
  alb_name          = "my-alb"
}
