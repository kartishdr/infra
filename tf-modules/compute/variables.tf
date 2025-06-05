variable "ecr_repo_name" {
  default = "my-app-repo"
}

variable "ecs_cluster_name" {
  type        = string
  default     = "simple-ecs-cluster"
  description = "Name of the ECS cluster"
}



variable "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  type        = string
}


variable "ec2_ami" {
  description = "AMI ID for EC2 instance"
  default     = "ami-084568db4383264d4" # example for Amazon Linux 2
}

variable "ec2_instance_type" {
  default = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet for EC2 instance"
}

variable "key_name" {
  description = "EC2 key pair name"
}

variable "vpc_id" {
  description = "VPC ID for your resources"
}

variable "public_subnets" {
  description = "List of public subnets for the ALB"
  type        = list(string)
}
                          
