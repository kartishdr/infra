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
resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow RDS access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306            # or 5432 for PostgreSQL
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]   #
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
  Name = "rds-security-group"
  }
}





resource "aws_db_instance" "mydb" {
  allocated_storage    = 20
  engine               = "mysql"             # or "postgres"
  engine_version       = "8.0"
  instance_class       = "db.t3.micro"
   username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql8.0"
  skip_final_snapshot  = true
  publicly_accessible  = false
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}
                      
