provider "aws" {
  region = "us-east-1"  # You can change to your preferred region
}
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-anusha-rani-123456"  # Must be globally unique
  acl    = "private"

  tags = {
    Name        = "MyBucket"
    Environment = "Dev"
  }
}

resource "aws_dynamodb_table" "my_table" {
  name           = "my-dynamodb-table"
  billing_mode   = "PAY_PER_REQUEST"  # On-demand billing (no need to manage throughput)
  hash_key       = "id"               # Primary key

  attribute {
    name = "id"
    type = "S"  # S = String, N = Number, B = Binary
  }

  tags = {
    Environment = "Dev"
    Name        = "MyDynamoDBTable"
  }
}

# Rds db instance

resource "aws_subnet" "subnet1" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.96.0/24"
availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet1"
  }

}

resource "aws_subnet" "subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "172.31.97.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet2"
  }
}


resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB Subnet Group"
  }
}
