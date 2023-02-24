output "id" {
  value = local.vpc_id
}

output "name" {
  value = local.vpc_name
}

output "subnet_ids" {
  value = local.subnet_ids
}

output "subnet_names" {
  value = local.subnet_names
}

output "subnet_cidr_blocks" {
  value = local.subnet_cidr_blocks
}

output "subnet_id_cidr_blocks" {
  value = local.subnet_id_cidr_blocks
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

output "tags" {
  value = local.tags
}
