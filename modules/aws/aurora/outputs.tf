output "id" {
  value = local.aurora_cluster_name
}

output "name" {
  value = local.aurora_cluster_name
}

output "arn" {
  value = local.aurora_cluster_arn
}

output "writer_endpoint" {
  value = local.aurora_writer_endpoint
}

output "reader_endpoint" {
  value = local.aurora_reader_endpoint
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

output "engine_name" {
  value = var.engine_name
}

output "engine_version" {
  value = var.engine_version
}

output "port" {
  value = local.port
}

output "tags" {
  value = var.tags
}
