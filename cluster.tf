resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "roboshop-${ENV}"
  engine               = "redis"
  node_type            = "cache.t3.large"
  num_cache_nodes      = 1
  parameter_group_name = aws_elasticache_parameter_group.default.name
  engine_version       = "6.2"
  port                 = 6379
  subnet_group_name    = "aws_elasticache_subnet_group.subnet-group.name"
}

resource "aws_elasticache_parameter_group" "default" {
  name   = "roboshop-redis-${ENV}"
  family = "redis6.2"
}

resource "aws_elasticache_subnet_group" "subnet-group" {
  name       = "roboshop-${ENV}"
  subnet_ids = data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS
}