provider "aws" {
  region = "us-east-1"
}

module "storage" {
  source = "../../../tf-modules/storage"
 vpc_id               = "vpc-065e7588e40c7c2b3"
 security_group_id     = "sg-06bc8415c084c4a56"
db_subnet_group_name  = "my-db-subnet-group"

}
