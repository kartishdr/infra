
# 1. Create ECR Repository
resource "aws_ecr_repository" "app_repo" {
  name = var.ecr_repo_name
}

# 2. Create ECS Cluster

resource "aws_ecs_cluster" "main" {
  name = var.ecs_cluster_name

}

# Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "ecs-sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_iam_role" "ecs_task_role" {
  name = "ecsTaskExecutionRole"
     assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# Task Definition
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  task_role_arn          = aws_iam_role.ecs_task_role.arn



  container_definitions = jsonencode([
    {
      name  = "nginx"
      image = "nginx:latest"
portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}



# ECS Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx-service"
  cluster         = var.ecs_cluster_id
  launch_type     = "FARGATE"
  desired_count   = 1
  task_definition = aws_ecs_task_definition.nginx.arn

  network_configuration {
    subnets          = var.public_subnets
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}


# 3. Create EC2 Instance (optional - for example/bastion)
resource "aws_instance" "bastion" {
  ami           = var.ec2_ami
  instance_type = var.ec2_instance_type
  subnet_id     = var.subnet_id
  key_name      = var.key_name

  tags = {
    Name = "BastionHost"
  }
}

# 4. Create Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 5. Application Load Balancer
resource "aws_lb" "app_alb" {
  name               = "app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.public_subnets
}

resource "aws_lb_target_group" "app_tg" {
  name     = "app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "app_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
                                                                                                                                                                                              1,0-1         Top
