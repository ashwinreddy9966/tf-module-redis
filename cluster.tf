resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${var.ENV}"
  engine               = "redis"
  node_type            = "cache.t3.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default.name
  engine_version       = "6.x"
  port                 = 6379
  subnet_group_name    = "aws_elasticache_subnet_group.subnet-group.name"
  security_group_ids  = [aws_security_group.redis.id]
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "roboshop-redis-${var.ENV}"
  family = "redis6.x"
}

resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "roboshop-${var.ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
}

resource "aws_security_group" "redis" {
  name        = "roboshop-redis-${var.ENV}"
  description = "roboshop-redis-${var.ENV}"
  vpc_id      =  "data.terraform_remote_state.vpc.outputs.VPC_ID"

  ingress {
    description = "Allows Redis Port"
    from_port   = 6379
    to_port     = 6370
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.vpc.outputs.VPC_CIDR]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name =  "roboshop-redis-sg-${var.ENV}"
  }
}