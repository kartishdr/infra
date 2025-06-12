resource "aws_subnet" "subnet2" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.1.11.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = false

  tags = {
    Name = "subnet2"
  }
}


resource "aws_db_subnet_group" "my_db_subnet_group" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.subnet1.id, aws_subnet.subnet2.id] # Replace with your actual subnet IDs

  tags = {
    Name = "My DB Subnet Group"
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
  vpc_security_group_ids = [var.security_group_id]
}
