output "subnet1_id" {
  value = aws_subnet.subnet1.id
}

output "subnet2_id" {
  value = aws_subnet.subnet2.id
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}
