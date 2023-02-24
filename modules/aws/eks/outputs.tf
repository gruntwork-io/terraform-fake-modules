output "id" {
  value = local.eks_cluster_name
}

output "name" {
  value = local.eks_cluster_name
}

output "arn" {
  value = local.eks_cluster_arn
}

output "api_server_endpoint" {
  value = local.eks_api_server_endpoint
}

output "allow_list_cidr_blocks" {
  value = var.allow_list_cidr_blocks
}

output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_region_shortname" {
  value = local.aws_region_shortname
}

output "environment" {
  value = var.environment
}

output "namespace" {
  value = var.namespace
}

output "vpc_id" {
  value = var.vpc_id
}

output "tags" {
  value = var.tags
}
