resource "aws_route53_record" "record" {
  zone_id = data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ID
  name    = "redis-${var.ENV}.${data.terraform_remote_state.vpc.outputs.HOSTEDZONE_PRIVATE_ZONE}"
  type    = "CNAME"
  ttl     = "60"
  records = [aws_elasticache_cluster.redis.cache_nodes[0].address]
}

variable "ELASTICACHE_PORT" {}
variable "ELASTICACHE_ENGINE_VERSION" {}
variable "ELASTICACHE_NODE_TYPE" {}
variable "ELASTICACHE_NODE_COUNT" {}