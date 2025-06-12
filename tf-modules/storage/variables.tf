variable "vpc_id" {
  description = "The ID of the VPC where subnets will be created"
  type        = string
}


variable "db_user" {
  default = "admin"
}

variable "db_password" {
  default = "StrongPassword123!"
}

variable "security_group_id" {
  description = "Security group to allow DB access"
}

variable "db_subnet_group_name" {
  description = "DB subnet group (must be pre-created)"
}
