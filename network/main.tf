provider "aws" {
  region = "us-east-1"
}

module "network" {
  source = "../../../tf-modules/network"

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
