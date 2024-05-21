resource "aws_elasticache_cluster" "example" {
  cluster_id           = "cluster-example"
  engine               = "memcached"
  node_type            = "cache.m4.large"
  num_cache_nodes      = 2
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
  tags = {
    git_commit           = "a419d72d0a65492c3b1c1846e402a845ada6bdde"
    git_file             = "terraform/aws/cache.tf"
    git_last_modified_at = "2023-06-23 14:51:57"
    git_last_modified_by = "93744932+try-panwiac@users.noreply.github.com"
    git_modifiers        = "93744932+try-panwiac"
    git_org              = "Teodelas"
    git_repo             = "terragoat"
    yor_name             = "example"
    yor_trace            = "757809cc-3f43-45fb-85bf-f754dc799367"
  }
}
