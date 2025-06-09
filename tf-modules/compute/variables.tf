variable "ec2_instance_type" {
  type = string
}

variable "ecr_repo_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "alb_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}
